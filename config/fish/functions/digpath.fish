function digpath --description 'Look for files on $PATH'

   # Parse cmdline options - stop at first non-option argument
   argparse -s q/quiet h/help x/executable p/path -- $argv
   or begin
      printf '  for help type: digpath -h\n' >&2
      return 2
   end

   # Print help message and quit
   if set -q _flag_help
      printf 'Description:'                                             >&2
      printf '  Look for files on $PATH, like "type -P" builtin,\n'     >&2
      printf '  but do not stop after finding the first one, also\n'    >&2
      printf '  files do not necessarily have to be executable.\n\n'    >&2
      printf 'Usage: \n'                                                >&2
      printf '  digpath [-q] [-x] file1 file2 ... [ -p $MY_PATH ]\n'    >&2
      printf '  digpath \'nm*\' gc\\* \'../.bashrc\'\n'                 >&2
      printf '  digpath \'**/README*\' -p /usr/share/ ~/.local/share\n' >&2
      printf '  digpath \'**/\\ \\ fred\' -p $HOME\n'                   >&2
      printf '  digpath [-h]\n\n'                                       >&2
      printf '  Options:\n'                                             >&2
      printf '    -q or --quiet\n'                                      >&2
      printf '    -x or --executable\n'                                 >&2
      printf '    -p or --path\n'                                       >&2
      printf '    -h or --help\n\n'                                     >&2
      printf '  Output:\n'                                              >&2
      printf '    print any matches on $PATH to stdout,\n'              >&2
      printf '      suppresses output if -q given,\n'                   >&2
      printf '      suppresses nonexecutables if -x given,\n'           >&2
      printf '    print help message to stderr if -h given\n\n'         >&2
      printf '  Exit Status:\n'                                         >&2
      printf '    0 (true) if match found on $PATH\n'                   >&2
      printf '    1 (false) if no match found\n'                        >&2
      printf '    2 invalid arguments or -h option given\n'             >&2
      return 2
   end

   set -q _flag_path
   and begin
      printf 'digpath: No file arguments given before -p option,\n' >&2
      printf '  for help type: digpath -h\n' >&2
      return 2
   end

   set -l Switch Files
   set -l Files
   set -l Path
   set -l arg
   for arg in $argv
      if [ $arg = -p ] || [ $arg = --path ]
         set Switch Path
      else
         test -n $arg
         and set -a $Switch $arg
      end
   end

   test (count $Files) -eq 0
   and begin
      printf 'digpath: Invalid arguments given,\n' >&2
      printf '  for usage: type "digpath -h"\n' >&2
      return 2
   end

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

   # See which directories contain which files
   set -l Found
   eval set -l Targets (path normalize $Dirs/$Files)
   for Target in $Targets
      test -e $Target -o -L $Target
      and begin
         test -z "$_flag_executable" -o -x "$Target"
         and set -a Found $Target
      end
   end

   # Report on anything found
   set -l item
   if set -q Found[1]
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
