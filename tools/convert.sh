#!/bin/bash

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
    # caution: 2.3.0-1 must be prior then 2.3.0
    for file in `ls $input_dir/*.md | rev | cut -d . -f 2- | rev | sort -r`
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

        # Reading each line and convert CR with "\n"
        while read line; do
            # Escape '"'
            line=$(echo "$line" | sed -e 's/[\"]/\\&/g')
            echo -n "$line\\\\n" >> "$output_file"
        done < "${file}.md"
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
else
    input_dir="$1"
    output_file="$2"
    echo input_dir="$input_dir"
    echo output_file="$output_file"

    convert_md_to_json
fi

