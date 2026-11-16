# Feature Specification: English Documentation

**Feature Branch**: `feature/english-docs`

**Created**: 2026-11-16

**Status**: Draft

**Input**: User description: "Our documentation are in portuguese. We need to adapt to our constitution and use english"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Read the README in English (Priority: P1)

An English-speaking developer opens the project README to learn what the package does, how to install it, and how to use it. Today the README is written in Portuguese, so they cannot follow it.

**Why this priority**: The README is the first and most-read document; it delivers the most value toward constitution Principle II (English Documentation).

**Independent Test**: Read the README end to end and confirm that no prose, headings, or example commentary is in Portuguese, and that every code example still gives the output shown.

**Acceptance Scenarios**:

1. **Given** the README, **When** a reader scans every section (requirements, installation, tutorial, API reference, testing, notes), **Then** all prose and headings are in English.
2. **Given** a code example in the README, **When** the reader runs it, **Then** the result matches the output shown.
3. **Given** the README's meaning before and after the change, **When** compared, **Then** no feature, step, or caveat was lost or altered.

---

### User Story 2 - Read in-code documentation in English (Priority: P2)

A contributor reads the package's docstrings, comments, and user-facing error messages to understand the code. These currently contain Portuguese text.

**Why this priority**: Constitution Principle II requires English docstrings, comments, and error messages; this serves contributors and API users.

**Independent Test**: Search the source file for Portuguese text and review the docstrings shown by the Julia help system.

**Acceptance Scenarios**:

1. **Given** the package source, **When** a contributor reads module and symbol docstrings and comments, **Then** all are in English.
2. **Given** an invalid input that triggers an error, **When** the error message is shown, **Then** it is in English.
3. **Given** the existing behavior of the package, **When** the documentation is translated, **Then** no behavior changes.

---

### User Story 3 - Read test descriptions in English (Priority: P3)

A contributor reads the test suite. Test group names and comments are in Portuguese.

**Why this priority**: Lower reader impact, but required for full compliance with the constitution.

**Independent Test**: Search the test file for Portuguese text; run the tests and confirm the same tests pass.

**Acceptance Scenarios**:

1. **Given** the test suite, **When** a contributor reads test set names and comments, **Then** all are in English.
2. **Given** the translated tests, **When** they are run, **Then** the same tests pass as before.

---

### Edge Cases

- Text that is intentionally Portuguese, such as a name or a quoted example (for instance the README's note about the package name), must be reviewed and either translated or explicitly kept with an English explanation.
- Technical terms with an established English meaning (e.g., "polar form", "conjugate", "argument") must use standard English math terminology.
- Section anchors or links inside the README that depend on Portuguese heading text must still work after headings are translated.
- Accented characters or non-English wording may appear in code identifiers, output strings, or examples; these must be checked so documentation examples still match actual output.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: All README prose, headings, and example commentary MUST be in English.
- **FR-002**: All module and symbol docstrings MUST be in English.
- **FR-003**: All source and test comments MUST be in English.
- **FR-004**: All user-facing error messages MUST be in English.
- **FR-005**: Test group names and descriptions MUST be in English.
- **FR-006**: The translation MUST preserve the meaning, structure, and technical accuracy of the original documentation, using standard English mathematical terms.
- **FR-007**: Translation MUST NOT change package behavior; the existing test suite MUST pass with the same results.
- **FR-008**: Code examples in documentation MUST remain accurate and show real output.
- **FR-009**: Internal links and anchors in the README MUST continue to work after translation.

### Key Entities

- **Documentation artifact**: Any human-readable text in the project (README, module/symbol docstrings, code comments, error messages, test descriptions) that is subject to the English-language rule.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 0 Portuguese words remain in the README, docstrings, comments, error messages, and test descriptions, except intentionally retained items that are explained in English.
- **SC-002**: 100% of the existing tests pass before and after the change.
- **SC-003**: 100% of README code examples produce the output shown.
- **SC-004**: An English-speaking reader can follow the install and tutorial sections from start to finish without translation help.
- **SC-005**: Every README internal link resolves.

## Assumptions

- Scope covers the README, `src/ComplexNumbers.jl`, and `test/runtests.jl`; the social-preview image and license text are out of scope unless they contain Portuguese text.
- Existing documentation structure is retained; this is a translation, not a rewrite or a feature addition.
- Identifiers (function and type names) are already in English and are not renamed.
- Docstring examples added later under the constitution (`jldoctest`) are a separate effort unless already present.
