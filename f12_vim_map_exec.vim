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

  " save all buffers
  wa

  " mark current cursor position in mark 'c
  exe "norm mc"

  " search the line matching the pattern [] avoid find itself
  let found=search("vimF12[:]", 'w')

  if found != 0
    let old_r=@r
    let @r=''

    " cursor has been moved, copy the command in register @r
    exe 'norm f:w"ry$'
    if @r != ''
      silent call Tmux_run(g:pane, @r)
    endif

    "let @r=old_r
  endif

  " return back to c marker
  exe "norm 'c"
  redraw!
  let @/=last_search
endf

" The mapping
nmap <f12> :silent call This_mapping()<cr><c-l>
