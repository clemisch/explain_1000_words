# Explain the Next Word

## Idea

`words_10000.txt` lists 10,000 common English words from most to least common. For each number `N`, explain word `N + 1` using only the first `N` words. At very low values of `N`, an imperfect fragment may be the best possible result.

`words_10000.txt` is generated with [wordfreq](https://github.com/rspeer/wordfreq) 3.1.1, which combines word frequencies from subtitles, Wikipedia, books, news, and web text. It contains the first 10,000 entries of `wordfreq.top_n_list("en", ...)` after dropping every entry that is not made only of the letters `a` to `z` (contractions, numbers, abbreviations with dots) and every single letter except `a` and `i`.

To regenerate it:

```sh
python3 -m venv .venv
.venv/bin/pip install wordfreq==3.1.1
.venv/bin/python -c '
import re, wordfreq
words = [w for w in wordfreq.top_n_list("en", 20000) if re.fullmatch(r"[a-z]+", w) and (len(w) > 1 or w in ("a", "i"))][:10000]
open("words_10000.txt", "w").write("\n".join(words) + "\n")
'
```

## Rules

- Explanations must be linear prose. Do not use pictograms, diagrams, equations, symbols, or spatial arrangement to convey the meaning.
- Allowed characters are ASCII letters, whitespace, hyphens, and `. , ; : ! ?`. Apostrophes and all other characters are disallowed.
- Every word in an explanation must occur among the first `N` entries. Matching is case-insensitive, and hyphenated parts are checked separately.
- Name each explanation `NNNN_WORD.txt`, where `NNNN` is the four-digit value of `N` and `WORD` is word `N + 1`. For example, `0100_very.txt` uses the first 100 words to explain word 101, `very`.
- Always keep the best available explanation, even when the vocabulary is too limited for a good one.
- Validate a file with `./validate.sh NNNN_WORD.txt`. A valid explanation prints `OK`.
