function h2o --description 'eval math expr from hex to octal (capital A-F)'
    printf 'ibase=16\nobase=8\n%s\n' "$argv" | /usr/bin/bc
end
