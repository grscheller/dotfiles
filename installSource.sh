# This sourced script is designed to be compatible with the
# grscheller/dotfiles GitHub repo and all of its submodule repos.
#
# shellcheck shell=sh
#
if [ -z "$scriptName" ]
then
   printf 'Check configuration, scriptName not defined'
   return 1
fi

usage="Usage: $scriptName [-s {install|repo|target}]"

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
            return 1
            ;;
      esac
   done
   shift $((OPTIND - 1))

   if [ $# -gt 0 ]
   then
      printf '\nError: %s takes no arguments\n' "$scriptName"
      printf '\n%s\n' "$usage"
      return 1
   fi

   if [ "$switch" != install ] && [ "$switch" != repo ] && [ "$switch" != target ]
   then
      printf '\nError: %s -s given an invalid option argument\n' "$scriptName"
      printf '\n%s\n' "$usage"
      return 1
   fi

   ## Functions

   # Function to ensure directory exists
   ensure_dir () {
      targetDir="$1"
      srcDir="$2"
      if [ ! -d "$targetDir" ]
      then
         case "$switch" in
            install)
               mkdir -p "$targetDir" ||
                  printf "\\nWarning: Failed to create '%s' directory\\n" "$targetDir"
               ;;
            target)
               printf "\\ntarget directory '%s' needs to be created\\n" "$targetDir"
               ;;
         esac
      fi
      if [ -n "$srcDir" ] && [ ! -d "$srcDir" ]
      then
         printf "\\nsource directory '%s' does not exist\\n" "$srcDir"
      fi
      targetDir=
      srcDir=
   }

   # Function to check or remove files or directories
   remove_item () {
      item="$1"
      flag="$2"
      if test -e "$item"
      then
         case "$switch" in
            install)
               rm -rf "$item"
               test -e "$item" && {
                  case "$flag" in
                     target)
                        printf "\\nWarning: Failed to remove '%s' from target\\n" "$item"
                        ;;
                     repo)
                        printf "\\nWarning: Failed to remove '%s' from repo\\n" "$item"
                        ;;
                  esac
               }
               ;;
            repo)
               printf "\\n'%s' is still in the target\\n" "$item"
               ;;
            target)
               printf "\\n'%s' needs removing from the target\\n" "$item"
               ;;
         esac
      fi
   }

   # Function to install files
   install_file () {
      install_dir="$1"
      file_path="$2"
      src_dir="$3"
      file_perm="$4"
      switch="$5"
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
                  printf "\\nWarning: Failed to set permissions on '%s' to '%s'\\n" "$trgt" "$file_perm"
               }
            else
               printf "\\nWarning: Failed to install '%s'\\n" "$trgt"
            fi
            ;;
         repo)
            # Compare config (this script) with dotfile repo working directory
            test -e "$src" || {
               printf "\\nSource: '%s' not in git working directory.\\n" "$src_abs"
            }
            ;;
         target)
            # Compare config (this script) with install target
            if [ ! -e "$src" ] && [ ! -e "$trgt" ]
            then
               printf "\\nBoth Target: '%s'\n and Source: '%s' don't exist.\\n" "$trgt" "$src_abs"
            elif [ ! -e "$trgt" ]
            then
               printf "\\nTarget: '%s' doesn't exist.\\n" "$trgt"
            elif [ ! -e "$src" ]
            then
               printf "\\nSource: '%s' doesn't exist.\\n" "$src_abs"
            else
               diff "$src" "$trgt" > /dev/null || {
                  printf "\\nTarget: '%s' differs from\\nSource: '%s'.\\n" "$trgt" "$src_abs"
               }
            fi
            ;;
      esac
   }
fi
