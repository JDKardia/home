to-big-emoji() {
    if (( $# == 0 )) ; then
      sed -E "s/([A-Z'a-z])/:big-\1:/g; s/ /:blank:/g" < /dev/stdin
    else
      sed -E "s/([A-Z'a-z])/:big-\1:/g; s/ /:blank:/g" <<< "$@"
    fi
}
