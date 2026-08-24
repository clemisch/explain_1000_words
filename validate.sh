#!/usr/bin/env bash

set -u

usage() {
    printf 'Usage: %s NUMBER_WORD.txt\n' "${0##*/}" >&2
}

if (( $# != 1 )); then
    usage
    exit 2
fi

input=$1
filename=${input##*/}

if [[ ! $filename =~ ^([0-9]+)_([a-z]+)\.txt$ ]]; then
    printf 'Error: the input filename must have the form NUMBER_WORD.txt.\n' >&2
    exit 2
fi

number=$((10#${BASH_REMATCH[1]}))
word=${BASH_REMATCH[2]}
if (( number < 2 )); then
    printf 'Error: the number must be at least 2.\n' >&2
    exit 2
fi

if [[ ! -r $input ]]; then
    printf 'Error: cannot read %s.\n' "$input" >&2
    exit 2
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
word_file=$script_dir/words_10000.txt

if [[ ! -r $word_file ]]; then
    printf 'Error: cannot read %s.\n' "$word_file" >&2
    exit 2
fi

word_count=$(awk 'END { print NR }' "$word_file")
if (( number > word_count )); then
    printf 'Error: %s contains only %d words; position %d does not exist.\n' \
        "$word_file" "$word_count" "$number" >&2
    exit 2
fi

limit=$((number - 1))
target=$(sed -n "${number}p" "$word_file")

if [[ $word != "$target" ]]; then
    printf 'Error: filename says word %d is %s, but the word list says it is %s.\n' \
        "$number" "$word" "$target" >&2
    exit 2
fi

LC_ALL=C awk -v limit="$limit" -v target="$target" '
    NR == FNR {
        if (FNR <= limit) {
            allowed[$0] = 1
        }
        next
    }

    {
        for (column = 1; column <= length($0); column++) {
            character = substr($0, column, 1)
            if (character !~ /^[A-Za-z .,;:!?-]$/ && character != "\t") {
                printf "Disallowed character on line %d, column %d: %s\n", \
                    FNR, column, character > "/dev/stderr"
                bad_characters++
            }
        }

        text = tolower($0)
        gsub(/[^a-z]+/, " ", text)
        count = split(text, words, / +/)

        for (i = 1; i <= count; i++) {
            if (words[i] != "" && !(words[i] in allowed)) {
                printf "Disallowed word on line %d: %s\n", FNR, words[i] > "/dev/stderr"
                bad++
            }
        }
    }

    END {
        if (bad || bad_characters) {
            if (bad) {
                printf "%d disallowed word occurrence%s found.\n", \
                    bad, (bad == 1 ? "" : "s") > "/dev/stderr"
            }
            if (bad_characters) {
                printf "%d disallowed character occurrence%s found.\n", \
                    bad_characters, (bad_characters == 1 ? "" : "s") > "/dev/stderr"
            }
            printf "FAIL\n" > "/dev/stderr"
            exit 1
        }

        printf "OK\n"
    }
' "$word_file" "$input"
