random_text() {
    local length=$1
    cat /dev/urandom | tr -dc [a-zA-Z0-9] | head -c "$length"
}

clean_board() {
    rm -rf "$dir"
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


# ---------------------

# Setup
dir="game_board"
clean_board
create_board $dir 3 4 5

# Material
#  aux 5 : para game_board es el mismo codigo