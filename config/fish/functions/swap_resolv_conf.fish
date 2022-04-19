function swap_resolv_conf --description 'toggle resolv.conf link with backup file'

    if test ! -e /etc/resolv.conf
        printf 'PUNTING: /etc/resolv.conf does not exist'
        return 1
    end

    if test ! -e /etc/resolv.conf.bak
        printf 'PUNTING: /etc/resolv.conf.bak does not exist'
        return 1
    end

    if test ! -e /run/systemd/resolve/stub-resolv.conf
        printf 'PUNTING: /run/systemd/resolve/stub-resolv.conf does not exist'
        return 1
    end

    if test -L /etc/resolv.conf
        sudo rm /etc/resolv.conf
        sudo cp /etc/resolv.conf.bak /etc/resolv.conf
    else
        sudo rm /etc/resolv.conf
        sudo ln -rsf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
    end

    ls -l /etc/resolv.conf

end
