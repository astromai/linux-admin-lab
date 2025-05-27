random_text() {
    local length=$1
    cat /dev/urandom | tr -dc [a-zA-Z0-9]
}

create_board() {
    local dir = "game_board"
    local depth = $1
    local width = $2
    local files = $3

    mkdir -p "$dir"

    if [ "$depth" -le 0 ]; then
        for ((f=1;f<files; f++)); do
            file_path= "$dir/$(random_text 10)"
        done
    fi    
}        

create_board 2 4 5