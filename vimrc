if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set bdir=~/.vim/bdir//
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
	set udir=~/.vim/udir//
  endif
endif
set hlsearch "搜索高亮"
set incsearch "搜索时随着输入开始搜索"
set ignorecase "ignore cases in search"
set smartcase "Smartly decide cases in search"
set wrapscan "搜索时可以从尾到头"
set number "显示行号"
set relativenumber "顯示 relative 行號
set whichwrap=b,s,<,>,[,],l,h "左滑、右滑等可以跨行"
" set clipboard=unnamedplus "Enable Clipboard
set clipboard=unnamed
" set mouse=a " Enable Mouse
set autoindent
set tabstop=4
" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2



map s <nop>
inoremap <C-h> <left>
inoremap <C-l> <Right>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap jk <ESC>

" Below are mappers that can easily split the window into h: left, j: up, k: down, l: right
map sh :set nosplitright<CR>:vsplit<CR>
map sj :set nosplitbelow<CR>:split<CR>
map sk :set splitbelow<CR>:split<CR>
map sl :set splitright<CR>:vsplit<CR>

noremap <tab> :bn<CR>
noremap <S-tab> :bN<CR>
noremap j gj
noremap k gk

" map tt :set nosplitright<CR>:vsplit<CR>:vertical resize 30<CR>:e .<CR>
map tt :call ToggleVSplit()<CR>
function! ToggleVSplit()
    if winnr('$') > 1
        if &columns > 160
            :close
        endif
    else
        :set nosplitright
        :vsplit
        :vertical resize 30
        :e .
    endif
endfunction


"in normal mode, <up>, <down>, <left>, <right> can change the size of the
"splited window"
noremap <C-up> :res -3<CR>
noremap <C-down> : res +3<CR>
noremap <C-left> :vertical resize +3<CR>
noremap <C-right> :vertical resize -3<CR>

"remap so that H, J, K, L can be used to move faster
noremap H 3h
noremap J 5j
noremap K 5k
noremap L 3l

let mapleader = " "
"map <space> and direction-bottom to easily change the curse in different
"splited windows.
noremap <LEADER>h <C-w>h
noremap <LEADER>j <C-w>j
noremap <LEADER>k <C-w>k
noremap <LEADER>l <C-w>l
noremap <LEADER><left> <C-w>h
noremap <LEADER><up> <C-w>j
noremap <LEADER><right> <C-w>l
noremap <LEADER><down> <C-w>k

" Delete a Buffer
nmap <leader>x :bdelete<CR>

"mapping: Quickly modify the vimrc
map vimrc :vsplit ~/.vimrc<CR>

"open terminal in the right part of the window
map term<tab> :terminal<CR><C-w>L

" set Vim-specific sequences for RGB colors
" This is to solve problems related to st terminal emulator
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

syntax enable

set nocursorline

"""" Fold Stuff  """"
set foldmethod=manual
set foldnestmax=10
set nofoldenable
set foldlevel=2

""" Use `date` to print current date formatted
noremap date :r! date +"\%Y-\%m-\%d \%H:\%M:\%S"<CR>kdd

function! FormatJson()
	let l:filename = expand('%:t')
	if l:filename =~ '\.json$'
		set filetype=json
		%!jq '.'
		" %!python -m json.tool
		echo "JSON file formatted."
	endif
	execute "normal \<C-w>="
	echo "This is NOT a JSON file."
	echo "Windows equalized."
endfunction

noremap == :call FormatJson()<CR>

set showtabline=5 "show file names on the top bar


set rtp+=/opt/homebrew/opt/fzf
colorscheme desert
