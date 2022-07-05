# Neovim Lua Based configuration Files

This directory contains the infrastructure I use to manage
my Neovim (0.7.2+) configuration.

## Guidelines

* written in a straight forward idiomatic Lua style
  * reverse engineerable
  * not written in some personal DSL
  * constucts defined near where they are used
  * designed to "fail gracefully" if not all infrastructure in place
    * error messages pointing to what went wrong
    * neovim left in a functional enough state to fix the problem
* cutting edge
  * always a "work in progress"
  * may require latest stable release of Neovim
  * may use plug-ins which potentially may incorporate breaking changes
  * try to base configs on documentation
  * may contain "monkey-see-monkey-do" from other people's repos

