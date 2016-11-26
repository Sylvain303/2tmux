" with tmux
" run the bats unittest.bats in another pane
"

let pane=1

func! Tmux_run(pane)
  let f=expand('%:t')
  " # need to be escape
  " Escape + # in bash = disable command
  let bash_cmd="bats ".f
  let cmd="!tmux send-keys -t ".a:pane
  let cmd.=" Escape '\\#' '".bash_cmd."' Enter"
  exec cmd
endf

" mapping
nmap <f12> :wa<cr>:silent call Tmux_run(pane)<cr><c-l>
