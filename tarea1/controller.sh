random_name() {
    local directory=$1
    local mode=$2 
    local list=()

    for dir in "$directory"/*; do
        if [ -d "$dir" ]; then
            local sublist=($(random_name $dir $mode))
            list+=("${sublist[@]}")
        elif [ -f "$dir" ] && [[ "$(basename "$dir")" != *.* ]]; then
            list+=("$(basename "$dir")")
        fi
    done

    local list_index=$(( RANDOM % ${#list[@]} ))
    local select="${list[$list_index]}"

    echo "$select"
}

random_content() {
    local directory=$1
    local mode=$2 
    local list=()

    for dir in "$directory"/*; do
        if [ -d "$dir" ]; then
            local sublist=($(random_content $dir $mode))
            list+=("${sublist[@]}")
        elif [ -f "$dir" ] && [[ "$(basename "$dir")" != *.* ]]; then
            list+=$(cat "$dir")
        fi
    done

    local list_index=$(( RANDOM % ${#list[@]} ))
    local select="${list[$list_index]}"

    echo "$select"
}

random_checksum() {
    local directory=$1
    local mode=$2 
    local list=()

    for dir in "$directory"/*; do
        if [ -d "$dir" ]; then
            local sublist=($(random_checksum $dir $mode))
            list+=("${sublist[@]}")
        elif [ -f "$dir" ] && [[ "$(basename "$dir")" != *.* ]]; then
            list+=("$(sha256sum "$dir" | awk '{print $1}')")
        fi
    done

    local list_index=$(( RANDOM % ${#list[@]} ))
    local select="${list[$list_index]}"

    echo "$select"
}

random_dir() {
    local directory=$1
    local mode=$2 
    local list=()

    for dir in "$directory"/*; do
        if [ -d "$dir" ]; then
            local sublist=($(random_dir $dir $mode))
            list+=("${sublist[@]}")
        elif [ -f "$dir" ] && { [[ "$dir" == *.gpg ]] || [[ "$dir" == *.enc ]]; }; then
            list+=("$dir")
        fi
    done

    local list_index=$(( RANDOM % ${#list[@]} ))
    local select="${list[$list_index]}"

    echo "$select"
}

encrypt_gpg() {
    local dir=$1
    local passphrase="CC5308"
    gpg --batch --yes --passphrase "$passphrase" -c "$dir"
    rm "$dir"
    echo "$passphrase"
}

encrypt_openssl() {
    local dir=$1
    local passphrase="CC5309"
    openssl enc -aes-256-cbc -salt -in "$dir" -out "$dir".enc -pass pass:"$passphrase" -pbkdf2
    rm "$dir"
    echo "$passphrase"
}

place_treasure() { 
    local directory=$1
    local mode=$2 
    local i 
    case $mode in 
        "name")
            i=$(random_name $directory $mode)
            ;;
        "content")
            i=$(random_content $directory $mode)
            ;;
        "checksum")
            i=$(random_checksum $directory $mode)
            ;;
        "encrypted")
            local aux_dir=$(random_dir $directory $mode)
            i=$(encrypt_gpg $aux_dir) 
            ;; 
        "signed")
            local aux_dir=$(random_dir $directory $mode)
            i=$(encrypt_openssl $aux_dir) 
            ;; 
    esac 
    echo "$i"
}

verify(){
    local expected=$1
    local input=$2

    if [ "$expected" == "$input" ]; then
        echo 1
    else 
        echo 0    
    fi
}
# ---------------------

# Setup testing
dir="game_board"
mode="encrypted"
key=$(place_treasure $dir $mode)
verify $key "CC5308"