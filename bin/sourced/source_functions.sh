# grscheller/dotfiles setup script
#
# Common infrastructure sourced into other dotfile installation scripts.
# Parses input arguments and setup functions for the dotfile scripts`.
# The idea is to keep the installation  scripts as simple as possible.0
#
# shellcheck shell=dash

: "${script_name:=}"
: "${df_home:=}"

## Functions

# Check or remove a file or a directory
remove_item () {
   item="$1"
   if test -e "$item"
   then
      case "$DF_ACTION" in
         check)
            printf '%s: "%s" needs to be removed from the target\n\n' "$script_name" "$item"
            ;;
         install|remove|clean|nuke)
            rm -rf "$item"
            test -e "$item" && {
               printf '%s: Failed to remove "%s" from the target\n\n' "$script_name" "$item"
            }
      esac
   fi
}

# Check or ensure directory exists
ensure_dir () {
   local target_dir src_dir
   target_dir="$1"
   src_dir="$2"
   if [ ! -d "$target_dir" ]
   then
      case "$DF_ACTION" in
         install)
            mkdir -p "$target_dir" ||
               printf '%s: failed to create "%s" directory\n\n' "$script_name" "$target_dir"
            ;;
         check)
            printf '%s: directory "%s" needs to be created\n\n' "$script_name" "$target_dir"
            ;;
         remove)
            ;;
         clean)
            rmdir "$target_dir" > /dev/null 2>&1
            ;;
         nuke)
            rm -rf "$target_dir"
            ;;
      esac
   fi
   if [ -n "$src_dir" ] && [ ! -d "$src_dir" ]
   then
      printf '%s: source directory "%s" does not exist\n\n' "$script_name" "$src_dir"
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
   src_abs=$(echo "$df_home/$src_rel" | sed -E 's|(/\.)*/\./|/|g')
   trgt=$(echo "$install_dir/$file_path" | sed -E 's|(/\.)*/\./|/|g')

   # Ensure target directory exists and complain if source directory doesn't
   ensure_dir "${trgt%/*}" "${src_abs%/*}"

   case "$DF_ACTION" in
      install)
         # Install the remove the target file
         if cp "$src_rel" "$trgt"
         then
            chmod --quiet "$file_perm" "$trgt" || {
               printf '%s: failed to set permissions on "%s" to "%s"\n\n' "$script_name" "$trgt" "$file_perm"
            }
         else
            printf '%s: failed to install "%s"\n\n' "$script_name" "$trgt"
         fi
         ;;
      check)
         # Compare config with install target
         if [ ! -e "$src_abs" ] && [ ! -e "$trgt" ]
         then
            printf '%s:\n\tboth source: "%s"\n\t and target: "%s" do not exist.\n\n' "$script_name" "$src_abs" "$trgt"
         elif [ ! -e "$trgt" ]
         then
            printf '%s: target "%s" does not exist\n\n' "$script_name" "$trgt"
         elif [ ! -e "$src_abs" ]
         then
            printf '%s: source "%s" does not exist\n\n' "$script_name" "$src_abs"
         else
            diff "$trgt" "$src_abs" > /dev/null || {
               printf '%s: "%s" differs from "%s"\n\n' "$script_name" "$trgt" "$src_abs"
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
   test "${#}" -gt 1 && {
      printf '%s: Error - remove_items only takes one argument\n\n' "$script_name"
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
   test ! "$#" -eq 1 && {
      printf '%s: Error - ensure_dirs only takes one argument\n\n' "$script_name"
   }
   dirs="$1"
   test -z "$dirs" && return
   for dir in $dirs
   do
      ensure_dir "$dir"
   done
}
