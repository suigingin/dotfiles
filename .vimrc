"no vi
set nocompatible

"set syntacColor
colorscheme molokai
syntax on

"intendSetting
set autoindent
set tabstop=4
set shiftwidth=4

"setting for scroll
set scrolloff=3

"no mouse
set mouse=

"highlight cursorline
set cursorline
	augroup cch
		autocmd! cch
		autocmd WinLeave * set nocursorline
		autocmd WinEnter, BufRead * set cursorline
	augroup END
:hi clear CursorLine
:hi CursorLine gui=underline


"extend cursorMove
set whichwrap=b,s,h,l,<,>,[,],~
nnoremap j gj
nnoremap k gk

"number on/off
nnoremap <C-o> :set number<CR>
nnoremap <C-n> :set nonumber<CR><Esc>

"setting for color
set t_Co=256
set background=dark

"enable backSpace
set backspace=start,eol,indent

"enable clipboard
"set clipboard=unnamed

"show lineNumber
set number

"show matchingObject
set showmatch
set matchtime=2

"show ruler
set ruler

"show unvisibleWord
set list
set listchars=tab:>\ ,trail:_,extends:^,precedes:<

"show 2byteSpace
highlight ZenkakuSpace cterm=underline ctermbg=red guibg=#666666
au BufWinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')
au WinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')

"setting for search
set incsearch
"set hlsearch "Take nohl command to release highLight
nnoremap <C-h> :nohlsearch<CR><Esc>
set hlsearch

"Don'make swapFile
set noswapfile

"setting for encode
set encoding=utf-8
set fileencodings=utf-8

"setting for statusLine
set laststatus=2
set statusline=%<%F\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y%=%l,%c\ %P
let g:hi_insert = 'highlight StatusLine guifg=blue guibg=red gui=none ctermfg=white ctermbg=blue cterm=none'
if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    "silent exec g:hi_insert
    silent exec s:slhlcmd
  endif
endfunction
function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction


""plugin
"taglist
set tags=tags;
nnoremap <C-t> :TlistToggle<CR><Esc>

"highlight StatusLine ctermfg=black ctermbg=grey
"highlight CursorLine ctermfg=none ctermbg=darkgray cterm=none
highlight MatchParen ctermfg=none ctermbg=darkgray
"highlight Comment ctermfg=DarkGreen ctermbg=NONE
highlight Directory ctermfg=Darkgreen ctermbg=NONE

set wildmenu wildmode=list:full


""mapping
"      normal visual insert cmdline
" map       o      o      x       x
" map!      x      x      o       o
" nmap      o      x      x       x
" vmap      x      o      x       x
" imap      x      x      o       x
" cmap      x      x      x       o
"
"map!
map! <C-e> fprintf(stderr," \n",);
"nmap
nmap <silent> <Tab> 15<Right>
nmap <silent> <S-Tab> 15<Left>
nmap n nzz
nmap N Nzz
"nnoremap
"To use this mapping, we must execure this command "stty -ixon -ixoff"
nnoremap <C-q> :shell<CR>

