" with tmux
" run the code on the current line in next pane
"
" tmux new -s displpay

let session="display"
let window=session.":0"
let pane=window.".0"

func! Tmux_run(pane, cmd)
  let cmd_base="!tmux send-keys -t ".a:pane
  " let f=expand('%:t')

  " escape bash single quote
  " https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
  let mycmd=substitute(a:cmd, "'", "'\"'\"'", "g")
  " handle mutiline ending with \\
  let mycmd=substitute(mycmd, "\\", "\\\\", "g")
  " escape some vim own specials chars:
  " - # = last filename
  " - % = current filename
  let mycmd=escape(mycmd, "#%!")
  " remove leading blank so command go to bash history
  let mycmd=substitute(mycmd, '^\s\+', '', '')
  " Escape + # in bash = disable command
  " send a safe ESC + # to disable any previous line started in the shell
  exec cmd_base." Escape '\\#'"
  if mycmd =~ '\n'
    for l in split(mycmd, '\n')
      let cmd=cmd_base." '".l."' Enter"
      exec cmd
    endfor
  else
    exec cmd_base." '".mycmd."' Enter"
  endif
endf

"========================================= helpers
" command vim in @c text to be sent to tmux in @r
" this register is executed before the call to Tmux_run()
" copy the current line in register @r
let @c="mc0\"ry$`c"

"========================================= bats
" store current <CWORD> for runing test with bats -f
" copy this line to @c
" 0f"l"tyt":let @r="bats -f '".escape(@t, '\[]().')."' ".expand('%:t')|w

" mapping
" normal select all with the macro in @c
nmap <f12> @c:silent call Tmux_run(pane, @r)<cr><c-l>

"" visual use current selection copied in register @r
vmap <f12> "ry:silent call Tmux_run(pane, @r)<cr><c-l>
