""""""""""""""""""""""""""""
" .vimrc 
""""""""""""""""""""""""""""

set nocompatible

"構文に色をつける
syntax on
"行番号をつける
set number
"画面上のタブ文字が占める幅
set tabstop=2
"自動インシデントでずれる幅
set shiftwidth=2
"連続した空白に対してタブキー,バックスペースキーでカーソル
set softtabstop=2
"カーソル行の背景色を変える
set cursorline
"カーソル位置のカラムの背景色を変えない
set nocursorcolumn
"ステータス行を表示
set laststatus=2
"メッセージ表示欄を確保
set cmdheight=2
"対応する括弧を強調
set showmatch



" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.vim/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
	if !isdirectory(s:dein_repo_dir)
		execute '!git clone https://github.com/Shougo/dein.vim'
		s:dein_repo_dir
	endif
	execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " ~/.vim/rc/dein.toml,deinlazy.tomlを用意する
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif


" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

filetype plugin indent on


let g:lightline = {
      \ 'colorscheme': 'wombat',
			\ 'component': {
      \   'readonly': '%{&readonly?"\u2b64":""}',
      \ },
			\ 'separator':    { 'left': ">", 'right': "<" },
      \ 'mode_map': {'c': 'NORMAL'},
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
			\ },
      \ 'component_function': {
      \   'modified': 'LightLineModified',
      \   'readonly': 'LightLineReadonly',
			\   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
			\   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode'
      \ }
			\ }

function! LightLineModified()
	  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
	endfunction

function! LightLineReadonly()
	  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightLineFilename()
	  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
		        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
		        \  &ft == 'unite' ? unite#get_status_string() :
		        \  &ft == 'vimshell' ? vimshell#get_status_string() :
		        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
		        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
	  try
			if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
				return fugitive#head()
			endif
		catch
		  endtry
			return ''
endfunction

function! LightLineFileformat()
	  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
	  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
	  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
	  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

