function ff
    if digpath -q firefox
        firefox $argv[1] &; disown
    else if [ -x /Applications/Firefox.app/Contents/MacOS/firefox ]
        # Maybe we are on iMac
        /Applications/Firefox.app/Contents/MacOS/firefox $argv[1] &; disown
    else
        printf '\nCannot find firefox executable.\n'
        return 1
    end
end
