" Copyright 2017,2019,2024 Michał Kaliński

function termnew#open(start_insert, mods, ...) abort
	call s:open(a:start_insert, a:mods, '.', a:000)
endfunction

function termnew#open_cwd(start_insert, mods, cwd, ...) abort
	call s:open(a:start_insert, a:mods, a:cwd, a:000)
endfunction

function s:open(start_insert, mods, cwd, cmd) abort
	let l:cmd = empty(a:cmd) ? s:get_shell_cmd() : a:cmd

	execute a:mods 'new'
	call termopen(l:cmd, {'cwd': expand(a:cwd)})

	if a:start_insert
		startinsert
	endif
endfunction

function s:get_shell_cmd() abort
	if !empty(get(g:, 'termnew_shell'))
		if type(g:termnew_shell) == v:t_list
			return g:termnew_shell
		endif

		return [g:termnew_shell]
	endif

	if !empty($SHELL)
		return [$SHELL]
	endif

	return [&shell]
endfunction
