# Tasks: English Documentation

**Input**: Design documents from `/specs/001-english-docs/`
**Prerequisites**: plan.md, spec.md, research.md, contracts/documentation-contract.md
**Tests**: No new tests are requested. Existing tests are the regression guard. One error-message test is added first (TDD, constitution Principle V).

## Format: `- [ ] [TaskID] [P?] [Story?] Description with file path`

## Phase 1: Setup

- [X] T001 Run `julia --project=. -e 'using Pkg; Pkg.test()'` and record that the baseline passes (repo root)
- [X] T002 Record the baseline Portuguese scan: `grep -nP '[áéíóúãõçâêô]' README.md src/ComplexNumbers.jl test/runtests.jl`

## Phase 2: Foundational

- [X] T003 Fix the terminology list from research.md (Cartesian/polar form, modulus, argument, conjugate, real/imaginary part) and apply it to every task below

## Phase 3: User Story 1 - README in English (Priority: P1) 🎯 MVP

**Goal**: README is fully English.
**Independent Test**: Read README.md; no Portuguese remains; examples give shown output; links resolve.

- [X] T004 [US1] Translate the intro, feature list, Requirements, and Installation sections (lines 1-74) in README.md
- [X] T005 [US1] Translate Tutorial sections 1-4 (creating numbers, Cartesian→polar, polar→Cartesian, string conversion) including code comments in README.md
- [X] T006 [US1] Translate Tutorial sections 5-8 (arithmetic, conjugate, interoperability, RLC example) including code comments in README.md
- [X] T007 [US1] Translate the API reference table, "Running the tests", and the note about the package name in README.md
- [X] T008 [US1] Check README.md for in-page anchors to translated headings and update any broken links (FR-009)
- [X] T009 [US1] Run each README example in the Julia REPL and fix outputs shown in README.md if they differ (FR-008)

**Checkpoint**: README is complete and checked.

## Phase 4: User Story 2 - In-code documentation in English (Priority: P2)

**Goal**: Docstrings, comments, and error messages in `src/ComplexNumbers.jl` are English.
**Independent Test**: `?ComplexNumber`, `?modulus`, `?tostring` read in English; no Portuguese in src.

- [X] T010 [US2] Add a test in test/runtests.jl that the invalid-form `ArgumentError` message contains "invalid form" (`@test_throws ArgumentError` with a message matcher); run it and confirm it fails (Red)
- [X] T011 [US2] Translate the error message at src/ComplexNumbers.jl:113 to English (e.g. `"invalid form: $(repr(form)); use :cartesian or :polar"`); confirm T010 passes (Green)
- [X] T012 [P] [US2] Translate the module docstring and the `ComplexNumber` docstring/comments (src/ComplexNumbers.jl lines 1-45)
- [X] T013 [P] [US2] Translate docstrings and comments for polar/Cartesian conversions, `modulus`, `argument`, `topolar`, `frompolar` (src/ComplexNumbers.jl lines 42-87)
- [X] T014 [P] [US2] Translate docstrings and comments for string conversion, arithmetic, and conjugate (src/ComplexNumbers.jl lines 88-169)
- [X] T015 [US2] Run the Portuguese scan on src/ComplexNumbers.jl and confirm no hits remain

**Checkpoint**: Source documentation is English; tests pass.

## Phase 5: User Story 3 - Tests in English (Priority: P3)

**Goal**: Test names and comments are English.
**Independent Test**: No Portuguese in test/runtests.jl; same tests pass.

- [X] T016 [US3] Translate all `@testset` names and comments in test/runtests.jl (e.g. "Operadores aritméticos" → "Arithmetic operators"; "Divisão por zero" → "Division by zero"; "Verificação cruzada…" → "Cross-check against Julia's built-in Complex"), including the invalid-form test value `:invalida` → `:invalid`
- [X] T017 [US3] Run the Portuguese scan on test/runtests.jl and confirm no hits remain

## Phase 6: Polish & Verification

- [X] T018 Run the full test suite and confirm all tests pass (SC-002)
- [X] T019 Run the final scan across README.md, src/ComplexNumbers.jl, test/runtests.jl and the word list from quickstart.md; explain in English any intentionally kept item (SC-001)
- [X] T020 Walk through specs/001-english-docs/quickstart.md steps 1-6 and confirm each result

## Dependencies & Execution Order

- Phase 1 → Phase 2 → user stories. US1, US2, US3 are independent after Phase 2; run in priority order.
- Within US2: T010 → T011 first; T012-T014 touch different line ranges of one file, so they can be parallel only if edited carefully (otherwise sequential).
- US3 T016 edits the same file as T010; do T010 first, then T016.
- Phase 6 runs after all stories.

## Parallel Example

README (T004-T009), source (T012-T014), and test translation (T016) work in different files and could run concurrently, apart from the T010 → T016 ordering.

## Implementation Strategy

- **MVP**: Phase 1-3 (README in English), then validate.
- **Incremental**: add US2, then US3; run tests after each story.
