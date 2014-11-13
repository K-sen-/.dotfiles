set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp

"Vi 非互換モード
set nocompatible

" autocmd VimEnter * source ~/.vimrc
augroup MyAutoCmd
    autocmd!
augroup END

"最後のカーソル位置に移動
augroup vimrcEx
    au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "normal g`\"" | endif
augroup END

set t_Co=256        " VIMでのフルカラー使用
set laststatus=2    " 常にステータスラインを表示
set mouse=nv        " ノーマルモードとビジュアルモードでマウス操作の有効化

"タブ／インデントの設定"
set expandtab       " タブ入力を複数の空白入力に置き換える
set tabstop=4       " 画面上でタブ文字が占める幅
set shiftwidth=4    " 自動インデントでずれる幅
set softtabstop=4   " 連続した空白に対してタブキーやBSキーでカーソルが動く幅
set autoindent      " 改行時に前の行のインデントを継続する
set smartindent     " 改行時に入力された行の末尾に合わせて次の行のインデントを増減する

set nowrap          " 折り返さない
set backspace=indent,eol,start " バックスペースで何でも消せる
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ
set scrolloff=8                " 上下8行の視界を確保
set sidescrolloff=16           " 左右スクロール時の視界を確保
set sidescroll=1               " 左右スクロールは一文字づつ行う
set number          " 行番号表示
set cursorline      " カーソル行を明示
autocmd VimEnter,ColorScheme * highlight CursorLine cterm=underline

set wildmenu wildmode=list:full " 複数の候補を一覧表示し、最初の候補を補完対象とする
set clipboard+=unnamed

set showmatch
" set list " 不可視文字の可視化。下記はタブの文字の可視化
" set listchars=tab:>\ 

"検索／置換の設定
set hlsearch    " 検索文字列をハイライトする
set incsearch   " インクリメンタルサーチを行う
set ignorecase  " 大文字と小文字を区別しない
set smartcase   " 大文字と小文字が混在した言葉で検索した場合に限り区別する
set wrapscan    " 最後尾まで検索を終えたら次の検索で先頭に移る
set gdefault    " 置換の時 g オプションをデフォルトで有効にする"

"swapファイル，backupファイルを無効化
set nowritebackup
set nobackup
set noswapfile

"--------------------------
"Start Neobundle Settings.
"--------------------------
" bundleで管理するディレクトリ
set runtimepath+=~/.vim/bundle/neobundle.vim/
" Required:
call neobundle#begin(expand('~/.vim/bundle/'))
" neobundle自体をneobundleで管理
NeoBundleFetch 'Shougo/neobundle.vim'

" ここにpluginを追加する
NeoBundle 'Shougo/unite.vim'    " Unite
NeoBundle 'Shougo/neomru.vim'   " Neomru
NeoBundle 'Shougo/neocomplete'  " Neocomplete
NeoBundle 'Shougo/neosnippet'   " Neosnippet
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }
NeoBundle 'Townk/vim-autoclose' " autoclose
NeoBundle 'tpope/vim-surround'  " surround
NeoBundle 'thinca/vim-template' " vim-template
NeoBundle 'itchyny/lightline.vim'   " lightline
NeoBundle 'scrooloose/syntastic'    " syntax-check
NeoBundle "nathanaelkane/vim-indent-guides" " visible-indent
" NeoComplete,jedi-vimがある場合,表示した補完が他のコードに影響しないよう表示中のみ"等を適宜挿入するが,折り畳まれているコードがある場合その処理が上手くいかず畳まれている部分のコードがコメントアウトされてしまう
" NeoBundle 'python_fold'         " python_fold

NeoBundle 'Shougo/vimfiler.vim' " Vimfiler
NeoBundle 'majutsushi/tagbar'   " Tagber
NeoBundle 'mbbill/undotree'     " Undotree
NeoBundle 'taglist.vim'         " Tlist
NeoBundle 'rking/ag.vim'        " Ag
NeoBundle 'grep.vim'            " grep

NeoBundle 'nanotech/jellybeans.vim'             " Colorscheme
NeoBundle 'altercation/vim-colors-solarized'    " Colorscheme
NeoBundle 'tomasr/molokai'                      " Colorscheme
NeoBundle 'jeffreyiacono/vim-colors-wombat'     " Colorscheme
NeoBundle 'w0ng/vim-hybrid'                     " Colorscheme

colorscheme hybrid
let g:lightline = {'colorscheme':'solarized'}

let g:unite_enable_start_insert = 1
let g:unite_source_history_yank_enable = 1
let g:unite_source_file_mru_limit = 200
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
    let g:unite_source_grep_recursive_opt = ''
endif

" テンプレート中に含まれる特定文字列を置き換える
autocmd MyAutoCmd User plugin-template-loaded call s:template_keywords()
function! s:template_keywords()
    silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
    silent! %s/<+FILENAME+>/\=expand('%:r')/g
endfunction
" テンプレート中に含まれる'<+CURSOR+>'にカーソルを移動
autocmd MyAutoCmd User plugin-template-loaded
    \   if search('<+CURSOR+>')
    \ |   silent! execute 'normal! "_da>'
    \ | endif"'

let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * hi IndentGuidesOdd   ctermbg=110
autocmd VimEnter,Colorscheme * hi IndentGuidesEven  ctermbg=143
let g:indent_guides_guide_size = 1

" Djangoを正しくVimで読み込めるようにする
NeoBundleLazy "lambdalisue/vim-django-support", {
    \ "autoload": {
    \   "filetypes": ["python", "python3", "djangohtml"]
    \ }}
" Vimで正しくvirtualenvを処理できるようにする
NeoBundleLazy "jmcantrell/vim-virtualenv", {
    \ "autoload": {
    \   "filetypes": ["python", "python3", "djangohtml"]
    \ }}
NeoBundleLazy "davidhalter/jedi-vim", {
    \ "autoload": {
    \   "filetypes": ["python", "python3", "djangohtml"]
    \ }}

"------------------------------------
" neocomplete.vim setting
"------------------------------------
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#enable_insert_char_pre = 1
" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    " return neocomplete#close_popup() . "\<CR>"
    " For no inserting <CR> key.
    return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplete#close_popup()
inoremap <expr><C-e> neocomplete#cancel_popup()

" Close popup by <Space>.
inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>" 

" docstringは表示しない
autocmd FileType python setlocal completeopt-=preview
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^.\t]\.\w*'''

call neobundle#end()
" Required:
filetype plugin indent on

" 未インストールのプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定
" 毎回聞かれると邪魔な場合もあるので、この設定は任意です。
NeoBundleCheck
"-------------------------
" End Neobundle Settings.
"-------------------------

"コマンド設定
" Esc×2でハイライト解除
nnoremap <Esc><Esc> :<C-u>set nohlsearch<Return>
" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n','g')<CR><CR>

syntax on
filetype plugin indent on
