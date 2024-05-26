function Wget --description 'Pull down a subset of a website'
    /usr/bin/wget -p --convert-links -e robots=off $argv
end
