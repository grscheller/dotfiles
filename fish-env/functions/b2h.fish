function b2h --description 'eval math expr from binary to hex (capital A-F)'
    printf 'ibase=2\nobase=10000\n%s\n' "$argv" | /usr/bin/bc
end
