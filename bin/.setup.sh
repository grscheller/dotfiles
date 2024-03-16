# grscheller/dotfiles setup script
#
# Parse imput arguments and setup infrasture.
#
# shellcheck shell=sh
# shellcheck disable=SC3043
#   SC3043: allow use of non-POSIX keyword "local"
#
if [ -z "$scriptName" ]
then
   printf 'Check configuration, scriptName is not set.\n\n'
   exit 1
fi

if [ -z "$gitRepo" ]
then
   printf 'Check configuration, gitRepo is not set.\n\n'
   exit 1
fi

usage="Usage: $scriptName [-s {install|check}]"

if [ -z "$switch" ]
then
   umask 0022
   XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"

   ## Parse cmdline arguments if $switch not set - default is to install
   switch=install
   while getopts s: opt 2>&1
   do
      case "$opt" in
         s)
            switch="$OPTARG"
            ;;
         \?)
            printf '%s\n\n' "$usage"
            exit 1
            ;;
      esac
      shift $((OPTIND - 1))
   done

   if [ $# -gt 0 ]
   then
      printf 'Error: %s takes no arguments\n\n' "$scriptName"
      printf '%s\n\n' "$usage"
      exit 1
   fi

   if [ "$switch" != install ] && [ "$switch" != check ]
   then
      printf 'Error: %s -s given an invalid option argument\n\n%s\n\n' "$scriptName" "$usage"
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
                  printf '%s: failed to create "%s" directory\n\n' "$scriptName" "$targetDir"
               ;;
            check)
               printf '%s: directory "%s" needs to be created\n\n' "$scriptName" "$targetDir"
               ;;
         esac
      fi
      if [ -n "$srcDir" ] && [ ! -d "$srcDir" ]
      then
         printf '%s: source directory "%s" does not exist\n\n' "$scriptName" "$srcDir"
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
                  printf '%s: Failed to remove "%s" from target\n\n' "$scriptName" "$item"
               }
               ;;
            check)
               printf '%s: "%s" needs removing from target\n\n' "$scriptName" "$item"
               ;;
         esac
      fi
   }

   # Install a file
   install_file () {
      local install_dir file_path src_dir file_perm envPath
      local src_rel src_abs trgt
      install_dir="$1"
      file_path="$2"
      src_dir="$3"
      file_perm="$4"
      envPath=$5
      src_rel=$(echo "$src_dir/$file_path" | sed -E 's|(/\.)*/\./|/|g')
      src_abs=$(echo "$envPath/$src_rel" | sed -E 's|(/\.)*/\./|/|g')
      trgt=$(echo "$install_dir/$file_path" | sed -E 's|(/\.)*/\./|/|g')

      # Ensure target directory exists and complain if source directory doesn't
      ensure_dir "${trgt%/*}" "${src_abs%/*}"

      case "$switch" in
         install)
            # Install the file
            if cp "$src_rel" "$trgt"
            then
               chmod --quiet "$file_perm" "$trgt" || {
                  printf '%s: failed to set permissions on "%s" to "%s"\n\n' "$scriptName" "$trgt" "$file_perm"
               }
            else
               printf '%s: failed to install "%s"\n\n' "$scriptName" "$trgt"
            fi
            ;;
         check)
            # Compare config with install target 
            if [ ! -e "$src_abs" ] && [ ! -e "$trgt" ]
            then
               printf '%s:\n\tboth source: "%s"\n\t and target: "%s" do not exist.\n\n' "$scriptName" "$src_abs" "$trgt"
            elif [ ! -e "$trgt" ]
            then
               printf '%s: target "%s" does not exist\n\n' "$scriptName" "$trgt"
            elif [ ! -e "$src_abs" ]
            then
               printf '%s: source "%s" does not exist\n\n' "$scriptName" "$src_abs"
            else
               diff "$trgt" "$src_abs" > /dev/null || {
                  printf '%s: "%s" differs from "%s"\n\n' "$scriptName" "$trgt" "$src_abs"
               }
            fi
            ;;
      esac
   }

   # Install files - convenience function (keep loops out of config files)
   install_files () {
      local install_dir files src_dir file_perm envPath
      local file
      install_dir="$1"
      files="$2"
      src_dir="$3"
      file_perm="$4"
      envPath=$5
      test -z "$files" && return
      for file in $files
      do
         install_file "$install_dir" "$file" "$src_dir" "$file_perm" "$envPath"
      done
   }

   # Check or remove files or directories - convenience function
   remove_items () {
      local items
      local item
      test ${#} -gt 1 && {
         printf '%s: Error - remove_items only takes one argument\n\n' "$scriptName" 
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
      local dirs
      local dir
      test ${#} -gt 1 && {
         printf '%s: Error - ensure_dirs only takes one argument\n\n' "$scriptName" 
      }
      dirs="$1"
      test -z "$dirs" && return
      for dir in $dirs
      do
         ensure_dir "$dir"
      done
   }

fi
