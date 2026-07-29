# Loop-adoption evidence

This is an internal-fleet measurement from the maintainer's production system,
not a proof that can be reproduced from a public clone of this repo.

## Maintainer production count

**25** live loop specifications were measured in the maintainer's production
`loops/` directory.

The individual spec filenames are withheld because they are operational
artifacts. The useful claim is narrow: the goal-and-loop contract is in real
scheduled use in the maintainer fleet. It is not presented as public adoption,
and it is not reproducible from this repository alone.

## Public-clone behavior

This public repo ships no `loops/` directory. A reviewer who runs:

```sh
bash proof/loop-adoption-evidence/measure.sh
```

should get a clean local measurement with `count=0`, not an error. The script is
for measuring a user's own `loops/` directory if one exists.

For a proof that is reproducible from this public repository, use
`proof/session-start-benchmark/`.
