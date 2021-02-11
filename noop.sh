#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

## `no`te-lo`op` REPL-ish for my plaintext notes
#
## Inspired by https://github.com/alichtman/fzf-notes
#
## Needed tools:
#
#  ripgrep: https://github.com/BurntSushi/ripgrep
#
#  fzf: https://github.com/junegunn/fzf
#       git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
#
#  preview.sh: part of https://github.com/junegunn/fzf.vim
#       curl -sL https://raw.githubusercontent.com/junegunn/fzf.vim/master/bin/preview.sh > ~/bin/preview.sh && chmod +x ~/bin/preview.sh
#
## USAGE
#
# Just run `noop` and start searching for the note file you want to edit. Hit
# enter to select the note file and open $EDITOR with that file.
#
# There is a `CREATE_NEW_FILE` dummy file in the search results, which then
# prompts you for a new filename (which can include a new subdirectory name too),
# and then opens the $EDITOR with the new file. If you don't specify a file
# extension, then it defaults to `.md` for a markdown document.
#
# Once you have made your changes to the notes file, then close $EDITOR to be put
# back into the search view.
#
# Use Ctrl-c to exit the search view. I just leave it running in a terminal on
# each computer, and share my notes via NextCloud.

if ! command -v rg &> /dev/null
then
    echo "Please install ripgrep / rg to use noop"
    echo "    https://github.com/BurntSushi/ripgrep"
    exit 1
fi

if ! command -v fzf &> /dev/null
then
    echo "Please install fzf to use noop"
    echo "    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install"
    exit 1
fi

if ! command -v preview.sh &> /dev/null
then
    echo "Please install preview.sh to use noop"
    echo "    curl -sL https://raw.githubusercontent.com/junegunn/fzf.vim/master/bin/preview.sh > ~/bin/preview.sh && chmod +x ~/bin/preview.sh"
    exit 1
fi

# Where should this script look for the notes dir. Must exist.
NOOP_NOTES_DIR="~/Notes"

# Set a default file extension for any new files created.
NOOP_FILE_DEFAULT_EXTENSION="md"

mainloop () {
    while true; do
        echo "CREATE_NEW_FILE" > CREATE_NEW_FILE
        set +e # fzf returns 1 for no match, and 130 for Ctrl-c and Escape, so turn off 'e' so we can check later.
        SEARCH_RESPONSE="$(rg --passthrough --line-number "" | fzf --preview="preview.sh {}" --preview-window=right:70%:wrap --expect=ctrl-c)"
        SEARCH_EXIT_CODE=$?
        rm CREATE_NEW_FILE
        set -e

        # The --expect option to fzf has it returning two lines each time.
        # The first line is blank if it's one of the default completion keys
        # like enter or escape. Or 'ctrl-c' for Ctrl-c.
        # The second line is in <filename>:<line_number>:<line content> format.

        OLD_IFS=$IFS
        IFS=" "
        SEARCH_RESULT=""
        while read -r RESPONSE_LINE; do
            if [ "$RESPONSE_LINE" = "ctrl-c" ]; then
                exit
            fi
            SEARCH_RESULT="$RESPONSE_LINE"
        done < <(echo $SEARCH_RESPONSE)
        IFS=$OLD_IFS

        if [ -n "$SEARCH_RESULT" ]; then
            # Result returned in <filename>:<line number>:<line content>
            # format. Capture the filename and line number so we can open to
            # the right location in the file.
            FILE_TO_EDIT=$(echo $SEARCH_RESULT | awk -F: '{print $1}')
            LINE_NUMBER=$(echo $SEARCH_RESULT | awk -F: '{print $2}')

            #echo "SEARCH_RESULT=[$SEARCH_RESULT], FILE_TO_EDIT=[$FILE_TO_EDIT], LINE_NUMBER=[$LINE_NUMBER]"; exit;

            if [ "$FILE_TO_EDIT" = "CREATE_NEW_FILE" ]; then
		read -e -p "Enter a new file name: " FILE_TO_EDIT
                if [ -n "$FILE_TO_EDIT" ]; then
                    FILE_TO_EDIT_EXTENSION="${FILE_TO_EDIT##*.}"
                    if [ "$FILE_TO_EDIT_EXTENSION" = "$FILE_TO_EDIT" ] && [ -n "$NOOP_FILE_DEFAULT_EXTENSION" ]; then
                        # TODO: Handle case where a directory name only is entered. We don't want mydir/.md here.
                        FILE_TO_EDIT="$FILE_TO_EDIT.$NOOP_FILE_DEFAULT_EXTENSION"
                    fi
                    mkdir -p "$(dirname "$FILE_TO_EDIT")"
                    $EDITOR "$FILE_TO_EDIT"
                fi
            else
                $EDITOR "$FILE_TO_EDIT" +$LINE_NUMBER
            fi
        fi
    done
}

# Resolve ~/ to $HOME here, so we can work with a notes dir with spaces.
NOOP_NOTES_DIR="$(echo $NOOP_NOTES_DIR | sed "s#^~/#$HOME/#")"
cd "$NOOP_NOTES_DIR"

mainloop

## LICENCE
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or distribute
# this software, either in source code form or as a compiled binary, for any
# purpose, commercial or non-commercial, and by any means.
#
# In jurisdictions that recognize copyright laws, the author or authors of this
# software dedicate any and all copyright interest in the software to the public
# domain. We make this dedication for the benefit of the public at large and
# to the detriment of our heirs and successors. We intend this dedication to
# be an overt act of relinquishment in perpetuity of all present and future
# rights to this software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
# THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. For more information,
# please refer to <https://unlicense.org/>
