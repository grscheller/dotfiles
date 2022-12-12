function o2b --description 'eval math expr from octal to binary'
    printf 'ibase=8\nobase=2\n%s\n' "$argv" | /usr/bin/bc
end
