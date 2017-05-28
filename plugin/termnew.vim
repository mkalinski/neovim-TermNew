" Copyright 2017 Michał Kaliński

if exists('g:loaded_TermNew')
	finish
endif
let loaded_TermNew = 1


command -nargs=* -complete=shellcmd TermNew
\	call termnew#command_termnew(<f-args>)
