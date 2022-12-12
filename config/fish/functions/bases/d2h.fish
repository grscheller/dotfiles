function d2h --description 'eval math expr from decimal to hex (capital A-F)'
    printf 'ibase=10\nobase=16\n%s\n' "$argv" | /usr/bin/bc
end
