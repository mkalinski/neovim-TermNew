" Copyright 2017,2019 Michał Kaliński

function termnew#split_args(...) abort
	" Separate the option-arg from the rest.
	if a:0 > 0 && strcharpart(a:1, 0, 1) ==# '-'
		let opts = strcharpart(a:1, 1)
		let rest = a:000[1:]
	else
		let opts = ''
		let rest = a:000
	endif
	return {'options': opts, 'rest': rest}
endfunction

function termnew#open_command(args) abort
	call s:open_window(a:args.options)
	call termopen(!empty(a:args.rest) ? a:args.rest : s:default_shell())
	startinsert
endfunction

function termnew#open_shell_in_wd(args) abort
	call s:open_window(a:args.options)
	call termopen(s:default_shell(), {'cwd': expand(join(a:args.rest))})
	startinsert
endfunction

function termnew#guard_exceptions(func) abort
	try
		call a:func()
	catch /^termnew#OptParser:\%(BadCombination\|UnknownOption\)/
		echoerr 'TermNew options error:'
		\	strpart(v:exception, stridx(v:exception, ':') + 1)
	endtry
endfunction

function s:open_window(options_string) abort
	execute s:get_window_open_modifiers(a:options_string) 'new'
endfunction

function s:get_window_open_modifiers(options_string) abort
	if empty(a:options_string)
		return ''
	endif
	let options_parser = termnew#OptParser#new()
	call options_parser.parse(a:options_string)
	return options_parser.get_modifiers_string()
endfunction

function s:default_shell() abort
	return [(empty($SHELL) ? &shell : $SHELL)]
endfunction
