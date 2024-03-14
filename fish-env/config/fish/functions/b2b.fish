function b2b --description 'eval math expr from binary to binary'
    printf 'ibase=2\nobase=10\n%s\n' "$argv" | /usr/bin/bc
end
