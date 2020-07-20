" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" GoLang autocompletion
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Python
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'

" Lightline status bar plugin
Plug 'itchyny/lightline.vim'


" Initialize plugin system
call plug#end()

" Set Defaults
set number
" set spell

syntax enable
colorscheme monokai

" vnoremap <C-C> :w !xclip -i <CR><CR>
" vnoremap <C-c> :w !xclip -f -sel c<CR>
set clipboard=unnamedplus

map <C-n> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <C-PageUp> :bp<CR>
map <C-PageDown> :bn<CR>
map <f2> :vsp<CR>
map <f3> :sp<CR>
map = :winc l<CR>
map - :winc w<CR>

" Start NerdTree Automatically
function! StartUp()
    if 0 == argc()
        NERDTree
    end
endfunction

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * call StartUp()
" autocmd VimEnter * NERDTree * NERDTreeMirror
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" autocmd BufEnter * NERDTreeMirror
autocmd VimEnter * wincmd w
