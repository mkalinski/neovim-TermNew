" Copyright 2017 Michał Kaliński

let s:O_VERT = 'v'
let s:O_TAB = 't'

let s:O_LEFT = 'l'
let s:O_RIGHT = 'r'

let s:O_TOP = 'L'
let s:O_BOT = 'R'

let s:O_MAP = {
\	s:O_VERT: '_opt_vert',
\	s:O_TAB: '_opt_tab',
\	s:O_LEFT: '_opt_left',
\	s:O_RIGHT: '_opt_right',
\	s:O_TOP: '_opt_top',
\	s:O_BOT: '_opt_bot',
\}


let s:OptParser = {
\	'_vert': 0,
\	'_tab': 0,
\	'_left': 0,
\	'_right': 0,
\	'_top': 0,
\	'_bot': 0,
\}

function s:OptParser.parse(optstr) abort
	for opt in split(a:optstr, '\zs')
		try
			let fname = s:O_MAP[opt]
		catch /^Vim\%((\a\+)\)\=:E716/
			" Key not in dictionary
			throw 'termnew#OptParser:UnknownOption: ' . opt
		endtry
		call self[fname]()
	endfor
endfunction

function s:OptParser.result() abort
	let mods = []

	if self._tab
		call add(mods, 'tab')
	else
		if self._vert
			call add(mods, 'vertical')
		endif
		if self._left
			call add(mods, 'aboveleft')
		elseif self._right
			call add(mods, 'belowright')
		elseif self._top
			call add(mods, 'topleft')
		elseif self._bot
			call add(mods, 'botright')
		endif
	endif

	return join(mods)
endfunction

function s:OptParser._opt_vert() abort
	if self._tab
		throw s:bad_combination(s:O_VERT, s:O_TAB)
	endif

	let self._vert = 1
endfunction

function s:OptParser._opt_tab() abort
	if self._vert
		throw s:bad_combination(s:O_TAB, s:O_VERT)
	endif
	if self._left
		throw s:bad_combination(s:O_TAB, s:O_LEFT)
	endif
	if self._right
		throw s:bad_combination(s:O_TAB, s:O_RIGHT)
	endif
	if self._top
		throw s:bad_combination(s:O_TAB, s:O_TOP)
	endif
	if self._bot
		throw s:bad_combination(s:O_TAB, s:O_BOT)
	endif

	let self._tab = 1
endfunction

function s:OptParser._opt_left() abort
	if self._right
		throw s:bad_combination(s:O_LEFT, s:O_RIGHT)
	endif
	if self._top
		throw s:bad_combination(s:O_LEFT, s:O_TOP)
	endif
	if self._bot
		throw s:bad_combination(s:O_LEFT, s:O_BOT)
	endif

	let self._left = 1
endfunction

function s:OptParser._opt_right() abort
	if self._left
		throw s:bad_combination(s:O_RIGHT, s:O_LEFT)
	endif
	if self._top
		throw s:bad_combination(s:O_RIGHT, s:O_TOP)
	endif
	if self._bot
		throw s:bad_combination(s:O_RIGHT, s:O_BOT)
	endif

	let self._right = 1
endfunction

function s:OptParser._opt_top() abort
	if self._left
		throw s:bad_combination(s:O_TOP, s:O_LEFT)
	endif
	if self._right
		throw s:bad_combination(s:O_TOP, s:O_RIGHT)
	endif
	if self._bot
		throw s:bad_combination(s:O_TOP, s:O_BOT)
	endif

	let self._top = 1
endfunction

function s:OptParser._opt_bot() abort
	if self._left
		throw s:bad_combination(s:O_BOT, s:O_LEFT)
	endif
	if self._right
		throw s:bad_combination(s:O_BOT, s:O_RIGHT)
	endif
	if self._top
		throw s:bad_combination(s:O_BOT, s:O_TOP)
	endif

	let self._bot = 1
endfunction


function termnew#OptParser#new() abort
	return copy(s:OptParser)
	return new_obj
endfunction


function s:bad_combination(first, other) abort
	return printf(
	\	'termnew#OptParser:BadCombination: ' .
	\	'Option "%s" cannot be set together with "%s"',
	\	a:first,
	\	a:other,
	\)
endfunction
