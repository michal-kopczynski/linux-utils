#!/bin/bash

# Creates new or attaches to existing tmux session with specific name (and location)
# Takes a path (starting from home) to directory or current directory ("ts .") which becomes starting directory of tmux session.
# Last element of the path becomes session name.
# The directory may not exist - in this case it will be created. But parent directories must exist.
# Session are distinguished only by session name - two sessions with the same name cannot exist even if they have different location.
ts() {
    # Extract directory and session name name from the input
    if [ "$1" = "." ]; then
        dir=$(pwd)
    else
        dir=$1
    fi

    session_name="${dir##*/}"
    parent_dir="${dir%/*}"

    echo Directory: $dir
    echo Parent directory: $parent_dir
    echo Session name: $session_name

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

    # Start tmux session with given name, if it doesn't exist
    tmux has-session_name -t "$session_name" 2>/dev/null || tmux new-session -d -s "$session_name" -c "$dir"

    # Attach to tmux session
    tmux attach-session -t "$session_name:1"
}
