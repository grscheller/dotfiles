# Neovim Lua Based Configuration Files

This directory contains the infrastructure I use to manage
my Neovim (0.8.0+) configuration.

## Guidelines

* Written in a straight forward idiomatic Lua style
  * Reverse engineerable
  * Not written in some personal DSL
  * Constucts defined near where they are used
  * Designed to "fail gracefully" if not all infrastructure in place
    * Error messages pointing to what went wrong
    * Neovim left in a functional enough state to fix the problem
* Cutting edge
  * Always a "work in progress"
  * May require latest stable release of Neovim
  * Try to base this configurations on documentation
  * May still contain "monkey-see-monkey-do" when documentation is lacking

