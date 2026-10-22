# Grammar audit, recovery fixes, and macro bodies as expressions

Three areas of work on top of #8, all validated against the cjc 1.3 compiler and the 6017-file golden corpus.

## 1. Grammar audit and hygiene

A full read-through of `grammar.js` with cjc ground-truth probes for every suspicious shape:

- `ident(node)` helper replaces 12 copies of the identifier/unicode/raw alias triple and extends raw/unicode names to every identifier position cjc accepts them at; unicode parameter names now carry the `parameter_name` field; unicode function names parse.
- `index_access` was wrong in both directions: cjc accepts `a[..]`, `a[..=1]`, `a[0..]` (we rejected) and rejects `:step` in index position (we accepted). Range steps (`0..2:1`) are real and kept.
- `catch` requires parens (cjc rejects `catch e {}`); `primary_init` bodies use local declarations (no modifiers), matching cjc and the rule's own comment.
- `identifier` drops its redundant backtick branch (no more three-way token ambiguity with `raw_identifier`/`package_identifier`); `package_identifier` now requires a separator char.
- Dead weight removed: `primitiveTokens`, `static_init`-era leftovers, 10x `optional(repeat1(x))` → `repeat(x)`; `modifiers`/`_modifiers_var` share one builder.
- Comment share trimmed below 4% in both `grammar.js` and `scanner.c` — the surviving comments carry only load-bearing invariants (word-token charset rule, statement-start modifier invariant, `alias(seq)` generator pitfall, lexer.c zero-width citation).

## 2. Error recovery

- The with-body function tail carries `prec.dynamic(1)`: at an unclosed trailing `{` (EOF while typing) recovery inserts MISSING `}` instead of flagging the block — the editing case.
- Investigated whole-file ERROR blobs with measurements: scanner-side recovery gating was refuted (blobs are recovery bundling, not raw-content swallows), and terminator-required statement separation measured worse (6708 vs 5576 errors) and was discarded. Remaining blob noise is tree-sitter's cost model on garbage input, documented rather than papered over.

## 3. Macro bodies parse as ad-hoc expression lists

`@Name[attrs]` and `@Name(input)` bodies are grammar-lexed bracket groups whose content is a comma-separated list of arguments — the forms the corpus uses (cjls parity: cjls parses macro content speculatively and falls back to raw tokens; we parse structurally):

- bare expressions (`@Assert(false)`, `@When[os == "Windows"]`, `@AssertThrows[Exception]`)
- named `k: v` arguments (`@Deprecated["...", strict: true]`, `delta: 0.1f32`)
- `x in y` via the binary operators (`@Bench[x in data]`)
- labels are plain `identifier` nodes (unicode and backticked names included), same as call labels

The bodies carry dynamic precedence so they attach to the head — without it, `@M[1]` in expression position parses as an index suffix and `@M(x)` as a call. Two conflict declarations (`macro_expression`, `_macro_head`) allow the ambiguity; runtime resolution is the dynamic precedence.

Scanner: the `CTX_MACRO_BODY`/`CTX_MACRO_GROUP` frames, six body externals and both body scanners are gone — nested brackets balance through the grammar's own expression rules, strings and raw strings lex normally inside bodies, comments are extras again.

Coloring: operators, numbers, strings and keywords inside bodies color via the regular expression captures; named labels color as `@variable.parameter`; bare identifiers stay uncolored like every other use-site name (LS colors names, per cjls ADR-0019). The `(macro_raw_token)` node is gone; quote bodies keep `quote_raw_token`.

## Verification

- grammar corpus + highlight/tag expectations: **125/125**
- golden corpus rebased and green: **6017/6017, 0 regressions**; std/stdlib + stdx: **767 files, zero error nodes**
- `tree-sitter generate`: no diff, no new conflicts (2 declared, runtime-resolved)
- cjc cross-probes: soft/hard word matrix, import/package shapes, unicode identifiers, all macro-body forms
- tree hash of the branch tip is byte-identical to the validated state

## Known edges (documented, not regressions)

- Unclosed macro body at EOF inside an unclosed block degrades to one error node (recovery quality).
- Bare `_` on an assignment RHS inside a macro body errors (not an expression form; those files already errored).

## Test plan

- [ ] `tree-sitter generate && tree-sitter test`
- [ ] golden harness `--ci` against the pinned sources
- [ ] editor spot-check: `@Attr[flag = true, n: 42]` colors as expressions
