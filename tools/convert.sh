#!/bin/bash

SCRIPT_DIR="`dirname "$0"`"
SCRIPT_DIR="`cd "$SCRIPT_DIR" && pwd`"

PATH="$SCRIPT_DIR/../JSON.sh:/usr/share/fty/scripts:$PATH"
export PATH

(command -v JSON.sh) \
&& { echo "INFO: Will use the copy of JSON.sh in the PATH found above to 'cook' text files into strings"; } \
|| { echo "WARNING: Seems you have no JSON.sh in the PATH; is the submodule checked out?" >&2; }

LC_ALL=C
LC_LANG=C
TZ=UTC
export LC_ALL LC_LANG TZ

usage() {
cat << EOF
#   Usage: convert.sh <INPUT_DIR> <output_file_JSON> [output_file_PDF/TXT]
#
#   with INPUT_FILE: Input directory which contains release note files (*.md)
#        output_file_JSON: Output release note file (JSON format)
#        output_file_PDF/TXT: Output release note file (cumulative PDF and TEXT format)
#                             which can either be "file.pdf" or "file"
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
    echo "JSON file generation"
    echo -n "[" > "$output_file_json"
    # for each file in directory (revert sort with file name without extension)
    # caution: 2.3.0-1 must be prior to 2.3.0
    for file in `ls -1 "$input_dir"/*.md | rev | cut -d . -f 2- | rev | sort -r`
    do
        version="$(basename "$file")"
        echo "Find $version ($file)"
        if [[ ! "$n" -eq 0 ]]; then
            echo "," >> "$output_file_json"
        else
            echo "" >> "$output_file_json"
        fi
        printf '\t{\n' >> "$output_file_json"
        printf '\t\t"version": "' >> "$output_file_json"
        # Assumes no chars surprising for a JSON string in the version (from filename)
        printf "${version}\",\n" >> "$output_file_json"
        printf '\t\t"content": "' >> "$output_file_json"

        # Read each line and convert CR with "\n"
        JSON.sh -Q < "${file}.md" >> "$output_file_json"
        # Add literal "\n" at end of converted text, before the closing quote"
        printf '%s%s' '\' 'n'  >> "$output_file_json"
        printf '"\n\t}' >> "$output_file_json"
        n=$((n+1))
    done
    if [[ ! "$n" -eq 0 ]]; then
        echo "" >> "$output_file_json"
    fi
    echo -n $']\n' >> "$output_file_json"
}


convert_md_to_pdf_and_text() {
    rm -f ipm.md
    echo "PDF and TEXT files generation"
    which pandoc 1>/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "pandoc is not available. Aborting PDF and TEXT generation"
        exit 1
    fi

    case "$output_file_pdf" in
        *.pdf)
            output_file_txt="`echo $output_file_pdf | sed 's/pdf/txt/'`"
            ;;
        *)
            # if no type extension
            output_file_txt="$output_file_pdf.txt"
            output_file_pdf="$output_file_pdf.pdf"
            ;;
    esac

    # for each file in directory (revert sort with file name without extension)
    # caution: 2.3.0-1 must be prior to 2.3.0
    for file in `ls -1 "$input_dir"/*.md | rev | cut -d . -f 2- | rev | sort -r`
    do
        version="$(basename "$file")"
        echo "Find $version ($file)"
        cat $file.md >> ipm.md
        # Insert separator between entries
        echo -e "\n  * * *\n" >> ipm.md
    done
    # Generate the PDF file
    pandoc ipm.md -s -o $output_file_pdf --variable mainfont="Carlito" -V geometry:margin=1in

    # Generate the TEXT file
    pandoc ipm.md -t plain -o $output_file_txt

    # Cleanup
    rm -f ipm.md
}

if [ $# -lt 2 ]; then
    echo "Bad parameters"
    usage
    exit 1
else
    input_dir="$1"
    output_file_json="$2"
    if [ $# -eq 3 ]; then
        output_file_pdf="$3"
    else
        output_file_pdf=""
    fi
    echo input_dir="$input_dir"
    echo output_file_json="$output_file_json"
    echo output_file_pdf="$output_file_pdf"

    convert_md_to_json
    if [ -n "$output_file_pdf" ]; then
        convert_md_to_pdf_and_text
    fi
fi

