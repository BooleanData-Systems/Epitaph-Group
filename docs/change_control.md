# Change control

Agreed in KPI sign-off rule R01: after 13 Nov 2026, a change to a KPI or to a conversion action that counts goes
through a written change request approved by the product owner.

## What needs a change request
- A new KPI, or a change to how one is calculated (`config/kpis.yml`).
- A conversion action added to or removed from a client's counted conversions (`seeds/map_conversion_tag.csv`).
- A change to a check tolerance (`seeds/dq_tolerances.csv`).
- A Smart Campaign rule that moves campaigns between dashboards (`seeds/map_smart_campaign_rule.csv`).

## What does not
- Layout, titles, colours and chart types on a dashboard.
- A new campaign that follows the naming convention and maps by an existing rule.
- Fixes to the pipeline that do not change any number on a dashboard.

## How
1. Open a GitHub issue using the "Change request" label: what changes, why, which dashboards, from which date.
2. The product owner (Nathan Sennema) approves in the issue. Mike DeOliveira approves anything that changes
   numbers already sent to a client.
3. The change is made in a pull request that links the issue. The `decision` field in `config/kpis.yml` or the
   `approved_by` column in the seed records the approval.
4. CI checks and deploys. The comparison checks run the next morning; the change is closed when they pass.
