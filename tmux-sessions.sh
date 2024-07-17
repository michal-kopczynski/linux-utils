#!/bin/bash

ts() {
    # Extract directory path and session_name name from the input
#    session_name=1
    #dir="${1%/*}"
    #name="${1##*/}"

    if [ "$1" = "." ]; then
        dir=$(pwd)
        #name=$(basename "$(dirname "$dir")")
    else
        dir=$1
    fi

    session_name="${dir##*/}"
    parent_dir="${dir%/*}"

    echo $dir
    echo $parent_dir
    echo $session_name

    # If parent directory doesn't exist, exit with error
    if [ ! -d "$parent_dir" ]; then
        echo "Parent directory $parent_dir does not exist"
        return 1
    fi

    # If directory doesn't exist, create folder
    if [ ! -d "$dir" ]; then
        echo "Directory $dir for session $session_name does not exist, creating"
        mkdir -p $dir
    fi

    # Start tmux session_name with given name, if it doesn't exist
    tmux has-session_name -t "$session_name" 2>/dev/null || tmux new-session -d -s "$session_name" -c "$dir"

    # Create a new window in the tmux session_name with a nvim
    #tmux new-window -t "$session_name" -c "$dir" \; send-keys -t "$session_name:1" "nvim $dir" Enter

    # Create a new window in the tmux session_name with a terminal
    #tmux new-window -t "$session_name" -c "$dir"

    #tmux -t "$session_name" select-window -t 1
    
    # Attach to tmux session_name and open nvim in the specified directory
    tmux attach-session -t "$session_name:1"

    #tmux attach-session -t "$session_name" \; send-keys "nvim $dir" Enter
}
