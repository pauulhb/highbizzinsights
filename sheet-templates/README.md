# HB Insights Google Sheet

One Google Sheet named e.g. **"HB Insights"**, with these three tabs. Import
the matching CSV in this folder into each tab (Google Sheets: File → Import →
Upload → Insert new sheet, or paste the header row directly), then rename the
resulting tab to match.

## `Clients`

| column | meaning |
|---|---|
| `name` | Display name used in the artifact title (`HB Insights — <name>`) and header. Keep it stable — renaming a client here breaks the "find by title" match and creates a duplicate artifact next month. |
| `slug` | Short lowercase id, e.g. `riverside-dental`. Used to match `Blogs`/`Social` rows to this client — keep it consistent across all three tabs. |
| `domain` | Client's website, for reference/display only. |
| `gads_dataset_id` | Coupler dataset id for this client's Google Ads dataflow. Blank = not connected yet (Search Console tab renders empty-state). |
| `gsc_dataset_id` | Coupler dataset id for this client's Search Console dataflow. Blank = not connected. |
| `meta_dataset_id` | Coupler dataset id for this client's Meta Ads dataflow. Blank = not connected. |
| `linkedin_dataset_id` | Coupler dataset id for this client's LinkedIn dataflow. Blank = not connected. |

One row per client. Add a row to onboard a client, delete a row to offboard —
the routine prompt never needs editing.

## `Blogs`

| column | meaning |
|---|---|
| `client` | Must match a `slug` (or `name`, pick one convention and use it consistently) in `Clients`. |
| `month` | `YYYY-MM`, e.g. `2026-07`. |
| `blogs_published` | Integer count of blog posts published for that client that month. |

One row per client per month. Update it manually before the routine runs on
the 1st (or any time before — the routine reads whatever is there at run
time).

## `Social`

| column | meaning |
|---|---|
| `client` | Must match a `slug`/`name` in `Clients`, same convention as `Blogs`. |
| `month` | `YYYY-MM`. |
| `platform` | e.g. `Instagram`, `Facebook`, `X`. |
| `followers` | Follower count at end of that month, for that platform. |

One row per client per platform per month.

## Setting it up

1. Create a new Google Sheet, name it `HB Insights`.
2. Create three tabs named exactly `Clients`, `Blogs`, `Social` (the routine
   prompt looks up tabs by these exact names).
3. Import each CSV in this folder as the header row for the matching tab.
4. Add the first real client row to `Clients` — this account already has one
   Google Ads Coupler dataflow live; paste its dataset id into
   `gads_dataset_id` for that row.
5. Add at least one `Blogs` and one `Social` row for that client/month so the
   first test run has manual data to show alongside Google Ads.
6. Copy the Sheet's URL (or file id) into `routine/routine-prompt.md` in place
   of `<SHEET_URL_OR_ID>` before creating the recurring trigger.
