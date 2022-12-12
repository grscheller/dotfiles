function o2h --description 'eval math expr from octal to hex (capital A-F)'
    printf 'ibase=8\nobase=20\n%s\n' "$argv" | /usr/bin/bc
end
