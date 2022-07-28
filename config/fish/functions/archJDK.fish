function archJDK --description 'Setup JDK on Arch Linux'

    # Parse user input
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

    # Sanity check user input
    if not string match -qr '^\d+$' $jdkVersion[1]
        printf 'Malformed JDK version number: "%s"\n' $jdkVersion >&2
        return 1
    end

    set -l javaHome /usr/lib/jvm/java-$jdkVersion[1]-openjdk

    # Bail if Java version is not installed
    if not test -d $javaHome
        printf '\nNo JDK found for Java version %s in the\n' $jdkVersion >&2
        printf 'standard location on Arch Linux: /usr/lib/jvm\n' >&2
        return 1
    end

    # Set JAVA_HOME
    set -gx JAVA_HOME $javaHome

    # Fix PATH
    set -l idx 0
    for ii in (seq 1 (count $PATH))
        if string match -q '/usr/lib/jvm/java-*-openjdk/bin' $PATH[$ii]
            set idx $ii
            break
        end
    end

    if test $idx -eq 0
        set -p PATH $javaHome/bin
        set idx 1
    else
        set PATH[$idx] $javaHome/bin
    end

    for ii in (seq (count $PATH) -1 (math $idx + 1))
        if string match -q '/usr/lib/jvm/java-*-openjdk/bin' $PATH[$ii]
            set -e PATH[$ii]
        end
    end

    return 0
end
