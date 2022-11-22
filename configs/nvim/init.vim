" Line numbering configurations
set number relativenumber
" Enable mouse control
set mouse=a
"Split options
set splitright splitbelow
" Search options
set ignorecase smartcase
" Tab options
set expandtab tabstop=4 shiftwidth=4
set autoindent
" Backup saving options (no backup)
set nobackup nowritebackup
" Set the folding of file to be according to file's syntax
set foldmethod=syntax
" Remove file browser banner
let g:netrw_banner = 0

if (has("termguicolors"))
    set termguicolors
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim'
Plug 'vim-scripts/TagHighlight'
Plug 'rking/ag.vim'
Plug 'majutsushi/tagbar'
call plug#end()

colorscheme codedark
