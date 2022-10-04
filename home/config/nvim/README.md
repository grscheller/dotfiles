# Neovim Lua Based Configuration Files

This directory contains the infrastructure I use to manage
my Neovim (0.8.0+) configuration.

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
  * uses plug-ins which potentially may incorporate breaking changes
  * try to base configs on documentation
  * still may contain "monkey-see-monkey-do" when documentation is lacking

