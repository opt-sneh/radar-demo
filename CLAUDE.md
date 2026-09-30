# radar-demo: rules for fixing radar Issues

This repository is a copy of Google's `google-ads-dotnet` examples at tag `v25.1.0` (Google Ads API v23). Ad API Radar opens Issues for code that breaks or changes behaviour in newer API versions. These rules apply every time you are asked to fix one.

## Scope

- Fix every finding listed in the Issue, and nothing else. Do not reformat, rename or refactor unrelated code.
- Keep behaviour the same: replace a removed field or type with its documented replacement instead of deleting the feature. The Issue's evidence quotes Google's release notes; use them.
- Do not edit `LICENSE`, `THIRD-PARTY-LICENSE.txt`, `GoogleAds.snk`, `Examples.slnx` or anything under `.github/`.

## Moving to a newer API version

- A finding marked "removed in v24" or "v25" needs the newer API. Bump the `Google.Ads.GoogleAds` package in `Google.Ads.GoogleAds/examples/Google.Ads.GoogleAds.Examples.csproj` to `26.1.0`. It ships V25 and still ships V23, so the other files keep building.
- Move only the files named in the Issue from `Google.Ads.GoogleAds.V23` to `Google.Ads.GoogleAds.V25` (usings, `Services.V23.…` and every other `V23` reference in those files).

## Build

- The build must pass before you open a pull request:
  `dotnet build Google.Ads.GoogleAds/examples/Google.Ads.GoogleAds.Examples.csproj -f net8.0`
- Warnings are errors in this project. Fix warnings you introduce; do not turn the setting off.

## Pull request

- Work on your own branch. Never push to `main` and never merge.
- Open a **draft** pull request with `gh pr create --draft`.
- Title: `Fix radar #<issue number>: <file name>`.
- Body: one line per finding saying what changed, `Fixes #<issue number>`, and the last lines of the build output.
