function h2b --description 'eval math expr from hex to binary (capital A-F)'
    printf 'ibase=16\nobase=2\n%s\n' "$argv" | /usr/bin/bc
end
