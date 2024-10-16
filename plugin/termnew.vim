" Copyright 2017,2019,2024 Michał Kaliński

if get(g:, 'loaded_termnew', 0)
	finish
endif

let g:loaded_termnew = 1

command -nargs=* -complete=shellcmd TermNew
\	call termnew#open(<q-mods>, <f-args>)

command -nargs=+ -complete=file TermNewCwd
\	call termnew#open_cwd(<q-mods>, <f-args>)
