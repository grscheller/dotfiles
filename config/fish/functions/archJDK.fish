function archJDK --description 'Setup JDK on Arch Linux'

    set -l jdkVersion (string trim $argv[1])

    # Make sure at least one Java JDK is installed in default location
    set -l jvmDirs /usr/lib/jvm/java-*-openjdk
    if test -z "$jvmDirs"
        printf '\nNo JDK environments installed\n'
        return 1
    end

    # If user gave no arguments, print available java versions
    if test -z "$jdkVersion"
        printf '\nAvailable Java Versions:'
        for jdir in $jvmDirs
            set -l jdirSplit (string split - $jdir)
            printf ' %s' $jdirSplit[2]
        end
        printf '\n'
        return 0
    end

    if not string match -qr '^\d+$' $jdkVersion[1]
        printf 'Malformed JDK version number: "%s"\n' $jdkVersion >&2
        return 1
    end

    set -l javaHome /usr/lib/jvm/java-$jdkVersion[1]-openjdk
    if test -d $javaHome
        set -gx JAVA_HOME $javaHome
        if string match -q '/usr/lib/jvm/java-*-openjdk/bin' $PATH[1]
            set PATH $javaHome/bin $PATH[2..-1]
        else
            set -p PATH $javaHome/bin
        end
        return 0
    else
        printf '\nNo JDK found for Java version %s in the\n' $jdkVersion >&2
        printf 'standard location on Arch Linux: /usr/lib/jvm\n' >&2
        return 1
    end

end
