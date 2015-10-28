" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" do not keep a backup file, use versions instead
set nowritebackup
set noswapfile
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" start by liwei
" Set mapleader
let mapleader = ","

" Fast reloading of the ~/.vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>
" Fast editing of the ~/.vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>
" When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc


" Platform
function! MySys()
  if has("win32")
    return "windows"
  else
    return "linux"
  endif
endfunction

function! SwitchToBuf(filename)
    "let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
    " find in current tab
    let bufwinnr = bufwinnr(a:filename)
    if bufwinnr != -1
        exec bufwinnr . "wincmd w"
        return
    else
        " find in each tab
        tabfirst
        let tab = 1
        while tab <= tabpagenr("$")
            let bufwinnr = bufwinnr(a:filename)
            if bufwinnr != -1
                exec "normal " . tab . "gt"
                exec bufwinnr . "wincmd w"
                return
            endif
            tabnext
            let tab = tab + 1
        endwhile
        " not exist, new tab
        exec "tabnew " . a:filename
    endif
endfunction



syntax on
set nu
set cindent
set smartindent
set showmatch
set incsearch
set shiftwidth=4
set ruler
set tabstop=4
set title
set smarttab
"set fdm=indent  "autofold.
filetype on
set autoindent


" from http://lnmcc.net/2013/04/01/mac下vim-taglist-ctags/
" from http://easwy.com/blog/archives/advanced-vim-skills-taglist-plugin/
" set the path of myself ctags execute file 
" 打开taglist命令：TlistOpen
let Tlist_Ctags_Cmd='/usr/local/bin/ctags' "设置linux中ctags位置
let Tlist_Show_One_File=1        "不同时显示多个文件的tag,只显示当前文件的
let Tlist_Exit_OnlyWindow=1 "如果taglist的窗口是最后一个窗口，则退出vim。
let Tlist_Use_Right_Window=1 "在右侧窗口中显示taglist,因为缺省的在左边


""""""""""""""""""""""""""""""
" lookupfile setting
" 首先用ctags -R ./ 生成tags文件
" 然后查找文件时用,lk ,ll ,lw
""""""""""""""""""""""""""""""
let g:LookupFile_MinPatLength = 2               "最少输入2个字符才开始查找
let g:LookupFile_PreserveLastPattern = 0        "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 1     "保存查找历史
let g:LookupFile_AlwaysAcceptFirst = 1          "回车打开第一个匹配项目
let g:LookupFile_AllowNewFiles = 0              "不允许创建不存在的文件
if filereadable("./tags")                "设置tag文件的名字
let g:LookupFile_TagExpr = '"./tags"'
endif
"映射LookupFile为,lk
nmap <silent> <leader>lk :LUTags<cr>
"映射LUBufs为,ll
nmap <silent> <leader>ll :LUBufs<cr>
"映射LUWalk为,lw
nmap <silent> <leader>lw :LUWalk<cr>

" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags = &tags
    try
        let &tags = eval(g:LookupFile_TagExpr)
        let newpattern = '\c' . a:pattern
        let tags = taglist(newpattern)
    catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ""
    finally
        let &tags = _tags
    endtry

    " Show the matches for what is typed so far.
    " let files = map(tags, 'v:val["filename"]')
    let files = map(tags, 'v:val["tags"]')
    return files
endfunction
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc' 

"colorscheme
colorscheme darkblue


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
  set csprg=/usr/local/bin/cscope
  set csto=1
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
      cs add cscope.out
  endif
  set csverb
endif

"s: 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
"g: 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
"d: 查找本函数调用的函数
"c: 查找调用本函数的函数
"t: 查找指定的字符串
"e: 查找egrep模式，相当于egrep功能，但查找速度快多了
"f: 查找并打开文件，类似vim的find功能
"i: 查找包含本文件的文件

"nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>

nmap <silent> <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <silent> <leader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <silent> <leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>


""""""""""""""""""""""""""""""
" winManager setting
""""""""""""""""""""""""""""""
let g:winManagerWindowLayout = "BufExplorer,FileExplorer|TagList"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr> " Control-w Control-b 来移动
nmap <silent> <leader>wm :WMToggle<cr>  ",wm 找开


