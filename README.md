# release-note
Repository to manage release note for IPM2 and related products

## Content

- \<product\>/\<version files\>.md: Release note files of the product images.
There is a different directory for each product (e.g. "ipm" for Eaton Intelligent Power Manager Editions) \
In each product directory, there is one file (md extension) per version of product which contains the release note \
(e.g "ipm/2.3.0.md" Release note 2.3.0 of IPM). \
The format of release note file is markdown.
- tools/convert.sh: Tool to generate internal release note (json file) from original product release note files (md files).

## How to modify a release note

* Edit the "\<product\>/\<version\>.md" file and make directly modifications inside the file.
with \<product\> = Name of the product (e.g "ipm") \
     \<version\> = Version of the product (e.g "2.3.0")
* Use the markdown preview in github to check the modifications.
* When is good, commit the file modified in the master branch.

## How to generate a new release note

* Create a new file "\<product\>/\<new-version\>.md" from github.
with \<product\> = Name of the product (e.g "ipm") \
     \<new-version\> = New version of the product (e.g "2.3.0")
* Edit the new file and make directly modifications inside file.
* You can copy the content of a previous version to have the correct format.
* Use the markdown preview in github to check the modifications.
* Commit the new file in the master branch.

## Advanced mode: Generation of internal release note (json format)

The CI process needs a JSON file for generating release note into product package. \
This tool is used to generated this JSON file.

From within the source tree, run the script with input parameters as following to generate internal release note:
```
./tools/convert.sh <CURRENT_VERSION> <INPUT_DIR> <output_file_JSON> [<output_file_PDF/TXT>]

with CURRENT_VERSION: Current version for release note (e.g "2.6.0-1").
                      Could be empty to have all versions available.
     INPUT_FILE: Input directory which contains release note files (*.md)
     output_file_JSON: Output release note file (JSON format)
     output_file_PDF/TXT: Output release note file (cumulative PDF and TEXT format)
                          which can either be "file.pdf" or "file"
```

Check the generated internal release note (JSON file). \
It is a JSON file and must have this format (e.g for IPM with two release note files "2.3.0.md" and "2.2.0.md"):
```json
[
	{
		"version": "2.3.0",
		"content": "<content of release note (2.3.0.md) without carriage return (replaced with \\n)>\\n"
	},
	{
		"version": "2.2.0",
		"content": "<content of release note (2.2.0.md) without carriage return (replaced with \\n)>\\n"
	}
]
```

This section would be used to publish the released image.
