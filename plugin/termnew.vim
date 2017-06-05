" Copyright 2017 Michał Kaliński

if get(g:, 'loaded_TermNew', 0)
	finish
endif
let loaded_TermNew = 1


command -nargs=* -complete=shellcmd TermNew
\	call termnew#command_termnew(<f-args>)
