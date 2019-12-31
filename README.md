# TermNew: open Neovim terminal in a new window or tab

Using Neovim's built-in command `:terminal` it's impossible to open a terminal
in a new window or tab. The only way to do that is to use forms that are rather
cumbersome to type, for example: `split term://$SHELL`.

This plugin provides a simple command that normally opens a terminal in a split
window, accepting standard modifiers that change how the window is opened.


## Usage

```
:TermNew [COMMANDLINE]...
```

By itself, `:TermNew` will open a split window with the command in `$SHELL`
(if set) or `&shell`.

To open a different program in the terminal, pass it as an argument to
`:TermNew`. All arguments are passed to the `termopen()` call. For example,
`:TermNew zsh` will open a terminal with `zsh` shell.

```
:TermNewShellInDir [DIRECTORY]
```

Opens a new shell (the same way as `:TermNew` without arguments) in working
directory given as argument.
