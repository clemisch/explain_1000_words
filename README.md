# Explain the Next Word

## Idea

`words_10000.txt` lists 10,000 common American English words from most to least common. For each number `N`, explain word `N + 1` using only the first `N` words. At very low values of `N`, an imperfect fragment may be the best possible result.

`words_10000.txt` is taken from Google's analysis of its Trillion Word Corpus as provided [here](https://github.com/first20hours/google-10000-english/blob/d0736d492489198e4f9d650c7ab4143bc14c1e9e/google-10000-english-usa.txt).

## Rules

- Explanations must be linear prose. Do not use pictograms, diagrams, equations, symbols, or spatial arrangement to convey the meaning.
- Allowed characters are ASCII letters, whitespace, hyphens, and `. , ; : ! ?`. Apostrophes and all other characters are disallowed.
- Every word in an explanation must occur among the first `N` entries. Matching is case-insensitive, and hyphenated parts are checked separately.
- Name each explanation `NNNN_WORD.txt`, where `NNNN` is the four-digit value of `N` and `WORD` is word `N + 1`. For example, `0100_price.txt` uses the first 100 words to explain word 101, `price`.
- Always keep the best available explanation, even when the vocabulary is too limited for a good one.
- Validate a file with `./validate.sh NNNN_WORD.txt`. A valid explanation prints `OK`.
