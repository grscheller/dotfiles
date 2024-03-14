function WgetM --description 'Mirror a subset of a website'
    /usr/bin/wget --mirror -p --convert-links -e robots=off $argv
end
