# Conventions

## Regions and suppliers are data, not code

Different suppliers call the same cabinet different things. Region and
supplier specifics belong in structured data files, never as hardcoded
strings or branches in application code.

```
data/
├── regions/
│   └── <region-id>.json        # one row per region; adding a region = new file
├── suppliers/
│   └── <supplier-id>.json      # supplier metadata, contact, service area
└── name-translation/
    └── <supplier-id>-to-canonical.json   # maps supplier's names → internal canonical name
```

Rule of thumb: if adding a second region or a second supplier requires
touching a `.py`, `.js`, or `.ts` file rather than adding a new row/file
under `data/`, that's a structural bug, not a feature request. Flag it and
fix the structure before adding the row.

## The translation layer

Every supplier-facing name passes through
`data/name-translation/<supplier-id>-to-canonical.json` before it's used
internally. The internal canonical name is the only name application logic
ever branches on. New supplier = new translation file, not new logic.

## Naming

- Files: `kebab-case.md`, `snake_case.py` / `camelCase.ts` per language norm
- Data files: `<region-or-supplier-id>.json`, id is lowercase, hyphenated
- No abbreviations in canonical cabinet names — write them out; suppliers
  abbreviate, the canonical layer doesn't

## Verify-before-claiming, applied here specifically

Before reporting a supplier integration "done": actually fetch or load that
supplier's real name list and confirm the translation file covers it. A
translation file with placeholder entries is not done.
