" with tmux
" run the code on the current line in next pane
"
" tmux new -s displpay

let pane=1

" command vim in @c
let @c="0\"ry$"

func! Tmux_run(pane, cmd)
  let f=expand('%:t')
  " # need to be escape
  " Escape + # in bash = disable command
  let bash_cmd=a:cmd
  let cmd="!tmux send-keys -t ".a:pane
  let cmd.=" Escape '\\#' '".bash_cmd."' Enter"
  exec cmd
endf

" mapping
" normal select all 
nmap <f12> @c:silent call Tmux_run(pane, @r)<cr><c-l>

"" visual use current selection
"let vcmd="call Write_out(@c)"
"vmap <f12> "cy:exec vcmd<cr>:silent exec cmd<cr>:nohls<cr><c-l>
