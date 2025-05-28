source ./board.sh
source ./controller.sh

display() {
    echo "████████╗██████╗ ███████╗ █████╗ ███████╗██╗   ██╗██████╗ ███████╗"
    echo "╚══██╔══╝██╔══██╗██╔════╝██╔══██╗██╔════╝██║   ██║██╔══██╗██╔════╝"
    echo "   ██║   ██████╔╝█████╗  ███████║███████╗██║   ██║██████╔╝█████╗  "
    echo "   ██║   ██╔══██╗██╔══╝  ██╔══██║╚════██║██║   ██║██╔══██╗██╔══╝  "
    echo "   ██║   ██║  ██║███████╗██║  ██║███████║╚██████╔╝██║  ██║███████╗"
    echo "   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"

    echo ""

    echo "██╗  ██╗██╗   ██╗███╗   ██╗████████╗"
    echo "██║  ██║██║   ██║████╗  ██║╚══██╔══╝"
    echo "███████║██║   ██║██╔██╗ ██║   ██║   "
    echo "██╔══██║██║   ██║██║╚██╗██║   ██║   "
    echo "██║  ██║╚██████╔╝██║ ╚████║   ██║   "
    echo "╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   "
}

game() {

    handle_exit() {
        if [ -z "$key" ]; then
            echo "Has salido antes de que el tesoro fuera escondido."
        else
            echo "Has salido del juego. La clave era: "$key""
        fi
        exit 0
    }

    trap handle_exit SIGINT SIGTSTP

    echo ""
    display
    echo ""
    echo "|-------------------------------------------------------|"
    echo "| Bienvenido a la busquerda del tesoro                  |" 
    echo "| Para jugar necesitas escoger una de estas modalidades |"
    echo "|-------------------------------------------------------|"

    echo ""

    echo "  Modalidades disponibles:"
    echo "  --> Solo indique con su nombre..."
    echo "      1. name"
    echo "      2. content"
    echo "      3. checksum"
    echo "      4. encrypted"
    echo "      5. signed"
    echo ""

    while true; do
        read -p "modo: " mode
        if [[ "$mode" == "name" || "$mode" == "content" || "$mode" == "checksum" || "$mode" == "encrypted" || "$mode" == "signed" ]]; then
            break
        else
            echo "Opción inválida. Intenta de nuevo..."
        fi
    done

    echo "Opción válida."

    echo ""

    echo "  Escoja las dimensiones con las que guste jugar:"
    echo "  --> Este es un gran indicativo de la dificultad ademas del modo..."

    while true; do
        read -p "Ingrese la profundidad (depth): " depth
        if [[ "$depth" =~ ^[0-9]+$ && "$depth" -gt 0 ]]; then
            break
        else
            echo "Entrada inválida. Intente de nuevo con un número positivo."
        fi
    done

    while true; do
        read -p "Ingrese el ancho (width): " width
        if [[ "$width" =~ ^[0-9]+$ && "$width" -gt 0 ]]; then
            break
        else
            echo "Entrada inválida. Intente de nuevo con un número positivo."
        fi
    done

    while true; do
        read -p "Ingrese la cantidad de archivos (files): " files
        if [[ "$files" =~ ^[0-9]+$ && "$files" -gt 0 ]]; then
            break
        else
            echo "Entrada inválida. Intente de nuevo con un número positivo."
        fi
    done

    echo ""
    echo ""

    echo "Buen trabajo. Inicializando juego..."

    # Setting game 
    y="game_board"
    clean_board $y
    dir="game_board"
    create_board $dir $depth $width $files
    fill_board "$dir" "$mode"
    key=$(place_treasure "$y" "$mode")

    echo ""
    echo "El tesoro ya ha sido escondido, ahora a buscarlo..."
    echo ""
    case $mode in
        "name"|"content"|"checksum")
            while true; do
                echo "aclaracion: se espera solo el resultado, como difiere de cada uno"
                read -p "Sabes donde esta el tesoro?: " x
                if [[ $(verify "$mode" "$key" "$x") -eq 1 ]]; then
                    echo "Felicidades, encontraste el tesoro!!!"
                    break
                else 
                    echo "Womp Womp, intenta nuevamente."
                fi
            done
            ;;
        "encrypted"|"signed")
            while true; do
                echo "pista: la contrasena es el curso (o +1)"
                echo "aclaracion: se espera algo como:contrasena_direccion"
                echo "separados por un espacio"
                read -p "Sabes cual es el tesoro?: " x
                if [[ $(verify "$mode" "$key" "$x") -eq 1 ]]; then
                    echo "Felicidades, encontraste el tesoro!!!"
                    break
                else 
                    echo "Womp Womp, intenta nuevamente."
                fi
            done
            ;;    
    esac

}
game 