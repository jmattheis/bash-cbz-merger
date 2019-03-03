# bash-cbz-merger

### Download
```
$ wget https://raw.githubusercontent.com/jmattheis/bash-cbz-merger/master/cbz-merger.sh
$ chmod +x cbz-merger.sh
```
### Usage
```bash
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

```
