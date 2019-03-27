syntax on

set clipboard=unnamed,unnamedplus

augroup auto_comment_off
	autocmd!
	autocmd BufEnter * setlocal formatoptions-=r
	autocmd BufEnter * setlocal formatoptions-=o
augroup END

"--------------------------------------
" タブ/インデント関連
"--------------------------------------
set expandtab          " タブ入力を複数の空白文字に置き換える
set tabstop=4          " タブ文字の表示幅
set shiftwidth=4       " Vimが挿入するインデントの幅
set autoindent
set smartindent
" rubyのときはインデント幅2
autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
"--------------------------------------
" 表示関連
"--------------------------------------
set number             " 行番号を表示する"
set scrolloff=8        " 上下8行の視界を確保

"--------------------------------------
" 検索/置換の設定
"--------------------------------------
set ignorecase         " 大文字と小文字を区別しない
set smartcase          " 検索文字に大文字がある場合は大文字小文字を区別

"--------------------------------------
" ファイル処理など
"--------------------------------------
set nobackup           " 末尾に~が付くバックアップファイルを生成しない
set noswapfile         " ファイルを開いているときにできる.swapファイルを生成しない

"--------------------------------------
" 補完関連
"--------------------------------------
set completeopt=menuone "補完時にScratch Windowを出ないようにする

"--------------------------------------
" マクロ及びキー設定
"--------------------------------------
let mapleader = "\<Space>"
" 入力モード中に素早くjjと押すとノーマルモードに戻る
inoremap <silent> jj <Esc>
" 入力モード中にZZでノーマルモード移動後ZZ
inoremap <silent> ZZ <Esc>ZZ
nnoremap j gj
nnoremap k gk
nmap <silent> <Leader>j :nohlsearch<CR>

" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" CやDとの一貫性のため
nnoremap Y y$
