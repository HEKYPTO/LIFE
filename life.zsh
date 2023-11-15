#!/bin/zsh

# Get terminal dimensions
TERM_WIDTH=$(tput cols)
TERM_HEIGHT=$(tput lines)

# Calculate the grid size based on terminal dimensions
WIDTH=$((TERM_WIDTH))  # Adjust for borders
HEIGHT=$((TERM_HEIGHT - 2))  # Adjust for borders
SLEEP=1

# Calculate the total number of cells in the grid
SIZE=$((WIDTH * HEIGHT))

# Initialize the grid with random values (you can modify this as needed)
initialize_grid() {
    grid=()
    for ((i = 1; i <= SIZE; i++)); do
        if ((RANDOM % 2 == 0)); then
            grid[i]=1  # Alive
        else
            grid[i]=0  # Dead
        fi
    done
}

# Display the current grid
display_grid() {
    clear
    for ((y = 1; y <= HEIGHT; y++)); do
        for ((x = 1; x <= WIDTH; x++)); do
            local index=$((x + (y - 1) * WIDTH))
            if [[ ${grid[index]} -eq 1 ]]; then
                echo -n "█"
            else
                echo -n " "
            fi
        done
        echo
    done
}

# Calculate the next generation of the grid
next_generation() {
    local new_grid=($grid)
    for ((y = 1; y <= HEIGHT; y++)); do
        for ((x = 1; x <= WIDTH; x++)); do
            local index=$((x + (y - 1) * WIDTH))
            local neighbors=0
            for ((dy = -1; dy <= 1; dy++)); do
                for ((dx = -1; dx <= 1; dx++)); do
                    if [[ $dy -eq 0 && $dx -eq 0 ]]; then
                        continue
                    fi
                    local ny=$((y + dy))
                    local nx=$((x + dx))
                    if ((ny >= 1 && ny <= HEIGHT && nx >= 1 && nx <= WIDTH)); then
                        local neighbor_index=$((nx + (ny - 1) * WIDTH))
                        if [[ ${grid[neighbor_index]} -eq 1 ]]; then
                            ((neighbors++))
                        fi
                    fi
                done
            done
            if [[ ${grid[index]} -eq 1 ]]; then
                if ((neighbors < 2 || neighbors > 3)); then
                    new_grid[index]=0
                fi
            else
                if ((neighbors == 3)); then
                    new_grid[index]=1
                fi
            fi
        done
    done
    grid=($new_grid)
}

# Main loop
initialize_grid
while true; do
    display_grid
    next_generation
    sleep $SLEEP
done
