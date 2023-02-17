function digpath --description 'Look for files on $PATH'

   ## Parse cmdline options and set up for processing

   # First pass - stop at first non-option argument
   argparse -s q/quiet h/help x/executable p/path -- $argv
   or begin
      printf '  for help type: digpath -h\n' >&2
      return 2
   end

   # Punt if -p given before any targets
   set -q _flag_path
   and begin
      printf 'digpath: No file arguments given before -p option,\n' >&2
      printf '  for help type: digpath -h\n' >&2
      return 2
   end

   # Second pass - parse remaining -q, -h, -x options
   argparse -i q/quiet h/help x/executable -- $argv
   or begin
      printf '  for help type: digpath -h\n' >&2
      return 2
   end

   set -l argv_pass2 $argv

   # Third pass - sanity check remaining arguments
   argparse p/path -- $argv
   or begin
      printf '  for help type: digpath -h\n' >&2
      return 2
   end

   # Print help message and quit if -h was given
   if set -q _flag_help
      printf 'Description:\n'                                           >&2
      printf '  Look for Targets on Path, like "type -P" builtin,\n'    >&2
      printf '  but do not stop after finding the first one, also\n'    >&2
      printf '  Targets do not necessarily have to be executable.\n'    >&2
      printf '  Glob patterns supported for Targets, not for Path\n'    >&2
      printf '  components.\n\n'                                        >&2
      printf 'Usage: \n'                                                >&2
      printf '  digpath [-h] [-q] [-x] $Targets [ -p $Path ]\n\n'       >&2
      printf 'Examples: \n'                                             >&2
      printf '  digpath \'nm*\' gc\\* \'../.bashrc\'\n'                 >&2
      printf '  digpath \'**/README*\' -p /usr/share/ ~/.local/share\n' >&2
      printf '  digpath \'**/\\ \\ fred\' -p $HOME\n\n'                 >&2
      printf 'Options:\n'                                               >&2
      printf '    -h or --help\n'                                       >&2
      printf '    -q or --quiet\n'                                      >&2
      printf '    -x or --executable\n'                                 >&2
      printf '    -p or --path\n'                                       >&2
      printf '  Option -p separates the $Targets from the $Path\n'      >&2
      printf '  and at least one Target must be given. If -p or\n'      >&2
      printf '  $Path not given, $Path defaults to $PATH.\n\n'          >&2
      printf 'Output:\n'                                                >&2
      printf '  Print any matches on Path to stdout,\n'                 >&2
      printf '    suppresses output if -q was given,\n'                 >&2
      printf '    suppresses nonexecutables if -x was given.\n'         >&2
      printf '  Print help message to stderr if -h was given.\n\n'      >&2
      printf 'Exit Status:\n'                                           >&2
      printf '  0 (true) if match found on $PATH\n'                     >&2
      printf '  1 (false) if no match found\n'                          >&2
      printf '  2 invalid arguments or -h option given\n'               >&2
      return 2
   end

   # Parse out targets and paths - from second pass
   set -l Switch Files
   set -l Files
   set -l Path
   set -l arg
   for arg in $argv_pass2
      if [ $arg = -p ] || [ $arg = --path ]
         set Switch Path
      else
         test -n $arg
         and set -a $Switch $arg
      end
   end

   # Punt if no targets given on cmdline
   test (count $Files) -eq 0
   and begin
      printf 'digpath: No search patterns given,\n' >&2
      printf '  for usage: type "digpath -h"\n' >&2
      return 2
   end

   # Default to $PATH if no paths given on cmdline
   test (count $Path) -eq 0
   and begin
      set Path $PATH
   end

   # Ignore non-existent directories
   set -l Dirs
   for Dir in $Path
      test -d $Dir
      and set -a Dirs $Dir
   end

   ## See which directories contain which files
   set -l Found
   eval set -l Targets (path normalize $Dirs/$Files)
   for Target in $Targets
      test -e $Target -o -L $Target
      and begin
         test -z "$_flag_executable" -o -x "$Target"
         and set -a Found $Target
      end
   end

   ## Report on anything found
   set -l item
   if set -q Found
      if not set -q _flag_quiet
         for item in $Found
            if test -d $item
               printf %s/\n $item
            else
               printf %s\n $item
            end
         end
      end
      return 0
   else
      return 1
   end

end
