#!/bin/sh
set -eu
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
export_dir=$(mktemp -d /tmp/CampusConnectStudent.XXXXXX)
cp -R "$project_dir/CampusConnect" "$project_dir/CampusConnect.xcodeproj" "$export_dir/"
cp "$project_dir/README.md" "$export_dir/README.md"
find "$export_dir" -type d -name xcuserdata -exec rm -rf {} +
printf 'Student project exported to %s\n' "$export_dir"
