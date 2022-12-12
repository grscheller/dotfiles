function b2o --description 'eval math expr from binary to octal'
    printf 'ibase=2\nobase=1000\n%s\n' "$argv" | /usr/bin/bc
end
