# nod-protocol: Origin and Attribution

## Pattern lineage

The five-gate opposite-construction protocol was added in v2.1.0 to fill
a gap identified during the v2.0.0 review cycle: the kit had strong
infrastructure for how sessions run but a lighter adversarial reasoning
layer. The `detached-judgment` skill gestured at structured disagreement;
no skill enforced it with gates.

The "NOD" framing  -  the ability to look at opposite perspectives without
emotion  -  was contributed by **Adam Federman**, who built an
opposite-perspectives protocol in his own work and pointed out the gate-
structure gap in v2.0.0. The five-gate procedure in this skill is the
kit's adaptation of that pattern: position, opposite-construction,
shared-assumption surfacing, falsifier specification, and gated exit.

The signing test (Gate 2's "would a thoughtful opposite-side believer
sign this paragraph?") is the discipline that prevents strawman opposites
from passing as the strongest opposite. That test is the load-bearing
piece of the protocol; without it, Gate 2 becomes rhetorical exercise.

## Adjacent sources

The shared-assumption layer (Gate 3) draws on standard premise-checking
discipline used in argument analysis and decision frameworks. The
falsifier requirement (Gate 4) draws on Popper's falsificationist
philosophy of science applied at decision granularity. Neither is
original to this skill; the contribution is the gated sequence that
forces both to run before any conclusion lands.

## Why a separate skill, not a section in detached-judgment

`detached-judgment` calibrates confidence and surfaces base rates.
`nod-protocol` constructs the opposite case with gate-enforced rigor.
The two pair well but do different work. Folding them together would
weaken both: detached-judgment would become noisier, nod-protocol would
lose its gated structure.

## How this skill should be cited

When a deliverable runs through nod-protocol, cite it as:

> Opposite-construction via the NOD protocol (Compound AI Operating
> Standards, Tier 2 cognitive mode).

No need to cite Adam by name in deliverables; the kit-level attribution
preserves the lineage without making the citation chain long.
