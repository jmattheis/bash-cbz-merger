#!/bin/bash

# Copyright (c) 2019 jmattheis
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software 
# without restriction, including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
# to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
# FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

POSITIONAL=()
while [[ $# -gt 0 ]]
do
parameter="$1"

DIRECTORY=./
EXTENSION=.cbz
TEMP_DIR=./.cbz-merger

case $parameter in
    -i|--input)
    INPUT="$2"
    shift 
    shift
    ;;
    -o|--output)
    OUTPUT_FILE="$2"
    shift
    shift
    ;;
    --extension)
    DIR="$2"
    shift
    shift
    ;;
    --temp-dir)
    TEMP_DIR="$2"
    shift
    shift
    ;;
    --clean-temp)
    CLEAN_TEMP="yes"
    shift
    ;;
    --override)
    OVERRIDE="yes"
    shift
    ;;
    --chronological)
    CHRONOLOGICAL="yes"
    shift
    ;;
    -h|--help)
cat << EOF
NAME:
    cbz-merger.sh Merges cbz files.

DESCRIPTION:
    This script does the following following for each .cbz file (configurable via --extension):
      1. Extract files to --temp-dir
      2. Rename files to cbz-filename_filename.
         F.ex. if there was a file 018.png inside Chapter1.cbz
         it would be renamed to Chapter1.cbz018.png
      3. Add renamed files to --output

    The renaming is done to keep ordering and not have duplicates inside the cbz file.

USAGE:
    cbz-merger.sh [OPTIONS]

OPTIONS:
    --input value, -i value       Define the input directory. (required)
    --output value, -o value      Define the output file. (required)
    --extension value             Define the extension. (default: .cbz)
    --temp-dir value              Define the temp directory where files get extracted. (default: .cbz-merger)
    --clean-temp                  Clean the temp directory before merging the files.
    --override                    Override the --output file if it exist.

EXAMPLES:
    ./cbz-merger.sh --input ./mymanga --output ./manga.cbz
    ./cbz-merger.sh --input "./My Manga" --output merged.cbz --override --clean-temp

SOURCES:
    https://github.com/jmattheis/bash-cbz-merger

EOF
    exit 0
        ;;
    *)
    echo Unknown paramenter $1
    exit 1
    ;;
esac
done
set -- "${parameter[@]}"

if [ -z "$INPUT" ]; then
    echo Input parameter required. See --help
    exit 1
fi

if [ -z "$OUTPUT_FILE" ]; then
    echo Output parameter required. See --help
    exit 1
fi

if [ -d "$TEMP_DIR" ]; then
    if [ "$CLEAN_TEMP" ]; then 
        echo Cleaning $TEMP_DIR
        rm -rf $TEMP_DIR
    else
        echo Temp dir $TEMP_DIR already exists, remove it or add --clean-temp
        exit 1
    fi
fi

if [ -f "$OUTPUT_FILE" ]; then
    if [ "$OVERRIDE" ]; then 
        echo Removing $OUTPUT_FILE
        rm -f $OUTPUT_FILE
    else
        echo Output File $OUTPUT_FILE already exists.
        echo Remove it or add --override.
        exit 1
    fi
fi

mkdir -p "$TEMP_DIR"

if [ "$CHRONOLOGICAL" ]; then
    FILES=$(ls -rt "$INPUT"/*$EXTENSION)
else
    FILES=$(ls -v "$INPUT"/*$EXTENSION)
fi

while IFS= read -r FILE; do
    echo Processing `basename "$FILE"`
    unzip -q -d $TEMP_DIR/ "$FILE"
    for TEMP_FILE in "$TEMP_DIR"/*; do
        mv "$TEMP_FILE" "$TEMP_DIR/`basename "$FILE"`_`basename "$TEMP_FILE"`"
    done
    zip -qjur "$OUTPUT_FILE" "$TEMP_DIR"
    rm -rf "$TEMP_DIR"
done <<< "$FILES"
echo Done.
