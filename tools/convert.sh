#!/bin/bash

SCRIPT_DIR="`dirname "$0"`"
SCRIPT_DIR="`cd "$SCRIPT_DIR" && pwd`"

PATH="$SCRIPT_DIR/../JSON.sh:$PATH"
export PATH

LC_ALL=C
LC_LANG=C
TZ=UTC
export LC_ALL LC_LANG TZ

usage() {
cat << EOF
#   Usage: convert.sh <INPUT_DIR> <OUTPUT_FILE>
#
#   with INPUT_FILE: Input directory which contains release note files (*.md)
#        OUTPUT_FILE: Output release note file (json)
EOF
}

# Put in a output json file each markdown file content present in the input directory
# sort with name in reverse alphabetical order.
# Note: version is the name of the markdown file without extension (same key use for sorting)
# json format file:
#[
#	{
#		"version": "2.3.0",
#		"content": "<content of release note (markdown format) without carriage return(replace with \\n)>"
#	},
#	{
#		"version": "2.2.0",
#		"content": "<content of release note (markdown format) without carriage return(replace with \\n)>"
#	}
#]
convert_md_to_json() {
    n=0
    echo -n "[" > "$output_file"
    # for each file in directory (revert sort with file name without extension)
    # caution: 2.3.0-1 must be prior to 2.3.0
    for file in `ls -1 "$input_dir"/*.md | rev | cut -d . -f 2- | rev | sort -r`
    do
        version="$(basename "$file")"
        echo "Find $version ($file)"
        if [[ ! "$n" -eq 0 ]]; then
            echo "," >> "$output_file"
        else
            echo "" >> "$output_file"
        fi
        echo $'\t{' >> "$output_file"
        echo -n $'\t\t"version": "' >> "$output_file"
        echo "${version}\"," >> "$output_file"
        echo -n $'\t\t"content": "' >> "$output_file"

        # Read each line and convert CR with "\n"
        JSON.sh -Q < "${file}.md" >> "$output_file"
        # Add literal "\n" at end of converted text, before the closing quote"
        echo -n '\\' >> "$output_file"
        echo -n 'n' >> "$output_file"
        echo -n $'"\n\t}' >> "$output_file"
        n=$((n+1))
    done
    if [[ ! "$n" -eq 0 ]]; then
        echo "" >> "$output_file"
    fi
    echo -n $']\n' >> "$output_file"
}

if [ $# -lt 2 ]; then
    echo "Bad parameters"
    usage
    exit 1
else
    input_dir="$1"
    output_file="$2"
    echo input_dir="$input_dir"
    echo output_file="$output_file"

    convert_md_to_json
fi

