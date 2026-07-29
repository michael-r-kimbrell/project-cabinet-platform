# Visualization Prompt Templates
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

Ready-to-use prompt templates for every chart type in the visualization taxonomy. When a user asks "give me a prompt for X chart", the viz skill can return the matching block verbatim. Each template uses `[placeholders]` for the consumer to fill in.

Companion to `taxonomy.md`. Grounded in the public canon of Stephen Few and Andy Kriebel.

---

## PROJECT

```
Gantt Chart: Create an executive-level Gantt for [project] with phases, key tasks, milestones, owners, dates, and dependencies. Summarize delivery risks and assumptions.
```

```
Roadmap: Create a 12–18 month roadmap for [initiative] by quarter with themes, outcomes, key milestones, and dependencies. Keep it executive-ready.
```

```
PERT Chart: Create a PERT chart for [project]. Include tasks, estimated durations (optimistic/most likely/pessimistic if available), dependencies, and identify the critical path.
```

```
Critical Path Analysis: Identify the critical path for [project]. List critical tasks, float, key risks, and recommend mitigation actions to protect the end date.
```

```
RACI Matrix: Build a RACI for [project/process]. For each activity, assign R (Responsible), A (Accountable), C (Consulted), I (Informed) and flag gaps/conflicts.
```

```
Capacity / Resource Utilization: Analyze capacity vs demand for [team/program] over the next [time horizon]. Highlight over/under allocation by role and recommend rebalancing actions.
```

```
Burndown / Burnup Charts: Create burndown and burnup charts for [team/release] showing progress, scope change, velocity, and a forecast to completion. Summarize blockers.
```

---

## STRATEGY

```
SWOT Analysis: Create a SWOT for [org/product/initiative]. Provide 3–5 evidence-based bullets per quadrant and conclude with 3 strategic implications and recommended actions.
```

```
PESTLE / PESTEL: Create a PESTLE for [market/industry]. Identify key trends, risks, and opportunities per dimension and rate each by impact and time horizon.
```

```
Porter's Five Forces: Analyze Porter's Five Forces for [industry]. For each force, provide evidence and conclude on overall attractiveness and strategic implications.
```

```
Ansoff Matrix: Build an Ansoff Matrix for [business]. Propose initiatives in each quadrant and rank them by risk, investment, and expected impact.
```

```
BCG Matrix: Create a BCG Matrix for [portfolio]. Place each offering using defined metrics and recommend actions (invest/hold/harvest/divest).
```

```
Value Chain Analysis: Analyze the value chain for [company/process]. Identify primary/support activities, where value is created, pain points, and 5 improvement opportunities with impact.
```

```
OKR / KPI Frameworks: Define OKRs for [team/function] aligned to [strategy]. For each KR, propose KPIs, baselines, targets, owners, and reporting cadence.
```

---

## RISK

```
Heat Maps: Create a heat map for [topic] across [dimension 1] and [dimension 2]. Define scoring (1–5), populate with examples, and call out top 5 hotspots.
```

```
Risk Matrix: List top risks for [program], score probability and impact, plot on a matrix, and provide mitigation actions, owners, and due dates.
```

```
FMEA: Conduct an FMEA for [process/product]. List failure modes, causes, effects, existing controls, severity/occurrence/detection, RPN, and recommended actions.
```

```
Issue Trees / Problem Trees: Create an issue tree for [problem]. Break it down MECE into 2–3 levels, suggest hypotheses for each leaf, and list data needed to validate.
```

```
Decision Trees: Build a decision tree for [decision]. Include options, outcomes, probabilities, costs/benefits, expected value, and recommendation.
```

```
Scenario Analysis: Create 3 scenarios (best/worst/likely) for [topic] over [time horizon]. For each: assumptions, signals/triggers, impacts, and recommended actions.
```

---

## DATA

```
Bar / Line / Area Charts: Recommend the best chart type (bar/line/area) to show [metric] by [dimension/time]. Create the chart and write 2 insight bullets.
```

```
Scatter Plots: Create a scatter plot of [X] vs [Y], add a trendline, segment by [group], and summarize correlation and outliers.
```

```
Waterfall Charts: Build a waterfall chart explaining the change in [metric] from [start] to [end]. Identify major drivers and provide 3 takeaway insights.
```

```
Pareto Analysis: Run a Pareto analysis for [categories] driving [outcome]. Identify the top contributors to reach 80% and recommend focus actions.
```

```
Control Charts: Create a control chart for [process metric] over time with control limits and flag any out-of-control signals and recommended actions.
```

```
Time Series Analysis: Analyze [metric] over [time range]. Identify trend/seasonality, key inflection points, and forecast next [period] with confidence range.
```

```
Benchmarking Analysis: Benchmark [org] against [peers] on [metrics]. Normalize definitions, show gaps, and recommend 3 improvement opportunities.
```

---

## PROCESS

```
Process Maps / Flowcharts: Create a current-state process map for [process] including steps, decisions, handoffs, inputs/outputs, and pain points.
```

```
Swimlane Diagrams: Create a swimlane diagram for [process] with lanes for [roles]. Highlight handoffs, delays, and rework loops.
```

```
SIPOC Diagrams: Create a SIPOC for [process]: Suppliers, Inputs, Process (5–7 steps), Outputs, Customers. Note key assumptions and constraints.
```

```
Value Stream Mapping: Create a value stream map for [process] including cycle times, wait times, WIP, rework, and improvement opportunities ranked by impact.
```

```
Service Blueprints: Create a service blueprint for [service] including customer actions, frontstage interactions, backstage processes, supporting systems, and failure points.
```

```
Bottleneck Analysis: Identify bottlenecks in [process]. Quantify throughput, cycle time, queue time, and recommend actions to relieve the constraint.
```

---

## CX

```
Customer Journey Maps: Create a customer journey map for [persona] across [stages]. Include actions, emotions, pain points, moments of truth, and opportunities.
```

```
Persona Analysis: Create 3–5 personas for [product/service] based on [data sources]. For each: goals, behaviors, needs, frustrations, and JTBD.
```

```
Voice of Customer (VoC): Analyze VoC data for [channel/time]. Identify top themes, drivers of satisfaction/dissatisfaction, and 5 prioritized improvement actions with impact.
```

```
NPS Analysis: Analyze NPS for [product/service] by segment and over time. Identify key drivers from verbatims and recommend actions to improve.
```

```
Cohort Analysis: Run a cohort analysis for [users] grouped by [cohort definition]. Show retention/usage over time and interpret differences with hypotheses.
```

```
Churn Analysis: Analyze churn for [customer base]. Segment by [attributes], identify key drivers/leading indicators, and propose 5 interventions ranked by impact/effort.
```

---

## SYSTEMS

```
Ecosystem Maps: Create an ecosystem map for [industry/platform]. Identify key players, roles, value flows, and partnership opportunities.
```

```
Stakeholder Maps: Map stakeholders for [initiative] by influence and interest. Recommend engagement strategies per group and key messages.
```

```
Influence / Power-Interest Grids: Create a power–interest grid for [stakeholders]. For each stakeholder, propose engagement approach and cadence.
```

```
Network Graphs: Create a network graph for [entities] showing relationships. Identify central nodes, clusters, and implications for risk/opportunity.
```

```
Dependency Maps: Map dependencies for [program]. Include owners, due dates, risk level, and escalation paths for critical dependencies.
```

---

## ADVANCED

```
Regression Analysis: Run a regression to model [outcome] using predictors [X]. Provide coefficients, significance, model fit, and plain-language interpretation with caveats.
```

```
Forecasting Models: Forecast [metric] for the next [horizon] using [method/data]. Include confidence interval, assumptions, and scenario variants.
```

```
Sensitivity Analysis: Perform sensitivity analysis on [model]. Vary key inputs by ±[range], show impact on [output], and summarize most sensitive drivers.
```

```
Monte Carlo Simulations: Run a Monte Carlo simulation for [decision/model] using distributions for [inputs]. Output 10th/50th/90th percentiles and risk of missing targets.
```

```
Clustering / Segmentation: Cluster [dataset] into segments. Describe each segment profile, size, key behaviors, and recommended actions per segment.
```

```
Machine Learning Models: Build an ML model to predict [outcome]. Define features, training/validation approach, metrics, and provide feature importance and deployment considerations.
```

---

## EXECUTIVE

```
Dashboards: Design an executive dashboard for [function]. Include KPIs, targets, trends, filters, and 3 key insights with actions.
```

```
Scorecards: Create a scorecard for [team]. Include KPI, definition, baseline, target, actual, status (R/A/G), owner, and actions.
```

```
Executive One-Pagers: Create an executive one-pager on [topic] with: headline takeaway, context, key insights (3–5), recommendation, risks, and next steps.
```

```
Infographics: Create an infographic outline for [topic] with sections, key stats, icons, and a clear narrative flow. Keep it simple and executive-friendly.
```

```
Signal vs Noise Charts: Simplify [dataset/story] into a signal-vs-noise view: choose the best chart, remove clutter, annotate key insights, and write the executive takeaway.
```
