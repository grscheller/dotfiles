# dotfiles

Configuration files for my Arch Linux workstations & laptops.

## IMPORTANT NOTICE:
On 2023 May 09, I screwed up something and could not push main up to
GitHub.  I created a new branch called master and pushed it to GitHub.
I changed my GitHub default branch to master and deleted both the main
and tmpWork branches locally and on GitHub.

If you have cloned my repo, you will need to re-clone it, or try to
fix your local repo as follows:

``` bash
   $ git branch -m main master
   $ git fetch origin
   $ git branch -u origin/master master
   branch 'master' set up to track 'origin/master'.
   $ git remote set-head origin -a
   origin/HEAD set to master
```

## Scripts

* [dfInstall](dfInstall)
  * Installs "dotfiles" to "$HOME"
  * Usage: `./dfInstall [-s {install|target|repo}]`
* [sudo sfInstall](sfInstall)
  * Installs "root/" files to "/"
  * Usage: `sudo ./sfInstall`

## Public Domain Declaration

<p xmlns:dct="http://purl.org/dc/terms/"
   xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
     <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png"
          style="border-style: none;"
          alt="CC0"></a>

  To the extent possible under law,
  [Geoffrey R. Scheller](https://github.com/grscheller)
  has waived all copyright and related or neighboring rights
  to [dotfiles](https://github.com/grscheller/dotfiles).
  This work is published from the United States of America.
</p>

See [LICENSE](LICENSE) for details.
