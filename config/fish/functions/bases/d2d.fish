function d2d --description 'eval math expr from decimal to decimal (capital A-F)'
    printf 'ibase=10\nobase=10\n%s\n' "$argv" | /usr/bin/bc
end
