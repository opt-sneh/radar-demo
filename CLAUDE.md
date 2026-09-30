# Fixing radar Issues

Google's `google-ads-dotnet` examples at `v25.1.0` (Google Ads API v23). Ad API Radar keeps one Issue listing every finding for the upgrade, grouped by file; one `@claude fix this` must fix them all in one pull request. A person reviews every fix, so an honest "not verified" is better than a wrong "done".

## Rules

- **IMPORTANT:** Fix every finding in the Issue, in one pull request, and nothing else. No reformatting, renaming or refactoring; small diffs are what make review possible.
- **IMPORTANT:** Keep the feature working. Use the replacement Google documents (quoted in the Issue's evidence); never delete the code that used a removed field.
- Never edit `LICENSE`, `THIRD-PARTY-LICENSE.txt`, `GoogleAds.snk`, `Examples.slnx` or `.github/`.
- Never push to `main`, merge, or turn off warnings-as-errors.

## Moving to a newer API version

Findings "removed in v24/v25" need the newer API:
1. Set `Google.Ads.GoogleAds` to `26.1.0` in `Google.Ads.GoogleAds/examples/Google.Ads.GoogleAds.Examples.csproj` (first SDK with V25).
2. In each file the Issue lists, move every API reference to V25: `using Google.Ads.GoogleAds.V23…` and `Services.V23.…`. **Keep** the file's own `namespace Google.Ads.GoogleAds.Examples.V23`; it is the example's name, and other files refer to it.
3. **The SDK bump can break files you did not touch** (26.1.0 drops SDK helpers such as `PartialFailure` from V23). Build the whole project; for each newly broken file, move its API references to V25 the same way and change nothing else. List those files in the PR under "Required by the SDK bump".

## Verify before you say it is fixed

Run all three and read the output. All must pass.

```
dotnet build Google.Ads.GoogleAds/examples/Google.Ads.GoogleAds.Examples.csproj -f net8.0
bash .github/scripts/dry-run-examples.sh <every file you changed>
grep -oE '\b(GoogleAds|Services)\.V[0-9]+\b' <file> | grep -oE 'V[0-9]+' | sort -u   # one version per file
```

- The build must end with `0 Warning(s)` and `0 Error(s)`.
- The dry run starts each changed example without credentials and must print `ok` for each. It never calls the API.
- If a check fails, fix it and rerun all three. If you cannot make them pass, do not open a pull request: comment on the Issue with what failed and the output.

## Pull request

- Open one **draft** with `gh pr create --draft`, titled `Fix radar #<issue>: API upgrade v23 -> v25`.
- Body: one line per finding (numbered as in the Issue) with what changed, the "Required by the SDK bump" list if any, `Fixes #<issue>`, and the tail of each check's output.
- The `build` workflow reruns these checks on the pull request and must be green.
