" Copyright 2017 Michał Kaliński

let s:NEW_TERM_OPT_CMD = 'termcmd'
let s:NEW_TERM_OPT_SPL = 'splitcmd'


function termnew#do_command(count, ...) abort
	" Separate the option-arg from the rest.
	let rest_index = a:0 > 0 && a:1 =~ '^-' ? 1 : 0
	let term_cmd = a:000[rest_index:]

	let new_cmd = (a:count > 0 ? a:count : '') . 'new'
	" Process the options if present. Skip the initial dash.
	if rest_index
		let op = termnew#OptParser#new()
		try
			call op.parse(strpart(a:1, 1))
		catch /^termnew#OptParser:\%(BadCombination\|UnknownOption\)/
			echoerr v:exception
			return
		endtry
		let new_cmd = printf('%s %s', op.result(), new_cmd)
	endif

	call termnew#new_term({
	\	s:NEW_TERM_OPT_CMD: empty(term_cmd) ? s:default_term_cmd() : term_cmd,
	\	s:NEW_TERM_OPT_SPL: new_cmd,
	\})
endfunction


function termnew#new_term(...) abort
	let opts = a:0 == 0 ? {} : a:1
	let cmd = has_key(opts, s:NEW_TERM_OPT_CMD) ?
	\	opts[s:NEW_TERM_OPT_CMD] : s:default_term_cmd()
	let splitcmd = has_key(opts, s:NEW_TERM_OPT_SPL) ?
	\	opts[s:NEW_TERM_OPT_SPL] : 'new'

	" Execute the command to open the new buffer, call termopen and start
	" insert, to emulate the behaviour of :terminal.
	execute splitcmd
	call termopen(cmd)
	startinsert
endfunction


function s:default_term_cmd() abort
	return [(empty($SHELL) ? &shell : $SHELL)]
endfunction
