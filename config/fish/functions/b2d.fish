function b2d --description 'eval math expr from binary to decimal'
    printf 'ibase=2\nobase=1010\n%s\n' "$argv" | /usr/bin/bc
end
