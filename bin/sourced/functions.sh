## Functions used by scripts
#
# Shell functions defined here for reuse in install
# scripts. Helps to de-clutters scripts.
#
# shellcheck shell=sh

# Check or remove a file or a directory
remove_item () {
    item="$1"
    if test -e "$item"
    then
        case "$DF_ACTION" in
            check)
                printf '%s: "%s" needs to be removed from the target\n\n' "$SCRIPT_NAME" "$item" >&2
                ;;
            install|remove|clean|nuke)
                rm -rf "$item"
                test -e "$item" && {
                    printf '%s: Failed to remove "%s" from the target\n\n' "$SCRIPT_NAME" "$item" >&2
                }
                ;;
            *)
                printf '%s: Unknown state "%s" in remove_item().\n\n' "$SCRIPT_NAME" "$DF_ACTION" >&2
                ::
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
                printf '%s: failed to create "%s" directory\n\n' "$SCRIPT_NAME" "$target_dir" >&2
                ;;
            check)
                printf '%s: directory "%s" needs to be created\n\n' "$SCRIPT_NAME" "$target_dir" >&2
                ;;
            remove)
                ;;
            clean)
                rmdir "$target_dir" > /dev/null 2>&1
                ;;
            nuke)
                rm -rf "$target_dir"
                ;;
            *)
                printf '%s: Unknown state "%s" in ensure_item().\n\n' "$SCRIPT_NAME" "$DF_ACTION" >&2
                ::
        esac
    fi
    if [ -n "$src_dir" ] && [ ! -d "$src_dir" ]
    then
        printf '%s: source directory "%s" does not exist\n\n' "$SCRIPT_NAME" "$src_dir" >&2
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
    src_rel=$(printf '%s\n' "$src_dir/$file_path" | sed -E 's|(/\.)*/\./|/|g')
    src_abs=$(printf '%s\n' "$df_home/$src_rel" | sed -E 's|(/\.)*/\./|/|g')
    trgt=$(printf '%s\n' "$install_dir/$file_path" | sed -E 's|(/\.)*/\./|/|g')

    # Ensure target directory exists and complain if source directory doesn't
    ensure_dir "${trgt%/*}" "${src_abs%/*}"

    case "$DF_ACTION" in
        install)
            # Install the remove the target file
            if cp "$src_rel" "$trgt"
            then
                chmod --quiet "$file_perm" "$trgt" || {
                    printf '%s: failed to set permissions on "%s" to "%s"\n\n' "$SCRIPT_NAME" "$trgt" "$file_perm" >&2
                }
            else
                printf '%s: failed to install "%s"\n\n' "$SCRIPT_NAME" "$trgt" >&2
            fi
            ;;
        check)
            # Compare config with install target
            if test ! -e "$src_abs" && test ! -e "$trgt" >&2
            then
                printf '%s:\n\tboth source: "%s"\n\t and target: "%s" do not exist.\n\n' "$SCRIPT_NAME" "$src_abs" "$trgt" >&2
            elif test ! -e "$trgt"
            then
                printf '%s: target "%s" does not exist\n\n' "$SCRIPT_NAME" "$trgt" >&2
            elif test ! -e "$src_abs"
            then
                printf '%s: source "%s" does not exist\n\n' "$SCRIPT_NAME" "$src_abs" >&2
            else
                diff "$trgt" "$src_abs" > /dev/null || {
                    printf '%s: "%s" differs from "%s"\n\n' "$SCRIPT_NAME" "$trgt" "$src_abs" >&2
                }
            fi
            ;;
        remove)
            # remove the target file
            remove_item "$trgt"
            ;;
        *)
            printf '%s: Unknown state "%s" in ensure_dir().\n\n' "$SCRIPT_NAME" "$DF_ACTION" >&2
            ::
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
        printf '%s: Error - remove_items only takes one argument\n\n' "$SCRIPT_NAME" >&2
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
        printf '%s: Error - ensure_dirs only takes one argument\n\n' "$SCRIPT_NAME" >&2
    }
    dirs="$1"
    test -z "$dirs" && return
    for dir in $dirs
    do
        ensure_dir "$dir"
    done
}
