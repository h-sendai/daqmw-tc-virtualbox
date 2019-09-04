set ttimeoutlen=100
autocmd BufRead,BufNewFile Makefile* set noexpandtab
autocmd BufRead,BufNewFile makefile* set noexpandtab
" don't auto insert comment mark
autocmd FileType * setlocal formatoptions-=ro
set nomodeline
set background=dark
syntax clear
syntax off
set tabstop=4
set shiftwidth=4
set expandtab
set ai
set showmatch
set ignorecase
set smartcase
set nohlsearch
set matchtime=4
set smartcase
let loaded_matchparen = 0
""############################################################################
""#    Vim config (Recommended) from Appendix C of "Perl Best Practices"     #
""#     Copyright (c) O'Reilly & Associates, 2005. All Rights Reserved.      #
""#  See: http://www.oreilly.com/pub/a/oreilly/ask_tim/2001/codepolicy.html  #
""############################################################################

"set autoindent                    "Preserve current indent on new lines
"set textwidth=78                  "Wrap at this column
"set backspace=indent,eol,start    "Make backspaces delete sensibly
 
"set tabstop=4                     "Indentation levels every four columns
"set expandtab                     "Convert all tabs typed to spaces
"set shiftwidth=4                  "Indent/outdent by four columns
"set shiftround                    "Indent/outdent to nearest tabstop
 
"set matchpairs+=<:>               "Allow % to bounce between angles too
 
""Inserting these abbreviations inserts the corresponding Perl statement...
"iab phbp  #! /usr/bin/perl -w      
"iab pdbg  use Data::Dumper 'Dumper';warn Dumper [];hi
"iab pbmk  use Benchmark qw( cmpthese );cmpthese -10, {};O     
"iab pusc  use Smart::Comments;### 
"iab putm  use Test::More qw( no_plan );
 
"iab papp  :r ~/.code_templates/perl_application.pl
"iab pmod  :r ~/.code_templates/perl_module.pm

"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"set laststatus=2

set encoding=utf-8
set fileencodings=utf8,iso-2022-jp,euc-jp,sjis

" vim on archlinux does not have automatic cursor restore.
" https://wiki.archlinux.org/index.php/Vim#Make_Vim_restore_cursor_position_in_files
if has("autocmd")
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
