" with tmux
" run the code given by vimF12: in other tmux
"

" same tmux
"let pane=1

" another tmux on the same computer named display
" tmux new -s displpay
let session="display"
let window=session.":0"
let pane=window.".0"

func! Tmux_run(pane, cmd)
  " remove white space in front
  let bash_cmd=substitute(a:cmd, '^\s\+', '', '')
  let bash_cmd=shellescape(bash_cmd)
  " vim eval conflict
  let bash_cmd=escape(bash_cmd, '#!')
  " save for debug in @z
  let @z=bash_cmd

  let cmd="!tmux send-keys -t ".a:pane
  " # need to be escape
  " Escape + # in bash = disable command but put in history
  let cmd.=" Escape '\\#' ".bash_cmd." Enter"
  exec cmd
endf

func! This_mapping()
  " save last search and restore
  let last_search=@/
  " save all buffer, mark current cursor position
  " normal copy the line matching "vimF12" in @r
  exec ":wa\<cr>mc1G/vimF12:\<cr>f:w\"ry$:"
  silent call Tmux_run(g:pane, @r)
  " return back to c marker
  exec "'c"
  redraw!
  let @/=last_search
endf

" The mapping
nmap <f12> :silent call This_mapping()<cr><c-l>
