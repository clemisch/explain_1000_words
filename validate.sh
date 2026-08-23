#!/usr/bin/env bash

set -u

usage() {
    printf 'Usage: %s NUMBER.txt\n' "${0##*/}" >&2
}

if (( $# != 1 )); then
    usage
    exit 2
fi

input=$1
filename=${input##*/}

if [[ ! $filename =~ ^([0-9]+)\.txt$ ]]; then
    printf 'Error: the input filename must be a number followed by .txt.\n' >&2
    exit 2
fi

number=$((10#${BASH_REMATCH[1]}))
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

LC_ALL=C awk -v limit="$limit" -v target="$target" '
    NR == FNR {
        if (FNR <= limit) {
            allowed[$0] = 1
        }
        next
    }

    {
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
        if (bad) {
            printf "FAIL: %d disallowed word occurrence%s found.\n", \
                bad, (bad == 1 ? "" : "s") > "/dev/stderr"
            exit 1
        }

        printf "OK\n"
    }
' "$word_file" "$input"
