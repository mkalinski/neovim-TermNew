" Copyright 2017,2019,2024 Michał Kaliński

if get(g:, 'loaded_termnew', 0)
	finish
endif

let g:loaded_termnew = 1

command -bang -nargs=* -complete=shellcmd TermNew
\	call termnew#open(<bang>1, <q-mods>, <f-args>)

command -bang -nargs=+ -complete=file TermNewCwd
\	call termnew#open_cwd(<bang>1, <q-mods>, <f-args>)
