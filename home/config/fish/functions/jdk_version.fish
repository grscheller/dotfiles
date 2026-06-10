function jdk_version --description 'Setup JDK on Pop!OS Linux'
    set -f jdkVersion

    # Parse user input
    if test (count $argv) -gt 0
        set jdkVersion (string split --no-empty --max 1 ' ' (string trim $argv[1]))
        test (count $jdkVersion) -gt 1
        and set jdkVersion $jdkVersion[1]
    end

    # Make sure at least one Java JDK is installed in default location
    set -f jdir
    set -f jvmDirs
    set -f jvmDirsAndLinks /usr/lib/jvm/java-*-openjdk*
    for jdir in $jvmDirsAndLinks
        test -L $jdir
        and continue
        test -d $jdir
        and set -a jvmDirs $jdir
    end
    if test -z "$jvmDirs"
        printf 'No JDK environments installed\n'
        return 1
    end

    # If user gave no arguments, print available java versions
    if test -z "$jdkVersion"
        printf 'Available Java Versions:'
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

    set -f javaHome /usr/lib/jvm/java-$jdkVersion-openjdk*

    # Bail if Java version is not installed
    if not test -d "$javaHome"
        printf 'No JDK found for Java version %s in /usr/lib/jvm\n' $jdkVersion >&2
        return 1
    end

    # Set JAVA_HOME
    set -gx JAVA_HOME $javaHome
    set -gx JDK_VERSION $jdkVersion

    # Fix PATH
    set -f index 0
    for ii in (seq 1 (count $PATH))
        if string match -q '/usr/lib/jvm/java-*-openjdk*/bin' $PATH[$ii]
            set index $ii
            break
        end
    end

    if test $index -eq 0
        set -p PATH $javaHome/bin
        set index 1
    else
        set PATH[$index] $javaHome/bin
    end

    for ii in (seq (count $PATH) -1 (math $index + 1))
        if string match -q '/usr/lib/jvm/java-*-openjdk*/bin' $PATH[$ii]
            set -e PATH[$ii]
        end
    end

    return 0
end
