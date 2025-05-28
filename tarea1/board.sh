random_text() {
    local length=$1
    cat /dev/urandom | tr -dc [a-zA-Z0-9] | head -c "$length"
}

clean_board() {
    local dir=$1
    rm -rf $dir
}

create_board() {
    local dir=$1
    local depth=$2
    local width=$3
    local files=$4

    mkdir -p "$dir"

    if [ "$depth" -le 0 ]; then
        for ((f=1;f<=files; f++)); do
            file_path="$dir/$(random_text 3)"
            random_text 20 > "$file_path"
        done
    
    else 
        local i
        for ((i=0; i<$width; i++)); do
            dir_path="$dir/$(random_text 10)"
            new_depth=$((depth-1))
            create_board $dir_path $new_depth $width $files
        done
    fi   
}        

fill_board() {
    local directory=$1
    local mode=$2 

    for dir in "$directory"/*; do
        if [ -d "$dir" ]; then
            fill_board $dir $mode
        elif [ -f "$dir" ] && [[ "$(basename "$dir")" != *.* ]]; then
            case $mode in 
                "encrypted")    
                    gpg --batch --yes --passphrase "hoyo" -c $dir
                    # ex decifrado no olvidar: gpg --batch --yes --passphrase "hoyo" -d -o Pev.descifrado Pev.gpg
                    rm $dir
                    ;;
                "signed")
                    openssl enc -aes-256-cbc -salt -in $dir -out $dir.enc -pass pass:hoyo -pbkdf2
                    # openssl enc -aes-256-cbc -d -in kDq.enc -out decrypted.txt -pass pass:hoyo -pbkdf2
                    rm $dir
                    ;;      
                *)
                    ;;
            esac
        fi
    done

}


# ---------------------

# Setup testing
#y="game_board"
#mode="name"
#clean_board $y
#dir="game_board"
#create_board $dir 2 2 3
#fill_board $dir $mode

# Material
#  aux 5 : para game_board es el mismo codigo que p1