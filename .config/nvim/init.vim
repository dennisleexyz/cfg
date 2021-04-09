if empty(glob(stdpath('data') . '/plugged'))
	silent !curl -fLo "$XDG_DATA_HOME/nvim/site/autoload/plug.vim" --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | q | source $MYVIMRC
		\| call firenvim#install(0)
endif

call plug#begin(stdpath('data') . '/plugged')
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-sensible'
	Plug 'tpope/vim-surround'
	Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
	Plug 'mboughaba/i3config.vim'
	Plug 'kovetskiy/sxhkd-vim'
	Plug 'lilydjwg/fcitx.vim'
	Plug 'vimwiki/vimwiki'
	Plug 'chazmcgarvey/vim-mermaid'
	Plug 'sirtaj/vim-openscad'
	Plug 'airblade/vim-gitgutter'
call plug#end()

autocmd VimEnter *
	\  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	\|	PlugInstall --sync | q
	\| endif

set bg=light
set mouse=a
set clipboard+=unnamedplus

map <leader>s :w! \| !shellcheck -x %<CR>
map <leader>c :w! \| !compiler %<CR>
map <leader>p :!opout <c-r>%<CR><CR>
map <leader>o :setlocal spell! spelllang=en_us<CR>

autocmd BufRead,BufNewFile *.toml,*.conf,*i3blocks/config set ft=dosini
autocmd BufRead,BufNewFile *.txt set ft=markdown

autocmd FileType vim set shiftwidth=2 softtabstop=2 tabstop=2
autocmd FileType python set noexpandtab shiftwidth=4 softtabstop=4 tabstop=4

autocmd BufWritePost *i3/config !i3 -C && i3-msg reload
autocmd BufWritePost *i3blocks/config !i3-msg restart
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd

set guicursor=n-v-c-i-ci-ve-r-cr:block-Cursor
