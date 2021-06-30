# noop

`no`te-lo`op` REPL-ish for my plaintext notes

## Inspired by https://github.com/alichtman/fzf-notes

A loop around searching and editing text notes files.

Just run `noop` and start searching for the name or contents of the file you
want to open or edit. Hit enter to edit any found file. Searching is done with
`fzf` and `ripgrep`.

Search for `ccc`, and hit enter to be prompted for a new filename, and edit it.

Search for `nnn`, and hit enter to open a new timestamped file and edit it.

When the editor is quit, then you're back to the search prompt.

Loop between search and edit until a Ctrl-c.

## TODO
* Tab-completion for subdirs when creating new notes.
* Way of ranking search matches better. Perhaps two result lists, one for
  filenames and one for contents.

## Installation

### Install needed tools

* ripgrep: https://github.com/BurntSushi/ripgrep

* fzf: https://github.com/junegunn/fzf

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

* preview.sh: part of https://github.com/junegunn/fzf.vim

    curl -sL https://raw.githubusercontent.com/junegunn/fzf.vim/master/bin/preview.sh > ~/bin/preview.sh && chmod +x ~/bin/preview.sh

### Install noop itself

    ln -s ~/src/noop/noop.sh ~/bin/noop

### Create the notes directory

    mkdir -p ~/Notes

If you wish to use a different location (I use `~/Nextcloud/Notes`) then edit
`NOOP_NOTES_DIR` in `noop.sh`.

## Using

Just run `noop` and start searching for the note file you want to edit. Hit
enter to select the note file and open $EDITOR with that file.

There is a `CREATE_NEW_FILE` dummy file in the search results, which then
prompts you for a new filename (which can include a new subdirectory name too),
and then opens the $EDITOR with the new file. If you don't specify a file
extension, then it defaults to `.md` for a markdown document.

Once you have made your changes to the notes file, then close $EDITOR to be put
back into the search view.

Use Ctrl-c to exit the search view. I just leave it running in a terminal on
each computer, and share my notes via NextCloud.

## LICENCE

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or distribute
this software, either in source code form or as a compiled binary, for any
purpose, commercial or non-commercial, and by any means.

In jurisdictions that recognize copyright laws, the author or authors of this
software dedicate any and all copyright interest in the software to the public
domain. We make this dedication for the benefit of the public at large and
to the detriment of our heirs and successors. We intend this dedication to
be an overt act of relinquishment in perpetuity of all present and future
rights to this software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. For more information,
please refer to <https://unlicense.org/>
