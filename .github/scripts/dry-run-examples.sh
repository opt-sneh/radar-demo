#!/usr/bin/env bash
# Dry run for changed examples: start each one with no flags. A correctly wired example loads and
# stops at "Invalid command line parameters" (exit 2) without calling the Google Ads API.
# A broken or renamed example is reported as "not a valid example name".
# Usage: .github/scripts/dry-run-examples.sh <changed files...>   (build the examples first)
set -uo pipefail
dll=Google.Ads.GoogleAds/examples/bin/Debug/net8.0/Google.Ads.GoogleAds.Examples.dll
export DOTNET_ROLL_FORWARD=Major # lets a machine with only a newer runtime run the net8.0 build
[[ -f "$dll" ]] || { echo "Build the examples first: $dll not found"; exit 1; }

checked=0; failed=0
for file in "$@"; do
  [[ "$file" == Google.Ads.GoogleAds/examples/*.cs && -f "$file" ]] || continue
  version=$(grep -oE 'namespace Google\.Ads\.GoogleAds\.Examples\.V[0-9]+' "$file" | head -1 | grep -oE 'V[0-9]+$')
  class=$(grep -oE 'public class [A-Za-z0-9_]+ *: *ExampleBase' "$file" | head -1 | awk '{print $3}')
  if [[ -z "$version" || -z "$class" ]]; then echo "skip  $file (not an example)"; continue; fi
  name="$version.$class"
  output=$(dotnet "$dll" "$name" < /dev/null 2>&1)
  checked=$((checked + 1))
  if grep -qF "Loaded: '$name'" <<< "$output" && ! grep -q "not a valid example name" <<< "$output"; then
    echo "ok    $name"
  else
    echo "FAIL  $name ($file)"; head -20 <<< "$output"; failed=$((failed + 1))
  fi
done
echo "Dry run: $checked example(s) checked, $failed failed."
[[ $failed -eq 0 ]]
