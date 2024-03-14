function d2o --description 'eval math expr from decimal to octal'
    printf 'ibase=10\nobase=8\n%s\n' "$argv" | /usr/bin/bc
end
