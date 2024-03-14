# home

Bash and other cmdline related configuration files not part of the
$XDG_CONFIG_HOME infrastructure.

* bash (startup files)
* ~/bin scripts for various scipting languages
* ssh, bloop (Scala), Cabal (Haskell)
* create directories important to my work flow
* remove items

Can be used either as a standalone repo, or as a git submodule for
the `grscheller/dotfiles` GitHub repo.

## Installation Location

To install these files to your `$HOME` directory from a standalone
alone `grscheller/home` repo:

```
   $ ./homeInstall [-s {install|switch|repo}]
```

If `grscheller/home` is a submodule of `grscheller/dotfiles`, do not run
it directly from the submodule.  It is designed to be called from
a subshell of `dfInstall`.

## Public Domain Declaration

To the extent possible under law,
[Geoffrey R. Scheller](https://github.com/grscheller)
has waived all copyright and related or neighboring rights to
[grscheller/home](https://github.com/grscheller/home).
This work is published from the United States of America.

See [LICENSE](LICENSE) for details.
