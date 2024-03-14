function d2b --description 'eval math expr from decimal to binary'
    printf 'ibase=10\nobase=2\n%s\n' "$argv" | /usr/bin/bc
end
