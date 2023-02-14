function digpath --description 'Look for files on $PATH'

   # Parse cmdline options
   argparse -s q/quiet h/help x/executable p/path -- $argv
   or begin
       printf 'digpath: For usage, type: digpath -h\n' >&2
       return 2
   end

   # Print help message and quit
   if set -q _flag_help
       printf 'Description: Look for files on $PATH, like "type" but\n'  >&2
       printf '   do not stop after finding first file, also\n'          >&2
       printf '   files do not necessarily have to be executable.\n\n'   >&2
       printf 'Usage: \n'                                                >&2
       printf '   digpath [-q] [-x] file1 file2 ... [ -p $MY_PATH ]\n'   >&2
       printf '   digpath \'glob1*.pat\' glob2\\\*.pat ...\n'            >&2
       printf '   digpath [-h]\n\n'                                      >&2
       printf 'Options:\n'                                               >&2
       printf '   -q or --quiet\n'                                       >&2
       printf '   -x or --executable\n'                                  >&2
       printf '   -p or --path\n'                                        >&2
       printf '   -h or --help\n\n'                                      >&2
       printf 'Output:\n'                                                >&2
       printf '   print any matches on $PATH to stdout,\n'               >&2
       printf '      suppresses output if -q given,\n'                   >&2
       printf '      suppresses nonexecutables if -x given,\n\n'         >&2
       printf '   print help message to stderr if -h given\n'            >&2
       printf 'Exit Status:\n'                                           >&2
       printf '   0 (true) if match found on $PATH\n'                    >&2
       printf '   1 (false) if no match found\n'                         >&2
       printf '   2 -h option given or an error occured\n'               >&2
       return 2
   end

   set -q _flag_path
   and begin
       printf 'digpath: No file arguments given before -p option,\n' >&2
       printf '         for help: digpath -h\n'                      >&2
       return 2
   end

   set -l Choice Files
   set -l Files
   set -l Path
   set -l arg
   for arg in $argv
      if [ $arg = -p ] || [ $arg = --path ]
         set Choice Path
      else
         set -a $Choice $arg
      end
   end

   test (count $Files) -eq 0
   and begin
       printf 'digpath: Invalid number of arguments given,\n' >&2
       printf '         for help: digpath -h\n'               >&2
       return 2
   end

   test (count $Path) -eq 0
   and begin
      set Path $PATH
   end

   # If argument null, not interested in existence of containing directory.
   set -l File
   for File in $Files
       test -n (string trim $File)
       and set -a Files $File
   end

   # Ignore non-existent directories
   set -l Dir
   set -l Dirs
   for Dir in $Path
       test -d $Dir
       and set -a Dirs $Dir
   end

   # See which directories contain which files
   set -l Found
   set -l Target
   set -l Targets
   eval set Targets $Dirs/$Files
   for Target in $Targets
       test -f $Target
       and begin
           test -z "$_flag_executable" -o -x "$Target"
           and set -a Found $Target
       end
   end

   # Report on anything found
   if set -q Found[1]
       if not set -q _flag_quiet
           printf %s\n $Found
       end
       return 0
   else
       return 1
   end

end
