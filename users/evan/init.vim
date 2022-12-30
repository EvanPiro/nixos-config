let mapleader=" "

colorscheme evening

"block global message
set shortmess+=I

"set go=a
set mouse=a
set clipboard+=unnamedplus

" Some basics:
	"nnoremap c "_c
	set nocompatible
  filetype on
	filetype plugin indent on
	syntax on
	set encoding=utf-8
	set number
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Goyo plugin makes text more readable when writing prose:
" map <leader>f :Goyo \| set bg=light \| set linebreak<CR>

"call spell
nnoremap <leader>o :Spell


nnoremap <leader>cr :CocRestart
"command! Cr CocRestart


function! SetSpell()
  set spell spelllang=en_us
  setlocal spell spelllang=en_us
  "hi clear spellLocal
  "hi spellLocal cterm=underline
  hi SpellBad guifg=#ff0000
endfunction
command Spell call SetSpell()

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l
	map <C-=> <C-w>=
	map <C-s> :w

	tnoremap <C-n> <C-n>
	tnoremap <C-h> <C-n><C-w>h
	tnoremap <C-j> <C-n><C-w>j
	tnoremap <C-k> <C-n><C-w>k
	tnoremap <C-l> <C-n><C-w>l
	tnoremap <C-=> <C-n><C-w>=

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex

	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

	cnoremap hoogle !hoogle "$@"

" Enable Goyo by default for mutt writting
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost files,directories !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufWritePost *Xresources,*Xdefaults execute 'silent! !xrdb %'
" Update binds when sxhkdrc is updated.
	autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd

	autocmd BufWritePost ~/.local/src/st.git/* exec 'silent! !sudo make instal'


" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

nnoremap <Space>p :! zathura $( echo % \| sed "s/tex$/pdf/" ) &

set number
"makes tabs work as 2 spaces
set tabstop=2 softtabstop=0 shiftwidth=2 smarttab

set ai si

let @d = "{j^yiw}OpA " "adds a new declaration
let @p = "Oo" "add paragraph
let @c = "\"zdi\"P" "change contents of quote to clipboard
let @h = "yypVr"

set showcmd

nnoremap <Return> :noh
cnoremap pdf !pdflatex % > /dev/null

"scroll when 4 lines from the bottom
set so=4

"search
set hlsearch
set ignorecase
set smartcase "caps are case sensitive

"source ~/.config/metaconfig/vimpart.vim
autocmd BufWritePost ~/.config/metaconfig/configlist ! ~/.config/metaconfig/gen.sh
autocmd BufWritePost /etc/hosts.d/* ! ~/scripts/hostsUpdate

function! GHCI()
	sp
	te ghci %
endfunction
"nnoremap <C-g> :Ghcid
"vnoremap <C-t> y:call Ghci()A:t <C-\><C-n>pa

autocmd FileType tex call SetSpell()
autocmd FileType haskell set expandtab
autocmd FileType lhaskell set expandtab
autocmd FileType agda set expandtab
autocmd FileType cabal set expandtab
autocmd FileType nix set expandtab
autocmd FileType c set expandtab
"why not c too?
autocmd FileType purescript set expandtab


let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '

nnoremap [] :lfirst
nnoremap ]] :lnext
nnoremap [[ :lprevious

let b:lhs_markup = "tex"

au BufRead,BufNewFile *.v   set filetype=coq
au BufRead,BufNewFile *.nix set filetype=nix
au BufRead,BufNewFile cabal*.project   set filetype=cabal

let g:agda_theme =  "dark"
let g:agda_keymap = "vim"

au BufNewFile,BufRead *.agda setf agda

set termguicolors

"hls coc stuff
map <Leader>gd <Plug>(coc-definition)
map <Leader>gi <Plug>(coc-implementation)
map <Leader>gt <Plug>(coc-type-definition)
map <Leader>gh :call CocActionAsync('doHover')<cr>
map <Leader>gn <Plug>(coc-diagnostic-next)
map <Leader>gp <Plug>(coc-diagnostic-prev)
map <Leader>gr <Plug>(coc-references)

map <Leader>rn <Plug>(coc-rename)
map <Leader>rf <Plug>(coc-refactor)
map <Leader>qf <Plug>(coc-fix-current)

map <Leader>al <Plug>(coc-codeaction-line):w
map <Leader>ac <Plug>(coc-codeaction-cursor)
map <Leader>ao <Plug>(coc-codelens-action)

nnoremap <Leader>kd :<C-u>CocList diagnostics<Cr>
nnoremap <Leader>kc :<C-u>CocList commands<Cr>
nnoremap <Leader>ko :<C-u>CocList outline<Cr>
nnoremap <Leader>kr :<C-u>CocListResume<Cr>

nnoremap <C-s> :w

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

set undofile

function ReNix()
	wa
	mksession!
	qa
endfunction

command Renix call ReNix()

command Fmt silent! !./bin/format

autocmd VimEnter * silent !rm Session.vim

let g:purescript_disable_indent = 1
