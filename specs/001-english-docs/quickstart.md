# Quickstart: Validate English Documentation

1. Run the tests (expect all to pass):
   `julia --project=. -e 'using Pkg; Pkg.test()'`
2. Scan for leftover Portuguese (expect no output except intentionally kept items):
   `grep -nP '[áéíóúãõçâêô]' README.md src/ComplexNumbers.jl test/runtests.jl`
   and review a word list: `grep -niwE 'para|com|uma|número|módulo|conjugado' ...`
3. In the Julia REPL, check help output: `?ComplexNumber`, `?modulus`, `?tostring` read in English.
4. Trigger an invalid-form error: `tostring(ComplexNumber(1,2); form=:x)` shows an English message.
5. Run the README examples and compare with the shown output.
6. Click each README internal link (table of contents/anchors).
