function o2o --description 'eval math expr from octal to octal'
    printf 'ibase=8\nobase=10\n%s\n' "$argv" | /usr/bin/bc
end
