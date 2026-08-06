# HB Insights

Monthly per-client marketing reports for Highbizz clients, delivered as one
shareable Claude Artifact per client, kept up to date by a recurring Claude
Routine. No website, no server, no database — see the original spec in the
repo's issue history for the full design.

```
routine/            self-contained prompt for the recurring monthly Routine
artifacts/           the per-client Artifact template (design + structure)
sheet-templates/     Clients / Blogs / Social tab schemas + starter CSVs
```

## Status (2026-08-06)

### Validated
- **Artifacts are publishable from a cloud session.** Published a demo of
  `artifacts/artifact-template.html` with sample data — this resolves the
  biggest fallback risk in the original plan (no need for the email/repo
  delivery fallback).
- **Coupler.io is a real claude.ai connector**, not just a local MCP server —
  found in the connector registry with `get-schema`, `get-data`,
  `list-dataflows`, `get-dataflow` tools. This was the other open unknown.
  **It is not installed for this org yet** — connect it at
  [claude.ai/customize/connectors](https://claude.ai/customize/connectors)
  before the routine can reach it (this is a one-time browser OAuth step only
  a human can do; a Claude session can't self-authorize a new connector).

### Reconsidered
- The original plan assumed a dedicated "Google Sheets" connector. **There
  isn't one in the registry** — the closest thing is **Google Drive**, which
  is already connected and enabled in this org (`create_file`,
  `read_file_content`, `search_files`, etc.). The routine only ever *reads*
  the HB Insights sheet (it writes reports as Artifacts, not back to the
  sheet), so Drive's read access should be sufficient — worth confirming with
  one real read of the sheet once it exists (see Build order step 4 below),
  but this likely removes a prerequisite rather than blocking anything.

### Not yet done (needs your action)
- The HB Insights Google Sheet itself doesn't exist yet — templates are ready
  in `sheet-templates/`, but creating the actual sheet, and adding the first
  real client's name/domain/`gads_dataset_id`, has to happen in Google
  Sheets/Drive directly.
- Coupler.io connector not installed org-wide (see above).
- GSC / Meta / LinkedIn Coupler dataflows not connected — only Google Ads
  exists today, for one client.
- The recurring Routine itself hasn't been created — `routine/routine-prompt.md`
  has the full prompt ready to paste in, but it needs the real Sheet URL
  filled in and Coupler connected first.

## Build order

1. ~~Draft routine prompt + artifact template~~ — done, see `routine/` and
   `artifacts/`.
2. ~~Validate Artifacts publish from a cloud session~~ — done.
3. Create the HB Insights Google Sheet (3 tabs) from `sheet-templates/`, add
   the first real client row with their Google Ads Coupler dataset id.
4. Connect the Coupler.io connector at claude.ai/customize/connectors.
5. Test run: paste `routine/routine-prompt.md` into a one-off chat (not yet a
   scheduled Routine) with the real sheet URL filled in, and confirm it can
   read the sheet via Google Drive, pull the one live Google Ads dataset, and
   publish/update that client's artifact.
6. Iterate on the template/prompt from what the test run surfaces; share that
   client's artifact link once (sharing persists across future updates).
7. Connect GSC / Meta / LinkedIn Coupler dataflows as they come online.
8. Create the recurring Routine (`create_trigger`, cron `0 3 1 * *` = 1st of
   month 08:30 IST, `create_new_session_on_fire: true`, connectors
   `["Coupler.io", "Google Drive"]`, prompt = `routine/routine-prompt.md`
   with the Sheet URL filled in).

## Per-client Artifact

`artifacts/artifact-template.html` — self-contained, theme-aware, six
client-side tabs (Search Console, Google Ads, Meta Ads, Blogs published,
Organic social growth, LinkedIn), each with KPI tiles (current value + MoM
delta), one inline-SVG this-month-vs-last-month bar chart, a short summary
paragraph, and an empty state for sources not yet connected for that client.
Currently populated with sample data reflecting today's real connection
state (Google Ads connected; GSC/Meta/LinkedIn not) so it doubles as an
accurate preview of the first real test run.

Every future monthly run should follow this file's structure/CSS/JS pattern
exactly and only swap in that month's data and summaries — see
`routine/routine-prompt.md` step 6.

## Multi-client model

Model A: one Coupler dataflow (and dataset id) per client per source — see
`sheet-templates/README.md`. Onboarding a client = one new `Clients` row +
one dataflow per connected source; no code or prompt changes.
