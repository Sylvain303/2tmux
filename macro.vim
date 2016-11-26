" with tmux
" run the code between markdown comment to the pane 1
"
" You need to run 2 tmux session
" tmux new -s master 
" tmux new -s displpay

let session="display"
let window=session.":0"
let pane=window.".0"

let f="/srv/salt/base/migration/test.sh"
let @q="?^`\njVNk:w! ".f."\n"
" # need to be escape
" Escape + # in bash = disable command
let cmd="!tmux send-keys -t ".pane." Escape '\\#' 'cat ".f.";source ".f."' Enter"

func! Write_out(content)
  exe "new ".g:f
  normal "1GdG"
  call setline(1, split(a:content, "\n"))
  wq
  " Note: this modify last window
  exe "bdelete ".g:f
endf

" mapping
" normal select all 
nmap <f12> @q:silent exec cmd<cr>:nohls<cr><c-l>
" visual use current selection
let vcmd="call Write_out(@c)"
vmap <f12> "cy:exec vcmd<cr>:silent exec cmd<cr>:nohls<cr><c-l>
