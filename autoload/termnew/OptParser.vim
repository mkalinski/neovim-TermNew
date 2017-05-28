" Copyright 2017 Michał Kaliński

" Main options.
let s:OPT_VERT = 'v'
let s:OPT_TAB = 't'
let s:OPT_LEFT = 'l'
let s:OPT_RIGHT = 'r'
let s:OPT_TOP = 'L'
let s:OPT_BOT = 'R'

" Symbolic modifiers for tab option.
let s:TAB_NEXT = '+'
let s:TAB_PREV = '-'
let s:TAB_LAST = '$'

" Maps options to methods who handle them.
let s:DISPATCH = {
\	s:OPT_VERT: '_set_opt',
\	s:OPT_TAB: '_set_opt',
\	s:OPT_LEFT: '_set_opt',
\	s:OPT_RIGHT: '_set_opt',
\	s:OPT_TOP: '_set_opt',
\	s:OPT_BOT: '_set_opt',
\	s:TAB_NEXT: '_mod_tab',
\	s:TAB_PREV: '_mod_tab',
\	s:TAB_LAST: '_mod_tab',
\}

let s:CHECKS = {
\	s:OPT_VERT: '_check_vert',
\	s:OPT_TAB: '_check_tab',
\	s:OPT_LEFT: '_check_left',
\	s:OPT_RIGHT: '_check_right',
\	s:OPT_TOP: '_check_top',
\	s:OPT_BOT: '_check_bot',
\}

let s:NUM_PAT = '^\d\+$'


function s:bad_combination(first, other) abort
	return printf(
	\	'termnew#OptParser:BadCombination: ' .
	\	'Option "%s" cannot be set together with "%s"',
	\	a:first,
	\	a:other,
	\)
endfunction


let s:OptParser = {
\	'_mod': '',
\	'_opts': {
\		s:OPT_VERT: 0,
\		s:OPT_TAB: 0,
\		s:OPT_LEFT: 0,
\		s:OPT_RIGHT: 0,
\		s:OPT_TOP: 0,
\		s:OPT_BOT: 0,
\	},
\	'_num_allowed': 1,
\}

function termnew#OptParser#new() abort
	return deepcopy(s:OptParser)
endfunction

function s:OptParser.parse(optstring) abort
	for char in split(a:optstring, '\zs')
		let numalsave = self._num_allowed

		if char =~# s:NUM_PAT
			call self._append_number(char)
			continue
		" If any non-number appears and the mod is not empty, disallow
		" further numbers.
		elseif !empty(self._mod)
			let self._num_allowed = 0
		endif

		try
			let disp = s:DISPATCH[char]
		catch /^Vim\%((\a\+)\)\=:E716/
			" Key not in dictionary
			" Rollback _num_allowed just in case
			let self._num_allowed = numalsave
			throw 'termnew#OptParser:UnknownOption: ' . char
		endtry

		call self[disp](char)
	endfor
endfunction

function s:OptParser.get_modifiers_string() abort
	let mods = []

	if self._opts[s:OPT_TAB]
		call add(mods, '%stab ')
	else
		if self._opts[s:OPT_VERT]
			call add(mods, 'vertical')
		endif
		if self._opts[s:OPT_LEFT]
			call add(mods, 'aboveleft')
		elseif self._opts[s:OPT_RIGHT]
			call add(mods, 'belowright')
		elseif self._opts[s:OPT_TOP]
			call add(mods, 'topleft')
		elseif self._opts[s:OPT_BOT]
			call add(mods, 'botright')
		endif
		call add(mods, ' %s')
	endif

	return printf(join(mods), self._mod)
endfunction

function s:OptParser._set_opt(optval) abort
	" Perform the check on previously set options.
	call self[s:CHECKS[a:optval]]()
	let self._opts[a:optval] = 1
endfunction

function s:OptParser._append_number(num) abort
	if !self._num_allowed
		throw printf(
		\	'termnew#OptParser:BadCombination: Number %d appeared after ' .
		\	'a modifier sequence "%s" was complete; only one modifier ' .
		\	'sequence is allowed',
		\	a:num,
		\	self._mod,
		\)
	endif
	if !empty(self._mod) && self._mod !~# s:NUM_PAT
		throw printf(
		\	'termnew#OptParser:BadCombination: To append number %d ' .
		\	'no other non-numeric option is allowed, but got "%s" earlier',
		\	a:num,
		\	self._mod,
		\)
	endif
	let self._mod .= a:num
endfunction

function s:OptParser._mod_tab(modval) abort
	" Tab must be set for this function to act properly.
	if !self._opts[s:OPT_TAB]
		throw printf(
		\	'termnew#OptParser:BadCombination: Option -%s must be passed ' .
		\	'before tab modifier "%s"',
		\	s:OPT_TAB,
		\	a:modval,
		\)
	endif
	" If a symbolic modifier was passed, then nothing else could have been
	" passed.
	if !empty(self._mod)
		throw printf(
		\	'termnew#OptParser:BadCombination: Cannot pass modifier ' .
		\	'"%s" with previous modifier "%s"',
		\	a:modval,
		\	self._mod,
		\)
	endif
	let self._mod = a:modval
endfunction

function s:OptParser._check_vert() abort
	if self._opts[s:OPT_TAB]
		throw s:bad_combination(s:OPT_VERT, s:OPT_TAB)
	endif
endfunction

function s:OptParser._check_tab() abort
	for [optname, optvalue] in items(self._opts)
		if optname !=# s:OPT_TAB && optvalue
			throw s:bad_combination(s:OPT_TAB, optname)
		endif
	endfor
endfunction

" The rest of the check functions share one template
function s:OptParser._check_winmod(the_opt) abort
	for [optname, optvalue] in items(self._opts)
		if optname !=# a:the_opt && optname !=# s:OPT_VERT && optvalue
			throw s:bad_combination(a:the_opt, optname)
		endif
	endfor
endfunction

function s:OptParser._check_left() abort
	call self._check_winmod(s:OPT_LEFT)
endfunction

function s:OptParser._check_right() abort
	call self._check_winmod(s:OPT_RIGHT)
endfunction

function s:OptParser._check_top() abort
	call self._check_winmod(s:OPT_TOP)
endfunction

function s:OptParser._check_bot() abort
	call self._check_winmod(s:OPT_BOT)
endfunction
