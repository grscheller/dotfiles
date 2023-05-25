# This sourced script is designed to be compatible with the
# grscheller/dotfiles GitHub repo and all of its submodule repos.
#
# shellcheck shell=sh
# shellcheck disable=SC3043
#   SC3043: allow use of non-POSIX keyword "local"
#
if [ -n "$MyRepoName" ]
then
   repoName="$MyRepoName"
   unset MyRepoName
else
   printf 'Check configuration, MyRepoName not defined'
   exit 1
fi

if [ -n "$MyScriptName" ]
then
   scriptName="$MyScriptName"
   unset MyScriptName
else
   printf 'Check configuration, MyScriptName not defined'
   exit 1
fi

usage="Usage: $scriptName [-s {install|repo|check}]"

if [ -z "$switch" ]
then
   ## Parse cmdline arguments if $switch not set.
   #    last -s option wins,
   #    default is to install
   switch=install
   while getopts s: opt 2>&1
   do
      case "$opt" in
         s)
            switch="$OPTARG"
            ;;
         \?)
            printf '\n%s\n' "$usage"
            exit 1
            ;;
      esac
   done
   shift $((OPTIND - 1))

   if [ $# -gt 0 ]
   then
      printf '\nError: %s takes no arguments\n' "$scriptName"
      printf '\n%s\n' "$usage"
      exit 1
   fi

   if [ "$switch" != install ] && [ "$switch" != repo ] && [ "$switch" != check ]
   then
      printf '\nError: %s -s given an invalid option argument\n\n%s\n' "$scriptName" "$usage"
      exit 1
   fi

   ## Functions

   # Check or ensure directory exists
   ensure_dir () {
      local targetDir srcDir
      targetDir="$1"
      srcDir="$2"
      if [ ! -d "$targetDir" ]
      then
         case "$switch" in
            install)
               mkdir -p "$targetDir" ||
                  printf '\n%s: failed to create "%s" directory\n' "$scriptName" "$targetDir"
               ;;
            check)
               printf '\n%s: directory "%s" needs to be created\n' "$scriptName" "$targetDir"
               ;;
         esac
      fi
      if [ -n "$srcDir" ] && [ ! -d "$srcDir" ]
      then
         printf '\n%s: source directory "%s" does not exist\n' "$scriptName" "$srcDir"
      fi
   }

   # Check or remove a file or a directory
   remove_item () {
      local item
      item="$1"
      if test -e "$item"
      then
         case "$switch" in
            install)
               rm -rf "$item"
               test -e "$item" && {
                  printf '\n%s: Failed to remove "%s" from target\n' "$scriptName" "$item"
               }
               ;;
            repo)
               printf '\n%s: "%s" still installed in target\n' "$scriptName" "$item"
               ;;
            check)
               printf '\n%s: "%s" needs removing from target\n' "$scriptName" "$item"
               ;;
         esac
      fi
   }

   # Install a file
   install_file () {
      local install_dir file_path src_dir file_perm src src_abs trgt trgt_dir
      install_dir="$1"
      file_path="$2"
      src_dir="$3"
      file_perm="$4"
      src="$src_dir/$file_path"
      src_abs="$DOTFILE_GIT_REPO${src#.}"
      trgt="$install_dir/$file_path"
      trgt_dir="${trgt%/*}"

      # Make sure target and source directory exists
      ensure_dir "$trgt_dir" "$src_dir"

      case "$switch" in
         install)
            # Install the file
            if cp "$src" "$trgt"
            then
               chmod --quiet "$file_perm" "$trgt" || {
                  printf '\n%s: failed to set permissions on '%s' to '%s'\n' "$scriptName" "$trgt" "$file_perm"
               }
            else
               printf '\n%s: failed to install "%s"\n' "$scriptName" "$trgt"
            fi
            ;;
         repo)
            # Compare config (this script) with dotfile repo working directory
            test -e "$src" || {
               printf '\n%s: "%s" not in git working directory.\n' "$scriptName" "$src_abs"
            }
            ;;
         check)
            # Compare config (this script) with install target
            if [ ! -e "$src" ] && [ ! -e "$trgt" ]
            then
               printf '\n%s: both target: "%s"\n and source: "%s" do not exist.\n' "$scriptName" "$trgt" "$src_abs"
            elif [ ! -e "$trgt" ]
            then
               printf '\n%s: target "%s" does not exist\n' "$scriptName" "$trgt"
            elif [ ! -e "$src" ]
            then
               printf '\n%s: source "%s" does not exist\n' "$scriptName" "$src_abs"
            else
               diff "$src" "$trgt" > /dev/null || {
                  printf '\n%s: "%s" differs from "%s"\n' "$scriptName" "$trgt" "$src_abs"
               }
            fi
            ;;
      esac
   }

   git_status () {
      local gs
      gs="$(git status --porcelain)"
      test -n "$gs" && printf '\ngit status %s:\n%s\n' "$repoName" "$gs"
   }

   # Install files - convenience function (keep loops out of config files)
   install_files () {
      local install_dir file files src_dir file_perm
      install_dir="$1"
      files="$2"
      src_dir="$3"
      file_perm="$4"
      test -z "$files" && return
      for file in $files
      do
         install_file "$install_dir" "$file" "$src_dir" "$file_perm"
      done
   }

   # Check or remove files or directories - convenience function
   remove_items () {
      local item items
      test ${#} -gt 1 && {
         printf '\n%s: Error - remove_items only takes one argument\n' "$scriptName" 
      }
      items="$1"
      test -z "$items" && return
      for item in $items
      do
         remove_item "$item"
      done
   }

   # Check or remove files or directories - convenience function
   ensure_dirs () {
      local dirs dir
      test ${#} -gt 1 && {
         printf '\n%s: Error - ensure_dirs only takes one argument\n' "$scriptName" 
      }
      dirs="$1"
      test -z "$dirs" && return
      for dir in $dirs
      do
         ensure_dir "$dir"
      done
   }

fi
