# Visualization Taxonomy
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

A chart selection taxonomy organized by domain and story type. Use it to map a question to a viable visualization, then narrow by audience and complexity before committing.

Draws on the public canon of Stephen Few (perception, dashboard design) and Andy Kriebel (practical visual storytelling).

---

## Story Types

Pick the primary story the data needs to tell. Most charts only do one well.

- `COMPARISON`  -  comparing values across categories or entities
- `TREND`  -  change over time
- `DISTRIBUTION`  -  spread, frequency, or shape of data
- `CORRELATION`  -  relationship between two or more variables
- `COMPOSITION`  -  how parts make up a whole
- `FLOW`  -  process, steps, handoffs, sequences
- `HIERARCHY`  -  nested or ranked relationships
- `GEOGRAPHY`  -  spatial data
- `RELATIONSHIP`  -  networks, dependencies, connections
- `PERFORMANCE`  -  actuals vs targets, KPIs, scorecards
- `RISK`  -  probability, impact, uncertainty
- `CX`  -  customer behavior, journey, sentiment
- `STRATEGY`  -  frameworks, positioning, options

## Audience Levels

- `Exec`  -  needs high-level, decision-ready
- `Stakeholder`  -  needs credible, polished, explainable
- `Analyst`  -  tolerates complexity, wants detail
- `Delivery`  -  needs operational specificity

## How To Use This Taxonomy

1. Pick the **domain** that matches the user's question (PROJECT, STRATEGY, RISK, DATA, PROCESS, CX, SYSTEMS, ADVANCED, EXECUTIVE).
2. Inside the domain, scan the **Story Type** column for the story the data needs to tell.
3. Narrow by **Audience** (Exec / Stakeholder / Analyst / Delivery) and **Complexity** (Low / Medium / High) to match the room and the data size.
4. Use the **Actions** column (Align / Explain / Diagnose / Decide) to confirm the chart supports the action the audience needs to take.

---

## THE FULL VISUALIZATION TAXONOMY

### PROJECT
| Name | Purpose | Story Type | Audience | Level | Complexity | Actions |
|---|---|---|---|---|---|---|
| Gantt Chart | Plan and communicate delivery timelines | FLOW | Exec;Stakeholder;Delivery | High-level | Medium | Align;Explain;Diagnose |
| Roadmap | Align stakeholders on direction and sequencing | TREND | Exec;Stakeholder | High-level | Low | Align;Explain;Decide |
| PERT Chart | Optimize sequencing for complex projects | FLOW | Delivery;Analyst | Detailed | High | Diagnose;Align |
| Critical Path Analysis | Identify schedule drivers and protect delivery date | FLOW | Exec;Delivery | Mixed | Medium | Diagnose;Align;Explain |
| RACI Matrix | Clarify roles to speed decisions and execution | RELATIONSHIP | Stakeholder;Delivery;Exec | High-level | Low | Align;Diagnose |
| Capacity / Resource Utilization | Prevent over-allocation and plan resourcing | PERFORMANCE | Delivery;Exec | Quantitative | Medium | Diagnose;Align;Decide |
| Burndown / Burnup Charts | Track delivery progress and scope change | TREND | Delivery;Exec | Quantitative | Low | Explain;Diagnose |

### STRATEGY
| Name | Purpose | Story Type | Audience | Level | Complexity | Actions |
|---|---|---|---|---|---|---|
| SWOT Analysis | Rapid strategic framing and positioning | STRATEGY | Exec;Stakeholder | High-level | Low | Decide;Align;Explain |
| PESTLE / PESTEL | Assess external forces and constraints | STRATEGY | Exec;Stakeholder | High-level | Medium | Decide;Diagnose |
| Porter's Five Forces | Assess industry attractiveness and positioning | STRATEGY | Exec;Stakeholder | High-level | Medium | Decide;Explain |
| Ansoff Matrix | Evaluate growth options and risk | STRATEGY | Exec;Stakeholder | High-level | Low | Decide;Align |
| BCG Matrix | Allocate investment across products/services | STRATEGY | Exec;Stakeholder | Mixed | Medium | Decide;Explain |
| Value Chain Analysis | Identify cost/value improvement levers | STRATEGY | Stakeholder;Delivery;Exec | Mixed | Medium | Diagnose;Decide |
| OKR / KPI Frameworks | Align execution to strategy with measurable outcomes | PERFORMANCE | Exec;Stakeholder;Delivery | High-level | Low | Align;Explain |

### RISK
| Name | Purpose | Story Type | Audience | Level | Complexity | Actions |
|---|---|---|---|---|---|---|
| Heat Maps | Prioritize hotspots across two dimensions | RISK | Exec;Stakeholder | High-level | Low | Diagnose;Explain;Align |
| Risk Matrix (Impact × Probability) | Governance and risk review prioritization | RISK | Exec;Delivery | High-level | Low | Diagnose;Align |
| Failure Mode & Effects Analysis (FMEA) | Identify and mitigate failure points | RISK | Delivery;Analyst | Detailed | High | Diagnose;Decide |
| Issue Trees / Problem Trees | Diagnose complex problems MECE | HIERARCHY | Stakeholder;Delivery;Exec | High-level | Medium | Diagnose;Align |
| Decision Trees | Compare options under uncertainty | RISK | Exec;Stakeholder | Mixed | Medium | Decide;Explain |
| Scenario Analysis | Plan for uncertainty and stress-test strategy | RISK | Exec;Stakeholder | High-level | Medium | Decide;Align;Explain |

### DATA
| Name | Purpose | Story Type | Audience | Level | Complexity | Actions |
|---|---|---|---|---|---|---|
| Bar / Line / Area Charts | Communicate performance and trends | COMPARISON;TREND | Exec;Stakeholder;Delivery | Quantitative | Low | Explain |
| Scatter Plots | Test relationships between variables | CORRELATION | Analyst;Delivery | Quantitative | Medium | Diagnose |
| Waterfall Charts | Explain what drove change | COMPOSITION | Exec;Stakeholder | Quantitative | Medium | Explain |
| Pareto Analysis (80/20) | Prioritize top contributors | DISTRIBUTION | Delivery;Analyst | Quantitative | Low | Diagnose;Decide |
| Control Charts | Detect special-cause variation | TREND | Analyst;Delivery | Quantitative | High | Diagnose |
| Time Series Analysis | Understand trends and forecast | TREND | Exec;Analyst | Quantitative | Medium | Explain;Diagnose |
| Benchmarking Analysis | Identify gaps vs peers/targets | COMPARISON | Exec;Stakeholder | Mixed | Medium | Decide;Explain |

### PROCESS
| Name | Purpose | Story Type | Audience | Level | Complexity | Actions |
|---|---|---|---|---|---|---|
| Process Maps / Flowcharts | Document and improve processes | FLOW | Delivery;Stakeholder | Mixed | Medium | Diagnose;Align;Explain |
| Swimlane Diagrams | Clarify handoffs and accountability | FLOW | Delivery;Stakeholder | Mixed | Medium | Diagnose;Align |
| SIPOC Diagrams | Define process scope quickly | FLOW | Stakeholder;Delivery | High-level | Low | Align |
| Value Stream Mapping | Identify waste and improve cycle time | FLOW | Delivery;Stakeholder | Detailed | High | Diagnose;Decide |
| Service Blueprints | Improve service delivery and experience | FLOW | Stakeholder;Delivery | Mixed | High | Diagnose;Align |
| Bottleneck Analysis | Increase throughput and reduce delays | PERFORMANCE | Delivery;Exec | Quantitative | Medium | Diagnose;Decide |

### CX
| Name | Purpose | Story Type | Audience | Level | Complexity | Actions |
|---|---|---|---|---|---|---|
| Customer Journey Maps | Improve CX and align stakeholders | CX | Exec;Stakeholder;Delivery | Mixed | Medium | Diagnose;Align;Explain |
| Persona Analysis | Guide product/service design | CX | Stakeholder;Delivery | High-level | Low | Align |
| Voice of Customer (VoC) | Prioritize improvements using customer feedback | CX | Stakeholder;Exec;Delivery | Mixed | Medium | Diagnose;Decide |
| NPS Analysis | Understand what drives loyalty | PERFORMANCE | Exec;Stakeholder | Quantitative | Medium | Explain;Diagnose |
| Cohort Analysis | Retention and behavior insights | TREND | Analyst;Delivery | Quantitative | High | Diagnose |
| Churn Analysis | Reduce churn and protect revenue | DISTRIBUTION | Exec;Analyst | Quantitative | High | Diagnose;Decide |

### SYSTEMS
| Name | Purpose | Story Type | Audience | Level | Complexity | Actions |
|---|---|---|---|---|---|---|
| Ecosystem Maps | Clarify ecosystem roles and value exchange | RELATIONSHIP | Exec;Stakeholder | High-level | Low | Align;Explain;Decide |
| Stakeholder Maps | Plan engagement and change strategy | RELATIONSHIP | Exec;Delivery;Stakeholder | High-level | Low | Align;Diagnose |
| Influence / Power-Interest Grids | Target engagement efficiently | STRATEGY | Exec;Delivery | High-level | Low | Align |
| Network Graphs | Reveal clusters and central nodes | RELATIONSHIP | Analyst;Delivery | Quantitative | High | Diagnose |
| Dependency Maps | Manage interdependencies and delivery risk | RELATIONSHIP | Exec;Delivery | Mixed | Medium | Align;Diagnose |

### ADVANCED
| Name | Purpose | Story Type | Audience | Level | Complexity | Actions |
|---|---|---|---|---|---|---|
| Regression Analysis | Quantify drivers of outcomes | CORRELATION | Analyst | Quantitative | High | Diagnose;Decide |
| Forecasting Models | Predict future metrics | TREND | Exec;Analyst | Quantitative | High | Decide;Explain |
| Sensitivity Analysis | Stress-test assumptions | RISK | Exec;Analyst | Quantitative | Medium | Decide |
| Monte Carlo Simulations | Quantify risk distribution | RISK | Analyst;Exec | Quantitative | High | Decide |
| Clustering / Segmentation | Group similar entities | DISTRIBUTION | Analyst;Stakeholder | Quantitative | High | Diagnose;Decide |
| Machine Learning Models | Predict outcomes at scale | CORRELATION | Analyst | Quantitative | High | Diagnose;Decide |

### EXECUTIVE
| Name | Purpose | Story Type | Audience | Level | Complexity | Actions |
|---|---|---|---|---|---|---|
| Dashboards | Ongoing performance monitoring | PERFORMANCE | Exec;Stakeholder | Mixed | Medium | Explain;Align |
| Scorecards | Accountability and governance | PERFORMANCE | Exec;Delivery | Mixed | Low | Explain;Align |
| Executive One-Pagers | Fast alignment and decision support | STRATEGY | Exec;Stakeholder | High-level | Low | Explain;Decide |
| Infographics | Communications and enablement | STRATEGY | Stakeholder;Exec | High-level | Medium | Explain;Align |
| Signal vs Noise Charts | Make data stories understandable | COMPARISON | Exec;Stakeholder | Mixed | Medium | Explain |
