## This directory DOES NOT GET INSTALLED ANYWHERE!!!

It contains ideas and example code that I may or may not what to follow
through with.

### Ditch neovim/nvim-lspconfig

I noticed the nvim LSP client not finding Mason installed LSP servers
when configured via lspconfig.  An easy workaround would be to set $PATH
in the environment to end with `~/.local/share/nvim/mason/bin` and be
done with it.

This got me thinking, do I really need lsconfig?  If I want to spend the
rest of my life language hopping, the answer maybe is yes.  But, I don't
like black boxes, nor IDE's that hide the build system from the user.
I do want to master a few good languages and understand their tooling
well.

There seems to be a trend to create plugins which couple mason and
lspconfig.  But, lspconfig gives only "best effort" minimal
configurations.  Also, nvim-lspconfig is maintained by core Neovim.  So,
I expect more functionality from lspconfig will continue being migrated
into Neovim core.

Probably will want to continue using Mason as a 3rd party package
manager, configuring the internal LSP client directly for a few select
languages, and using lspconfig to configure the rest.

* [client.lua](lsp/vonheikemen/lsp.lua)
* [tsserver.lua](lsp/vonheikemen/configs/tsserver.lua)
