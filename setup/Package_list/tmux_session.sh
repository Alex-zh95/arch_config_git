#/bin/sh 
t_session_name=$(/usr/bin/pwd | /usr/bin/sed 's/.*\///g')
tmux new -s "$t_session_name"
