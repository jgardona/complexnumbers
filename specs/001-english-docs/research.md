# Research: English Documentation

## Decision 1: Translate in place, not add a parallel English README
- **Rationale**: The constitution requires English; keeping Portuguese copies doubles maintenance.
- **Alternatives**: `README.pt.md` alongside (rejected: out of scope, can be a later feature).

## Decision 2: Terminology
- **Decision**: Use standard English math terms: *Cartesian/polar form*, *modulus (magnitude)*, *argument (angle)*, *conjugate*, *real/imaginary part*.
- **Rationale**: Matches Julia Base naming (`abs`, `angle`, `conj`).

## Decision 3: Error messages and tests
- **Decision**: Translate error messages (e.g. invalid `form`). Check whether tests match message text; if so, update the test first, watch it fail, then change the message (TDD).
- **Rationale**: Constitution Principle V.

## Decision 4: README anchors
- **Decision**: Check for in-page links to Portuguese headings and update them to the new English anchors.
- **Rationale**: FR-009.

## Decision 5: Verification
- **Decision**: Scan for Portuguese using an accent search plus a small word list (e.g. "para", "com", "de", "número", "módulo"); run `Pkg.test()`; run README examples manually or in the REPL.
- **Alternatives**: Automated language detection (rejected: overkill for 3 files).

No NEEDS CLARIFICATION items remain.
