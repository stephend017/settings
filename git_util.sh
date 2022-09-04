#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/colors.sh"

function inside_git_repo() {
    echo "$(git rev-parse --is-inside-work-tree 2>/dev/null)" 
}

function git_branch() {
    # arg1 - git status
    echo "$(echo "$1" | grep "On branch" | awk '{print $NF}')"
}

function git_has_untracked_files() {
    # arg1 - git status
    echo "$(echo "$1" | grep "Untracked files" | wc -l)"
}

function git_has_unstaged_files() {
    # arg1 - git status
    echo "$(echo "$1" | grep "Changes not staged for commit" | wc -l)"
}

function git_has_staged_files() {
    # arg1 - git status
    echo "$(echo "$1" | grep "Changes to be committed" | wc -l)"
}

function git_has_committed_files() {
    echo "$(echo "$1" | grep "Your branch is ahead of" | wc -l)"
}

function git_branch_fg_color() {
    # arg1 - git_has_untracked_files
    # arg2 - git_has_unstaged_files
    # arg3 - git_has_staged_files
    # arg4 - git_has_committed_files

    if [[ $1 -gt 0 || $2 -gt 0 ]]; then 
        echo $FG_ERROR
        return
    fi

    if [[ $3 -gt 0 ]]; then 
        echo $FG_WARNING
        return
    fi
        
    echo $FG_SUCCESS
}

function git_branch_bg_color() {
    # arg1 - git_has_untracked_files
    # arg2 - git_has_unstaged_files
    # arg3 - git_has_staged_files
    # arg4 - git_has_committed_files

    if [[ $1 -gt 0 || $2 -gt 0 ]]; then 
        echo $BG_ERROR
        return
    fi

    if [[ $3 -gt 0 ]]; then 
        echo $BG_WARNING
        return
    fi

    echo $BG_SUCCESS
}