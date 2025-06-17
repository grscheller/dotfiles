# grscheller/dotfiles setup script
#
# Parse input arguments and setup infrastructure.
#
# shellcheck shell=dash
#
if [ -z "$scriptName" ]
then
   printf '\nCheck configuration, the scriptName is not set.\n\n'
   exit 1
fi

if [ -z "$ACTION" ]
then
   export ACTION=''
   export CLEAN=''
   export NUKE=''

   umask 0022
   export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
   export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
   export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
   export XDG_STATE_HOME="${XDG_STATE_HOME:=$HOME/.local/state}"

   ## Parse cmdline arguments

   usage="Usage: $scriptName [--install|--check|--remove|--clean|--nuke]"

   if test $# -gt 1
   then
      printf '%s\n\n' "$usage"
      exit 1
   elif test $# -eq 1
   then
      case "$1" in
         --install)
            ACTION=install
            CLEAN=''
            NUKE=''
            ;;
         --check)
            ACTION=check
            CLEAN=''
            NUKE=''
            ;;
         --remove)
            ACTION=remove
            CLEAN=''
            NUKE=''
            ;;
         --clean)
            ACTION=remove
            CLEAN=clean
            NUKE=''
            ;;
         --nuke)
            ACTION=remove
            CLEAN=clean
            NUKE=nuke
            ;;
         *)
            printf '%s\n\n' "$usage"
            exit 1
            ;;
      esac
   else
      ACTION=install
      CLEAN=''
      NUKE=''
   fi

   ## Functions

   # Check or remove a file or a directory
   remove_item () {
      local item
      item="$1"
      if test -e "$item"
      then
         case "$ACTION" in
            check)
               printf '%s: "%s" needs removing from target\n\n' "$scriptName" "$item"
               ;;
            install|remove)
               rm -rf "$item"
               test -e "$item" && {
                  printf '%s: Failed to remove "%s" from target\n\n' "$scriptName" "$item"
               }
         esac
      fi
   }

   # Check or ensure directory exists
   ensure_dir () {
      local targetDir srcDir
      targetDir="$1"
      srcDir="$2"
      if [ ! -d "$targetDir" ]
      then
         case "$ACTION" in
            install)
               mkdir -p "$targetDir" ||
                  printf '%s: failed to create "%s" directory\n\n' "$scriptName" "$targetDir"
               ;;
            check)
               printf '%s: directory "%s" needs to be created\n\n' "$scriptName" "$targetDir"
               ;;
            remove)
               test "$CLEAN" = clean && rmdir "$targetDir" >/dev/null 2>&1
               test "$NUKE" = nuke && rm -rf "$targetDir"
         esac
      fi
      if [ -n "$srcDir" ] && [ ! -d "$srcDir" ]
      then
         printf '%s: source directory "%s" does not exist\n\n' "$scriptName" "$srcDir"
      fi
   }

   # Install, check, or remove file
   process_file () {
      local install_dir file_path src_dir file_perm home_dir
      local src_rel src_abs trgt
      install_dir="$1"
      file_path="$2"
      src_dir="$3"
      file_perm="$4"
      home_dir=$5
      src_rel=$(echo "$src_dir/$file_path" | sed -E 's|(/\.)*/\./|/|g')
      src_abs=$(echo "$home_dir/$src_rel" | sed -E 's|(/\.)*/\./|/|g')
      trgt=$(echo "$install_dir/$file_path" | sed -E 's|(/\.)*/\./|/|g')

      # Ensure target directory exists and complain if source directory doesn't
      ensure_dir "${trgt%/*}" "${src_abs%/*}"

      case "$ACTION" in
         install)
            # Install the remove the target file
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
         remove)
            # remove the target file
            remove_item "$trgt"
            ;;
      esac
   }

   # Install files - convenience function (keep loops out of config files)
   process_files () {
      local install_dir files src_dir file_perm home_dir
      local file
      install_dir="$1"
      files="$2"
      src_dir="$3"
      file_perm="$4"
      home_dir=$5
      test -z "$files" && return
      for file in $files
      do
         process_file "$install_dir" "$file" "$src_dir" "$file_perm" "$home_dir"
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
      test $# -gt 1 && {
         printf '%s: Error - ensure_dirs only takes one argument\n\n' "$scriptName" 
      }
      dirs="$1"
      test -z "$dirs" && return
      for dir in $dirs
      do
         ensure_dir "$dir"
      done
   }

   fatal_error () {
      if test -z "${1}"
      then
         printf '%s: Fatal Error\n' "$scriptName"
      else
         printf '%s: Fatal Error - %s\n' "$scriptName" "$1"
      fi
      exit 2
   }

   ## For initial bootstrap when $XDG directories might not exist yet

   if [ $ACTION = install ]
   then
      ensure_dir "$XDG_CONFIG_HOME"
      chmod 0755 "$XDG_CONFIG_HOME"
      ensure_dir "$XDG_DATA_HOME"
      chmod 0755 "$XDG_DATA_HOME"
      ensure_dir "$XDG_STATE_HOME"
      chmod 0755 "$XDG_STATE_HOME"
      ensure_dir "$XDG_CACHE_HOME"
      chmod 0755 "$XDG_CACHE_HOME"
   fi
fi
