" Copyright 2017 Michał Kaliński

if exists('g:loaded_TermNew')
	finish
endif
let loaded_TermNew = 1


command -nargs=* -complete=shellcmd -count TermNew
\	call termnew#do_command(<count>, <f-args>)
