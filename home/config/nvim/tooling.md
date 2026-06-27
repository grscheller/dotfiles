# External tooling

## Mason Installation

### actionlint - Linter

Static checker for GitHub Actions workflow files.

- Languages: YAML
- Implementation: Go

### ast-grep - LSP, Linter, Formatter

A CLI tool for code structural search, linting and rewriting.

Note that `ast-grep lsp` only works in projects that have an
sgconfig.y[a]ml in their root directory.

- Languages: C, C++, Rust, Go, Java, Python, C#, JavaScript
- Languages: JSX, TypeScript, HTML, CSS, Kotlin, Dart, Lua
- Implementation: Rust

**Important**: The `ast-grep lsp` command does not add general
language intelligence (no completions, no go-to-definition, no symbol
resolution). It is exclusively rule-driven. Every diagnostic, code
action, and hover note it produces is a direct consequence of rules you
define in YAML. This makes it much closer to a configurable linter/fixer
that happens to speak LSP.

**Tip**: To bootstrap a new project, from the root directory

```console
    $ ast-grep new
    $ ast-grep new rule
```
The first command creates

### bacon - Linter

Bacon is a background rust code checker.

- Languages: Rust
- Implementation: Rust

### bacon-ls - LSP

Rust diagnostic provider based on Bacon. Leverages rust-analyzer.

- Languages: Rust
- Implementation: Rust

### bash-language-server - LSP

A language server for Bash and other POSIX shells.

- Languages - Bash, Csh, Ksh, Sh, Zsh
- Implementation: Node

### cbfmt - Formatter

A tool to format codeblocks inside markdown, org, and reStructuredText
documents. It iterates over all codeblocks, and formats them with the
tools specified for the language of the block.

- Languages: Markdown, reStructuredText
- Implementation: Rust

### checkmake - Linter

A linter for Makefiles. It scans Makefiles for potential issues based
on configurable rules.

- Languages: Makefiles
- Implementation: Go

### clangd - LSP

Part of the LLVM project.

- Languages: C, C++
- Implementation: C++

### clj-kondo - Linter gh-pages

Clj-kondo performs static analysis on Clojure, ClojureScript and EDN,
without the need of a running REPL. It informs you about potential
errors while you are typing.

- Languages: Clojure, ClojureScript
- Implementation: Clojure

### cljfmt - Formatter

A tool for detecting and fixing formatting errors in Clojure code. Its
defaults are based on the Clojure Style Guide, but it also has many
customization options to suit a particular project or team.

It is not the goal of the project to provide a one-to-one mapping
between a Clojure syntax tree and formatted text; rather the intent
is to correct formatting errors with minimal changes to the existing
structure of the text.

- Languages: Clojure, ClojureScript
- Implementation: Clojure

### clojure-lsp - LSP

A Language Server for Clojure taking a Cursive-like approach to
statically analyzing code.

- languages: Clojure, ClojureScript
- Implementation: Clojure

### fish-lsp - LSP

LSP implementation for the fish shell language

- Languages: Fish
- Implementation: Node

### fourmolu - Formatter

A fork of Ormolu that uses four space indentation and allows arbitrary
configuration.

- Languages: Haskell
- Implementation: Haskell

### haskell-debug-adapter - DAP

A debug adapter for Haskell debugging system.

- Languages: Haskell
- Implementation: Haskell

### haskell-language-server

Official Haskell Language Server implementation.

- Languages: Haskell
- Implementation: Haskell

### jls - LSP, DAP

Java language server using Java compiler API, optimized for Neovim.

- Languages: Java
- Implementation: Java

### lua-language-server - LSP

A language server that offers Lua language support - programmed in Lua.

- Languages: Lua
- Implementation: Lua

### luau-lsp - LSP

An implementation of a language server for the Luau programming
language (Johnny Morganz).

- Languages: Luau
- Implementation: C++

### oxlint - LSP, Linter

High-performance linter for JavaScript and TypeScript written in Rust.

- Languages: JS, TS
- Implementation: Rust

### rumdl - LSP, LINTER, Formatter

Fast Markdown linter and formatter.

- Languages: Markdown
- Implementation: Rust

### rust-analyzer - LSP

Rust analyzer is an implementation of the Language Server Protocol for
the Rust programming language.

- Languages: Rust
- Implementation: Rust

### stylua - LSP, Formatter

An opinionated Lua code formatter (Johnny Morganz).
\`

- Languages: Lua, Luau
- Implementation: Rust

### superhtml - LSP, Formatter

HTML language server & templating language library

- Languages: HTML, SuperHTML
- Implementation: Zig

### systemd-lsp - LSP

Language server implementation for systemd unit files.

- Languages: systemd files
- Implementation: Rust

### tombi - LSP, Linter, Formatter

Feature-Rich TOML Toolkit.

- Languages: TOML
- Implementation: Rust

### zls - LSP

Zig LSP implementation + Zig Language Server.

- Languages Zig
- Implementation: Zig

## Python Environment Installation

### beautysh - Formatter

A Bash beautifier for the masses.

- Languages - Bash, Csh, Ksh, Sh, Zsh
- Implementation: Python

### black - Formatter

Black, the uncompromising Python code formatter.

- Languages: Python
- Implementation: Python

### clang-format - Formatter

- Languages: C, C#, C++, JSON, Java, JavaScript
- Implementation: Python

### darker - Formatter

Apply black reformatting to Python files only in regions changed
since a given commit.

- Languages: Python
- Implementation: Python

### esbonio - LSP

A Language Server that aims to make it easier to work with
reStructuredText tools such as Sphinx

- Languages: reStructuredText, Sphinx
- Implementation: Python

### gitlint - Linter

Git commit message linter. It checks your commit messages for style.

- Languages: Git commit messages
- Implementation: Python

### mypy - Linter

Mypy is a static type checker for Python.

- Languages: Python
- Implementation: Python

### python-lsp-server - LSP

Fork of the python-language-server project, maintained by the Spyder IDE team and the community.

- Languages Python
- Implementation: Python

### ruff - LSP, Linter, Formatter

An extremely fast Python linter and code formatter, written in Rust.

- Languages: Python
- Implementation: Python, Rust

### tclint - LSP, Linter, Formatter

Modern dev tools for Tcl, includes a linter, formatter, and editor
integration.

- Languages: Tcl
- Implementation: Python

### zuban - LSP, Linter

Zuban is a high-performant Mypy-compatible LSP and type checker
built in Rust.

- Languages: Python
- Implementation: Rust
