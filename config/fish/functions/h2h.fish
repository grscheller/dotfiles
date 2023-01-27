function h2h --description 'eval math expr from hex to hex (capital A-F)'
    printf 'ibase=16\nobase=10\n%s\n' "$argv" | /usr/bin/bc
end
