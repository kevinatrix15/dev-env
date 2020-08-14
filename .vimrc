"set number
"colorscheme industry
""map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
"set colorcolumn=80
"
"" Disable annoying beeping
set noerrorbells
set vb t_vb=

" TODO: fix below!!!
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'vim-scripts/DoxygenToolkit.vim'
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


set runtimepath-=~/.vim/bundle/vim-plugins

"configure tabs
set autoindent
set cindent
set cinkeys-=0#
set indentkeys-=0#
set tabstop=2
set shiftwidth=2
set noexpandtab

"Clean code please
set smartindent
set smarttab
set expandtab

"match braces
set showmatch
"
"don't highlight
"set nohls

" Press Space to turn off highlighting and clear any message already displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

"increment search
set incsearch
set ignorecase
set smartcase

" remember 300 lines
set history=300

" display line number and syntax highlighting
syntax on
set number
set modeline
set ls=2

" show line numbers
set number

"colorscheme desert
"colorscheme wombat

set backspace=2


" set rule at 80 columns and line wrapping
if exists('+colorcolumn')
    set colorcolumn=80
    set tw=79
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Smart C-style comments
set formatoptions+=r

"local vimrc
let g:localvimrc_ask=0

set mouse=a

" Search for selected text
vnoremap // y/<C-R>"<CR>

"" Make cursor block instead of I-beam
"au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
"au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
"au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
"au VimEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"

" configure doxygen
let s:meNameEmail="Kevin Briggs <kevin.briggs@ansys.com>"
let s:copyright="Copyright 2020, Ansys Inc."
let g:DoxygenToolkit_commentType="C"
let g:DoxygenToolkit_authorName=s:meNameEmail."\<enter>* ".s:copyright
let g:DoxygenToolkit_versionString="1"
let g:maxFunctionPrototypeLines="30"

" syntastic
" setup file types
autocmd BufRead,BufNewFile *.h set filetype=cpp

" highlight trailing white space
match ErrorMsg '\s\+$'

" Use Pantheon
"call pathogen#infect()

" DefProtect command
fu! DefProtectFunc( name )
set paste
execute "normal o" . "#ifndef " . a:name
execute "normal o" . "#define " . a:name
execute "normal o" . ""
execute "normal o" . "#endif"
set nopaste
endfunction
command DefProtect :call DefProtectFunc(input("Enter Name: "))

" Section Comment command
fu! SectionCommentFunc( name )
let width = 79
let len = width - 3 - strlen(a:name)
set paste
execute "normal o" . "/" . repeat("*",width-1)
execute "normal o" . "* " . a:name . " " . repeat("*",len)
execute "normal o" . repeat("*",width-1) . "/"
execute "normal o" . ""
execute "normal o" . ""
set nopaste
endfunction

" SubSection Comment command
fu! SubSectionCommentFunc( name )
let width = 79
let len = width - 5 - strlen(a:name)
set paste
execute "normal o" . "/* " . a:name . " " . repeat("*",len) . "/"
execute "normal o" . ""
set nopaste
endfunction

command Section :call SectionCommentFunc(input("Enter Section Title: "))
command Subsection :call SubSectionCommentFunc(input("Enter Subsection Title: "))

" Clang format key bindings "
map <C-K> :py3f /usr/share/clang/clang-format-6.0/clang-format.py<cr>
imap <C-K> <c-o>:py3f /usr/share/clang/clang-format-6.0/clang-format.py<cr>
