# fish

Fish Shell configuration files.

* very opinionated
* permanent configuration flows from configuration files
  * manual configurations can be used for temporary changes
  * manual changes can be lost on configuration file updates
  * the `re` (redo environment) shell function may be necessary for some universals and abbreviations to take effect

Can be used either as a standalone repo, or as a git submodule for
the `grscheller/dotfiles` GitHub repo.

## Installation Location

To install these files to `$XDG_CONFIG_HOME/fish` from a standalone
alone `grscheller/fish` repo:

```
    $ ./fishInstall [-s {install|check|repo}]
```

If `grscheller/fish` is a submodule of `grscheller/dotfiles`, do not run
it directly from the submodule.  It is designed to be called from
a subshell of `dfInstall`.

## Public Domain Declaration

To the extent possible under law,
[Geoffrey R. Scheller](https://github.com/grscheller)
has waived all copyright and related or neighboring rights to
[grscheller/fish](https://github.com/grscheller/fish).
This work is published from the United States of America.

See [LICENSE](LICENSE) for details.
