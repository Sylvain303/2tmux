" with tmux
" run the code on the current line in next pane
"
" tmux new -s displpay

let session="display"
let window=session.":0"
let pane=window.".0"

func! Tmux_run(pane, cmd)
  let f=expand('%:t')
  " # need to be escaped
  " Escape + # in bash = disable command
  let cmd="!tmux send-keys -t ".a:pane
  " escape bash single quote
  " https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
  let mycmd=substitute(a:cmd, "'", "'\"'\"'", "g")
  " escaped # as vim change it to last filename
  let mycmd=escape(mycmd, "#")
  " remove leading blank so command go to bash history
  let mycmd=substitute(mycmd, '^\s\+', '', '')
  let cmd.=" Escape '\\#' '".mycmd."' Enter"
  exec cmd
endf

"========================================= helpers
" command vim in @c text to be sent to tmux in @r
" this register is executed before the call to Tmux_run()
let @c="0\"ry$"

"========================================= bats
" store current <CWORD> for runing test with bats -f
" copy this line to @c
" 0f"l"tyt":let @r="bats -f '".escape(@t, '\[]().')."' ".expand('%:t')|w

" mapping
" normal select all with the macro in @c
nmap <f12> @c:silent call Tmux_run(pane, @r)<cr><c-l>

"" visual use current selection
"let vcmd="call Write_out(@c)"
"vmap <f12> "cy:exec vcmd<cr>:silent exec cmd<cr>:nohls<cr><c-l>
