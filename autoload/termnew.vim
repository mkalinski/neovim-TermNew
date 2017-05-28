" Copyright 2017 Michał Kaliński

let s:NEW_TERM_OPT_CMD = 'termcmd'
let s:NEW_TERM_OPT_SPL = 'splitcmd'


function termnew#command_termnew(...) abort
	" Separate the option-arg from the rest.
	let rest_index = a:0 > 0 && a:1 =~ '^-' ? 1 : 0
	let term_cmd = a:000[rest_index:]

	let new_cmd = 'new'
	" Process the options if present. Skip the initial dash.
	if rest_index
		let op = termnew#OptParser#new()
		try
			call op.parse(strpart(a:1, 1))
		catch /^termnew#OptParser:\%(BadCombination\|UnknownOption\)/
			echoerr v:exception
			return
		endtry
		let new_cmd = op.get_modifiers_string() . new_cmd
	endif

	call termnew#new_terminal({
	\	s:NEW_TERM_OPT_CMD: empty(term_cmd) ? s:default_term_cmd() : term_cmd,
	\	s:NEW_TERM_OPT_SPL: new_cmd,
	\})
endfunction


function termnew#new_terminal(...) abort
	let opts = a:0 == 0 ? {} : a:1
	let cmd = has_key(opts, s:NEW_TERM_OPT_CMD) ?
	\	opts[s:NEW_TERM_OPT_CMD] : s:default_term_cmd()
	let splitcmd = get(opts, s:NEW_TERM_OPT_SPL, 'new')

	" Execute the command to open the new buffer, call termopen and start
	" insert, to emulate the behaviour of :terminal.
	execute splitcmd
	call termopen(cmd)
	startinsert
endfunction


function s:default_term_cmd() abort
	return [(empty($SHELL) ? &shell : $SHELL)]
endfunction
