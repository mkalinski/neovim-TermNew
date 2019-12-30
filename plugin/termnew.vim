" Copyright 2017,2019 Michał Kaliński

if get(g:, 'loaded_TermNew', 0)
	finish
endif
let loaded_TermNew = 1

command! -nargs=* -complete=shellcmd TermNew
\	call termnew#guard_exceptions({->
\		termnew#open_command(termnew#split_args(<f-args>))
\	})

command! -nargs=* -complete=file TermNewShellInDir
\	call termnew#guard_exceptions({->
\		termnew#open_shell_in_wd(termnew#split_args(<f-args>))
\	})
