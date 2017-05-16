# TermNew: open Neovim terminal in a new window or tab

Using Neovim's built-in command `:terminal` it's impossible to open a terminal
in a new window or tab. The only way to do that is to use forms that are rather
cumbersome to type, for example: `split term://$SHELL`.

This plugin provides a simple command that normally opens a terminal in a split
window, but also accepts options that act like command modifiers that control
where the window is opened.


## Usage

```
:TermNew [OPTIONS] [COMMANDLINE]...
```

By itself, `:TermNew` will open a split window with the command in `$SHELL`
(if set) or `&shell`.

To open a different program in the terminal, pass it as an argument to
`:TermNew`. All arguments are passed to the `termopen()` call. For example,
`:TermNew zsh` will open a terminal with `zsh` shell.

If the first argument starts with a dash, it is taken as the option string that
determines where the terminal is open. The option string is not passed to
`termopen()`.

| Option | Command modifier |
| ------ | ---------------- |
| `v`    | `vertical`       |
| `t`    | `tab`            |
| `l`    | `aboveleft`      |
| `r`    | `belowright`     |
| `L`    | `topleft`        |
| `R`    | `botright`       |

Only one of `l`, `L`, `r`, `R` may be passed, and `t` can appear only by
itself.

For example, `:TermNew -vL python` will open the Python interpreter in a
vertical split that will be put at the leftmost position, and
`:TermNew -t bash` will open the Bash shell in a new tab.
