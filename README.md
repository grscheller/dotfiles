# dotfiles

## Repo's purposes

1. To maintain my own configuration files
2. To preserve this information for myself
3. To help quickly configure new systems for myself
4. To provide others useful examples for their own configuration files
5. To allow others to use as a starting point for their own version

## Contents

Infrastructure used to manage my Fish/Bash/Sway
shell and desktop software development environments.

* Neovim configurations
  * Neovim configs are Lua based and use LSP, BSP, DAP heavily
  * Tested on Neovim version 0.7.2+
* Login shell fish, bash configured as backup
* Alacritty, SSH and global GIT configurations
* Language configurations (work in progress)
  * C, C++ and Zig Languages
  * CSS
  * Go
  * Haskell
  * JSON
  * Lua
  * Markdown
  * Python with pyenv hooks
  * Rust
  * Scala
  * Typescript
  * YAML
* System configurations for my Systemd/Wayland Arch Linux systems

## Installation Scripts

Install into home directory

* [dotfilesInstall](dotfilesInstall)
  * From cloned repo run:
    ```
       $ ./dotfilesInstall
    ```

Install into system directories:

* [systemfilesInstall](systemfilesInstall)
  * From cloned repo run
    ```
       $ sudo ./systemfilesInstall
    ```
  * for my own Arch Linux systems ONLY!

## License Information

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <a rel="dct:publisher"
     href="https://github.com/grscheller">
    <span property="dct:title">Geoffrey R. Scheller</span></a>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">dotfiles</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="US" about="https://github.com/grscheller">
  United States</span>.
</p>
