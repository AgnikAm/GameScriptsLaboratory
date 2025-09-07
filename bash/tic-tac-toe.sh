#!/bin/bash

save_file="save.txt"
mode="player_vs_player"  # Default game mode

draw_board() {
    clear
    echo " ${board[0]} | ${board[1]} | ${board[2]} "
    echo "---+---+---"
    echo " ${board[3]} | ${board[4]} | ${board[5]} "
    echo "---+---+---"
    echo " ${board[6]} | ${board[7]} | ${board[8]} "

    if [[ -n "$winner" ]]; then
        echo "$winner has won! Type 'q' to quit."
    elif [[ "$game_over" == true ]]; then
        echo "It's a draw! Type 'q' to quit."
    fi
}

check_winner() {
    local win_combos=(
        "0 1 2" "3 4 5" "6 7 8"
        "0 3 6" "1 4 7" "2 5 8"
        "0 4 8" "2 4 6"
    )
    
    for combo in "${win_combos[@]}"; do
        set -- $combo
        if [[ "${board[$1]}" != " " && "${board[$1]}" == "${board[$2]}" && "${board[$1]}" == "${board[$3]}" ]]; then
            winner=$player
            game_over=true
            return
        fi
    done

    local is_draw=true
    for cell in "${board[@]}"; do
        if [[ "$cell" == " " ]]; then
            is_draw=false
            break
        fi
    done

    if [[ "$is_draw" == true && -z "$winner" ]]; then
        game_over=true
    fi
}

player_move() {
    local position
    while true; do
        echo "Player $player, choose a position (1-9), 'q' to quit, or 's' to save:"
        read -r position

        if [[ "$position" == "q" ]]; then
            echo "Game ended."
            exit 0
        elif [[ "$position" == "s" ]]; then
            save_game
            continue
        fi

        position=$((position - 1))

        if [[ $position =~ ^[0-8]$ ]] && [[ "${board[$position]}" == " " ]]; then
            board[$position]=$player
            break
        else
            echo "Invalid move, try again."
        fi
    done
}

computer_move() {
    echo "Computer ($player) is making a move..."
    sleep 1

    local opponent=$( [[ "$player" == "X" ]] && echo "O" || echo "X" )

    for i in "${!board[@]}"; do
        if [[ "${board[$i]}" == " " ]]; then
            board[$i]=$player
            check_winner
            if [[ "$winner" == "$player" ]]; then
                return  # Play the winning move
            fi
            board[$i]=" "
            winner=""
            game_over=false
        fi
    done

    local preferred_moves=(4 0 2 6 8 1 3 5 7)
    for i in "${preferred_moves[@]}"; do
        if [[ "${board[$i]}" == " " ]]; then
            board[$i]=$player
            return
        fi
    done
}

make_move() {
    if [[ "$game_over" == true ]]; then
        echo "Game over. Type 'q' to exit."
        read -r position
        if [[ "$position" == "q" ]]; then
            exit 0
        fi
        return
    fi

    if [[ "$mode" == "player_vs_computer" && "$player" == "O" ]]; then
        computer_move
    else
        player_move
    fi

    check_winner

    if [[ "$game_over" == false ]]; then
        player=$( [[ "$player" == "X" ]] && echo "O" || echo "X" )
    fi
}

save_game() {
    echo "Saving the game..."
    local saved_board=("${board[@]}")
    for i in "${!saved_board[@]}"; do
        [[ "${saved_board[$i]}" == " " ]] && saved_board[$i]="."
    done
    echo "${saved_board[*]}" > "$save_file"
    echo "$player" >> "$save_file"
    echo "$game_over" >> "$save_file"
    echo "$winner" >> "$save_file"
    echo "$mode" >> "$save_file"
}

load_game() {
    if [[ -f "$save_file" ]]; then
        echo "Loading saved game..."
        mapfile -t lines < "$save_file"
        read -r -a board <<< "${lines[0]}"
        for i in "${!board[@]}"; do
            [[ "${board[$i]}" == "." ]] && board[$i]=" "
        done
        player="${lines[1]}"
        game_over="${lines[2]}"
        winner="${lines[3]}"
        mode="${lines[4]}"
        [[ "$game_over" == "true" ]] && game_over=true || game_over=false
        [[ "$winner" != "X" && "$winner" != "O" ]] && winner=""
    else
        echo "No saved game found."
        return 1
    fi
}

echo "1. New player vs. player game"
echo "2. Load saved player vs. player game"
echo "3. New player vs. computer game"
echo "Choose an option (1-3):"
read -r choice

if [[ "$choice" == "2" ]]; then
    load_game || {
        echo "Starting new game..."
        board=(" " " " " " " " " " " " " " " " " ")
        player="X"
        winner=""
        game_over=false
        mode="player_vs_player"
    }
elif [[ "$choice" == "3" ]]; then
    board=(" " " " " " " " " " " " " " " " " ")
    player="X"
    winner=""
    game_over=false
    mode="player_vs_computer"
else
    board=(" " " " " " " " " " " " " " " " " ")
    player="X"
    winner=""
    game_over=false
    mode="player_vs_player"
fi

while true; do
    draw_board
    make_move
done
