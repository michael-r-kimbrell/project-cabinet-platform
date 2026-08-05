# 1 Thomas Village - Move-In Timeline

Target: mid-to-late September 2026. Schedule origin: 2026-08-05.

Durations below are the operator's numbers and were not changed. What changed
is sequencing, supplier lead times, and the move-in gate. See
[What was wrong with the first pass](#what-was-wrong-with-the-first-pass).

## Timeline

```mermaid
gantt
    title 1 Thomas Village Move-In Timeline (target mid-to-late September)
    dateFormat  YYYY-MM-DD
    axisFormat  %b %d
    todayMarker on

    section Orders (this week)
    Order cabinet doors/drawer fronts (long pole)   :crit, order1, 2026-08-05, 3d
    Order in-stock stove/oven combo                 :order2, 2026-08-05, 2d
    Order Mr. Cool unit                             :order3, 2026-08-05, 2d
    Order laminate countertop, sink, faucet         :order4, 2026-08-05, 3d
    Schedule sub for downstairs bath                :order5, 2026-08-05, 2d
    Confirm painter schedule                        :order6, 2026-08-05, 2d

    section Supplier lead times (CONFIRM)
    Doors/fronts in production and transit          :crit, lead1, after order1, 28d
    Countertop fabrication and pickup               :lead4, after order4, 10d
    Stove/oven delivery                             :lead2, after order2, 7d
    Mr. Cool delivery                               :lead3, after order3, 7d

    section Kitchen prep (during lead time)
    Finish demo (trim, ceiling panels)              :k1, after order5, 3d
    Structural rough-in (stove space, pantry conv.) :k2, after k1, 4d
    Surface prep (self-level, sand/putty)           :k3, after k2, 4d
    Painter - face frames, window, trim, fireplace  :k4, after k3, 5d
    Mr. Cool install                                :k11, after k2 lead3, 2d

    section Kitchen install (gated on doors)
    Cabinet doors install                           :crit, k5, after lead1 k4, 3d
    Build new drawers                               :crit, k6, after k5, 2d
    Countertop/sink/faucet install                  :crit, k7, after k6 lead4, 3d
    Flooring install                                :crit, k9, after k7, 3d
    Stove/oven install                              :k8, after k9 lead2, 2d
    Trim/shoe molding                               :crit, k10, after k9, 2d
    Lighting fixtures                               :crit, k12, after k10 k4, 2d
    Punch list and buffer                           :crit, k13, after k12 k8, 3d

    section Upstairs bathrooms (x2)
    Plumbing (under-sink, misc.)                    :u1, after order5, 3d
    Vanity/countertop refinish                      :u2, after u1, 3d
    Tile sealing (shower/tub)                       :u3, after u1, 2d
    Painter - tile floor, walls                     :u4, after u3, 3d
    Fixtures (handles, heads, light fixtures)       :u5, after u4 u2, 2d

    section Upstairs hall + bedrooms
    Trim removal/replacement                        :h1, after order5, 3d
    Flooring on MDF subfloor (no adhesive-set)      :h2, after h1, 4d
    Painter - touch-up                              :h4, after h2, 2d
    Ceiling fans + light fixtures                   :h3, after h4, 2d

    section Downstairs bathroom
    Sub - toilet, grout/seal, paint, floor, trim    :d1, after order5, 10d
    Your scope - vanity, countertop, sink, faucet   :d2, after d1, 4d
    Shower door + handles                           :d3, after d2, 2d

    section Move-in
    Move family back in                             :milestone, movein, after k13 u5 h3 d3, 0d
```

**Computed move-in: 2026-09-23.** Dates below are mermaid's own computed
values, read out of the parsed chart, not estimated by hand. Calendar days,
no weekend exclusion.

## The one number that decides the date

Everything hinges on cabinet door lead time. The 28-day (4-week) figure in
the chart is an **assumption, not a quote**. Confirm it with the supplier
before treating any of this as a plan. The slip is 1:1 - every day of door
lead time is a day of move-in.

| Door lead time | Doors arrive | Move-in |
| --- | --- | --- |
| 2 weeks | 2026-08-22 | 2026-09-10 |
| 3 weeks | 2026-08-29 | 2026-09-16 |
| **4 weeks (assumed)** | **2026-09-05** | **2026-09-23** |
| 5 weeks | 2026-09-12 | 2026-09-30 |
| 6 weeks | 2026-09-19 | 2026-10-07 |
| 8 weeks | 2026-10-03 | 2026-10-21 |
| 10 weeks | 2026-10-17 | 2026-11-04 |

Anything past a 5-week door lead time misses September. The other three lead
times (countertop 10d, stove 7d, Mr. Cool 7d) have slack and are not on the
critical path; they are placeholders too, but getting them wrong costs
nothing until they exceed roughly four weeks.

## Critical path

order1 -> lead1 (doors) -> k5 install -> k6 drawers -> k7 countertop ->
k9 flooring -> k10 trim -> k12 lighting -> k13 punch list -> move-in.

Nothing else comes close. Both upstairs bathrooms finish 2026-08-17, the hall
and bedrooms 2026-08-18, and the downstairs bathroom 2026-08-23 - all more
than a month of float. If effort is short, it belongs on the kitchen.

## What was wrong with the first pass

The original chart did not render at all, and its move-in milestone landed
2026-08-18, about five weeks earlier than its own stated target.

**Syntax (chart would not display):**

1. `Call sub re: downstairs bath scheduling` - a task whose text begins with
   `Call` collides with mermaid's `call` callback keyword. Hard parse error.
2. Five task names contained a colon (`Painter:`, `Sub:`, `Your scope:`).
   These pass `mermaid.parse()` but produce tasks with no start time, so the
   chart throws while compiling and never draws. Colons are now hyphens.

**Schedule logic:**

3. **No lead times existed.** Every install was wired `after <order task>`,
   meaning it started the day the order was *placed*. Doors were labeled the
   long pole but modeled as a 14-day bar starting 2026-08-08. That single
   modeling choice is what collapsed the whole schedule into August.
4. **Installs preceded their prerequisites.** Countertop install ran
   2026-08-08 to 08-11, before demo finished (08-10), before surface prep,
   and before any cabinet doors existed. Stove install finished 08-09, five
   days before the stove space rough-in was done. Flooring finished 08-14,
   nine days before the painter left.
5. **The move-in milestone was gated on one task.** It fired `after k12`
   (kitchen lighting) only, so it triggered 2026-08-18 while six tasks were
   still open, including kitchen drawers (to 08-24) and the downstairs
   bathroom shower door (to 08-23). It now waits on all four work streams.

**Added:** a 3-day punch list and buffer before move-in. Adjust or delete if
you would rather carry the risk.

## Open questions for the operator

- Actual quoted lead time on the doors and drawer fronts. Everything else is
  noise until this is a real number.
- Does the countertop need the cabinets in place for templating? The chart
  assumes yes (k7 waits on k6), which costs about three days. If the fabricator
  templates off the existing face frames, that can start earlier.
- Flooring is scheduled after the countertop and before the stove, so the
  range sits on finished floor. Confirm that matches how you want it done.
- Calendar days are used throughout, weekends included. If the sub and painter
  work weekdays only, add `excludes weekends` to the chart and the dates will
  stretch by roughly 40 percent.
