function o2d --description 'eval math expr from octal to decimal'
    printf 'ibase=8\nobase=12\n%s\n' "$argv" | /usr/bin/bc
end
