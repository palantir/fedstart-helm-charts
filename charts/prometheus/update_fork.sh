#!/usr/bin/env bash
set -euo pipefail

# VARIABLES
GITREPO="https://github.com/prometheus-community/helm-charts.git"
GITTAG="prometheus-25.18.0"

# GITREPO_SUBCHART_PATHS and SUBCHART_DIRS are two lists that are directly related. The lengths and indices of entries
# should correspond with one another.
GITREPO_SUBCHART_PATHS=(
  "charts/prometheus"
  "charts/alertmanager"
)
SUBCHART_DIRS=(
  "$PWD/charts/prometheus"
  "$PWD/charts/prometheus/charts/alertmanager"
)
PATCHES_DIR="$PWD/subchart-patches"

# SCRIPT - DO NOT EDIT BELOW
BUILDDIR="./build"
rm -rf "$BUILDDIR"
mkdir "$BUILDDIR"

pushd build
  echo "INFO: Cloning subchart git repo..."
  git clone --no-checkout --quiet --depth=1 --filter=tree:0 "$GITREPO" --branch="$GITTAG"
  REPONAME="$(basename "$GITREPO" ".git")"
  pushd "$REPONAME"

    git sparse-checkout set --no-cone $(printf "%s " "${GITREPO_SUBCHART_PATHS[@]}")
    git checkout --quiet
  popd
popd

echo "INFO: Copying new subchart into directory..."
for i in "${!SUBCHART_DIRS[@]}"; do
  mkdir -p ${SUBCHART_DIRS[$i]} || true
  rm -rf "${SUBCHART_DIRS[$i]}"
  mv "$BUILDDIR/$REPONAME/${GITREPO_SUBCHART_PATHS[$i]}" "${SUBCHART_DIRS[$i]}"
done

if [[ -d "$PATCHES_DIR" ]]; then
  echo "INFO: Applying subchart patches..."
  for patch in "$PATCHES_DIR"/*; do
    echo "DEBUG: Applying patch: $patch"
    patch < "$patch"
  done
fi

echo "INFO: Successfully updated subchart to: $GITTAG"
