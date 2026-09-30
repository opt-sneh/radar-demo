# radar-demo

A test target for **Ad API Radar**, the tool that finds code affected by Google Ads and Microsoft Advertising API upgrades.

This repository holds a copy of the examples from Google's public [google-ads-dotnet](https://github.com/googleads/google-ads-dotnet) client library at tag `v25.1.0`, which targets Google Ads API **v23**. Google later moved these examples to API **v25** in tag `v26.1.0`; that change is the answer key radar is scored against.

The code is Google's, under the Apache License 2.0 (see `LICENSE` and `THIRD-PARTY-LICENSE.txt`). It is copied unchanged apart from the added `Examples.slnx`, this README and the workflows.

## How it works

| Workflow | Trigger | What it does |
|---|---|---|
| `radar-scan` | Manual run or Mondays 06:00 UTC | Runs radar, uploads the HTML report, and keeps one Issue per actionable finding |
| `radar-fix` | Comment `@claude fix this` on a `radar` Issue | Claude fixes it on a `radar/fix-…` branch and opens a draft pull request |
| `build` | Pushes to `radar/fix-…` branches and every pull request | Builds the examples, so each fix shows a pass or fail check |

Nothing merges automatically. Every fix is a draft pull request for a person to review.

## Secrets

| Secret | Used by | What it is |
|---|---|---|
| `RADAR_REPO_TOKEN` | `radar-scan` | Fine-grained token with read access to the private `ad-api-radar` repository |
| `CLAUDE_CODE_OAUTH_TOKEN` | `radar-fix` | Output of `claude setup-token` (Claude Pro or Max) |

## Build locally

```
dotnet build Google.Ads.GoogleAds/examples/Google.Ads.GoogleAds.Examples.csproj -f net8.0
```
