function cu --description 'change to user with bash shell'
   # get user to become
   set -l user $argv[1]

   # default to root if no user given
   test -z $user
   and set user root
   
   if /usr/bin/id $user >/dev/null 2>&1
      /usr/bin/sudo -u "$user" -H /usr/bin/bash
   else
      printf 'User: %s, does not exist\n' $user
   end
end
