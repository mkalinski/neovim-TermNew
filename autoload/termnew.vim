" Copyright 2017,2019 Michał Kaliński

function termnew#open_command(mods, ...) abort
	execute a:mods 'new'
	call termopen(a:0 ? a:000 : s:default_shell())
	startinsert
endfunction

function termnew#open_shell_in_wd(mods, dir) abort
	execute a:mods 'new'
	call termopen(s:default_shell(), {'cwd': expand(a:dir)})
	startinsert
endfunction

function s:default_shell() abort
	return [(empty($SHELL) ? &shell : $SHELL)]
endfunction
