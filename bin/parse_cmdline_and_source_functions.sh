# grscheller/dotfiles setup script
#
# Common infrastructure sourced into other dotfile installation scripts.
# Parses input arguments and setup functions for the dotfile scripts`.
# The idea is to keep the installation  scripts as simple as possible.0
#
# shellcheck shell=dash
#

if [ -z "$scriptName" ]
then
   printf '\nCheck configuration, the scriptName is not set.\n\n'
   exit 1
fi

home=${home:=~/devel/dotfiles/home}

if [ ! -d "$home" ]
then
   printf '\nCheck installation, '
   printf 'the git repo %s does not exist.\n\n' "${home%/*}"
   exit 1
fi

export DF_ACTION=${DF_ACTION:=''}

if [ -z "$DF_ACTION" ]
then
   export DF_ACTION

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
            DF_ACTION=install
            ;;
         --check)
            DF_ACTION=check
            ;;
         --remove)
            DF_ACTION=remove
            ;;
         --clean)
            DF_ACTION=clean
            ;;
         --nuke)
            DF_ACTION=nuke
            ;;
         *)
            printf '%s\n\n' "$usage"
            exit 1
            ;;
      esac
   else
      DF_ACTION=install
   fi

   ## Functions

   # Check or remove a file or a directory
   remove_item () {
      local item
      item="$1"
      if test -e "$item"
      then
         case "$DF_ACTION" in
            check)
               printf '%s: "%s" needs to be removed from the target\n\n' "$scriptName" "$item"
               ;;
            install|remove|clean|nuke)
               rm -rf "$item"
               test -e "$item" && {
                  printf '%s: Failed to remove "%s" from the target\n\n' "$scriptName" "$item"
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
         case "$DF_ACTION" in
            install)
               mkdir -p "$targetDir" ||
                  printf '%s: failed to create "%s" directory\n\n' "$scriptName" "$targetDir"
               ;;
            check)
               printf '%s: directory "%s" needs to be created\n\n' "$scriptName" "$targetDir"
               ;;
            remove)
               ;;
            clean)
               rmdir "$targetDir" > /dev/null 2>&1
               ;;
            nuke)
               rm -rf "$targetDir"
               ;;
         esac
      fi
      if [ -n "$srcDir" ] && [ ! -d "$srcDir" ]
      then
         printf '%s: source directory "%s" does not exist\n\n' "$scriptName" "$srcDir"
      fi
   }

   # Install, check, or remove file
   process_file () {
      local install_dir file_path src_dir file_perm
      local src_rel src_abs trgt
      install_dir="$1"
      file_path="$2"
      src_dir="$3"
      file_perm="$4"
      src_rel=$(echo "$src_dir/$file_path" | sed -E 's|(/\.)*/\./|/|g')
      src_abs=$(echo "$home/$src_rel" | sed -E 's|(/\.)*/\./|/|g')
      trgt=$(echo "$install_dir/$file_path" | sed -E 's|(/\.)*/\./|/|g')

      # Ensure target directory exists and complain if source directory doesn't
      ensure_dir "${trgt%/*}" "${src_abs%/*}"

      case "$DF_ACTION" in
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
      local install_dir files src_dir file_perm
      local file
      install_dir="$1"
      files="$2"
      src_dir="$3"
      file_perm="$4"
      test -z "$files" && return
      for file in $files
      do
         process_file "$install_dir" "$file" "$src_dir" "$file_perm"
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
      test ! $# -eq 1 && {
         printf '%s: Error - ensure_dirs only takes one argument\n\n' "$scriptName"
      }
      dirs="$1"
      test -z "$dirs" && return
      for dir in $dirs
      do
         ensure_dir "$dir"
      done
   }

   ## For initial bootstrap when $XDG directories might not exist yet

   if [ $DF_ACTION = install ]
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
