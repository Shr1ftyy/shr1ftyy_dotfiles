syntax on
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set number
set hlsearch
set ruler
set wrap!
highlight Comment ctermfg=green
set noswapfile

au FileType python setl shiftwidth=4 tabstop=4
au FileType rs setl shiftwidth=4 tabstop=4


function InitLspPlugins()
	call plug#begin('~/vimplugins')

	Plug 'prabirshrestha/vim-lsp'
	Plug 'mattn/vim-lsp-settings'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'ziglang/zig.vim'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'ghifarit53/tokyonight-vim'

	call plug#end()
endfunction

call InitLspPlugins()

function StartLsp()
	function! OnLspBufferEnabled() abort
	    setlocal omnifunc=lsp#complete
	    setlocal signcolumn=yes
	    nmap <buffer> gi <plug>(lsp-definition)
	    nmap <buffer> gd <plug>(lsp-declaration)
	    nmap <buffer> gr <plug>(lsp-references)
	    nmap <buffer> gl <plug>(lsp-document-diagnostics)
	    nmap <buffer> <f2> <plug>(lsp-rename)
	    nmap <buffer> <f3> <plug>(lsp-hover)
        inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
        inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
	endfunction

	augroup lsp_install
	  au!
	  autocmd User lsp_buffer_enabled call OnLspBufferEnabled()
	augroup END

endfunction

call StartLsp()

colorscheme tokyonight
hi Normal guibg=NONE ctermbg=NONE

