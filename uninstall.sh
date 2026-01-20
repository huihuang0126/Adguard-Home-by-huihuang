chattr_path() {
    [ -e "$1" ] && chattr -i "$1" 2>/dev/null
    rm -rf "$1"
}

exit 0