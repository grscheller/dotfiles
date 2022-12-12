function h2d --description 'eval math expr from hex to decimal (capital A-F)'
    printf 'ibase=16\nobase=A\n%s\n' "$argv" | /usr/bin/bc
end
