" Copyright 2017,2019 Michał Kaliński

if get(g:, 'loaded_TermNew', 0)
	finish
endif
let loaded_TermNew = 1

command! -nargs=* -complete=shellcmd TermNew
\	call termnew#open_command(<q-mods>, <f-args>)

command! -nargs=1 -complete=file TermNewShellInDir
\	call termnew#open_shell_in_wd(<q-mods>, <q-args>)
