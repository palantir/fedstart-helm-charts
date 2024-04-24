#!/usr/bin/env bash

set -euo pipefail

main() {
  : "${GH_TOKEN:?Environment variable GH_TOKEN must be set}"

  local repo_root
  repo_root=$(git rev-parse --show-toplevel)
  pushd "$repo_root" >/dev/null

  echo "Looking up latest git tag..."
  local latest_tag
  latest_tag=$(latest_git_tag)

  echo "Finding charts that have changed since '$latest_tag'..."
  local changed_charts=()
  readarray -t changed_charts <<<"$(charts_with_changes "$latest_tag")"

  if [[ -n "${changed_charts[*]}" ]]; then
    for chart in "${changed_charts[@]}"; do
      if [[ -d "$chart" ]]; then
        chart_name=$(yq eval .name "${chart}/Chart.yaml")
        chart_version=$(yq eval .version "${chart}/Chart.yaml")
        gh release view $chart_name-$chart_version >/dev/null 2>&1
        if [ $? -eq 0 ];then
          echo "Release '$chart_name-$chart_version' already exists...skipping."
        else
          echo "Creating release '$chart_name-$chart_version'"
          gh release create $chart_name-$chart_version
        fi
      else
        echo "No changes found for '$chart'."
      fi
    done
  else
    echo "No changes found for any chart."
  fi

  popd >/dev/null
}

latest_git_tag() {
  git fetch --tags >/dev/null 2>&1
  if ! git describe --tags --abbrev=0 HEAD~ 2>/dev/null; then
    git rev-list --max-parents=0 --first-parent HEAD
  fi
}

charts_with_changes() {
  local commit="$1"
  local charts_dir=charts/*
  local changed_files
  changed_files=$(git diff --find-renames --name-only "$commit" -- "$charts_dir")

  local depth=$(($(tr "/" "\n" <<<"$charts_dir" | sed '/^\(\.\)*$/d' | wc -l) + 1))
  local fields="1-${depth}"

  cut -d '/' -f "$fields" <<<"$changed_files" | uniq | filter_charts
}

filter_charts() {
  while read -r chart; do
    [[ ! -d "$chart" ]] && continue
    local file="$chart/Chart.yaml"
    if [[ -f "$file" ]]; then
      echo "$chart"
    else
      echo "Skipping '$chart' as $file is missing." 1>&2
    fi
  done
}

main "$@"
