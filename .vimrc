"使vim可以正常打开各种中文编码的文件
set encoding=utf-8
let &termencoding=&encoding
set fileencodings=utf-8,gb18030,gbk,gb2312

"显示行号
set number
"设置不显示行号的快捷键
map <silent> <F4> :set nonumber<cr>
"开启语法高亮
syntax on
"在状态栏显示正在输入的命令
set showcmd
"默认缩进设置为4个字符大小
set shiftwidth=4
"设置自动缩进
set autoindent
"设置制表符宽度
set tabstop=4
"python tab->4spaces
filetype indent on
autocmd FileType python setlocal et sta sw=4 sts=4
autocmd FileType java setlocal et sta sw=4 sts=4
"设置命令行的高度
set cmdheight=3
"设置进入粘贴模式的快捷键，可以避免window下复制的内容在vim里粘贴自动换行的问题
set pastetoggle=<F3>

"设置代码可折叠,za为{}折叠和展开的切换键
set foldmethod=syntax
set foldlevelstart=99

setlocal indentexpr=GetGooglePythonIndent(v:lnum)

let s:maxoff = 50 " maximum number of lines to look backwards.

" Indent Python in the Google way.
function GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"
