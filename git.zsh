#!/usr/bin/env zsh

# Git worktree remove with .agent directory merge
gwtr() {
    local worktree_path="$1"

    if [[ -z "$worktree_path" ]]; then
        echo "Usage: gwtr <worktree-path>"
        return 1
    fi

    # Get absolute path
    worktree_path=$(realpath "$worktree_path" 2>/dev/null || echo "$worktree_path")

    if [[ ! -d "$worktree_path" ]]; then
        echo "Error: Worktree path does not exist: $worktree_path"
        return 1
    fi

    # Check if it's a git worktree
    if ! git -C "$worktree_path" rev-parse --is-inside-work-tree &>/dev/null; then
        echo "Error: Not a git worktree: $worktree_path"
        return 1
    fi

    # Get the main worktree (parent repository) path
    local main_worktree=$(git -C "$worktree_path" worktree list | head -1 | awk '{print $1}')

    if [[ -z "$main_worktree" ]]; then
        echo "Error: Could not determine main worktree path"
        return 1
    fi

    # Check if .agent directory exists in the worktree
    if [[ -d "$worktree_path/.agent" ]]; then
        echo "Found .agent directory in worktree"

        # Create .agent directory in main worktree if it doesn't exist
        if [[ ! -d "$main_worktree/.agent" ]]; then
            echo "Creating .agent directory in main worktree"
            mkdir -p "$main_worktree/.agent"
        fi

        # Merge .agent directory using rsync
        echo "Merging .agent directory from worktree to main repository..."
        rsync -av --update --progress "$worktree_path/.agent/" "$main_worktree/.agent/"

        if [[ $? -eq 0 ]]; then
            echo "Successfully merged .agent directory"
        else
            echo "Warning: rsync merge had some issues, but continuing with worktree removal"
        fi
    else
        echo "No .agent directory found in worktree, skipping merge"
    fi

    # Remove the worktree
    echo "Removing worktree: $worktree_path"
    git worktree remove "$worktree_path"

    if [[ $? -eq 0 ]]; then
        echo "Successfully removed worktree"
    else
        echo "Error: Failed to remove worktree"
        return 1
    fi
}

# Git worktree add with optional branch creation
gwta() {
    local path="$1"
    local branch="$2"

    if [[ -z "$path" ]]; then
        echo "Usage: gwta <path> [branch]"
        return 1
    fi

    if [[ -z "$branch" ]]; then
        # Use path basename as branch name
        branch=$(basename "$path")
    fi

    # Check if branch exists
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        echo "Adding worktree for existing branch: $branch"
        git worktree add "$path" "$branch"
    else
        echo "Creating new branch and adding worktree: $branch"
        git worktree add -b "$branch" "$path"
    fi
}

# List all worktrees
gwtl() {
    git worktree list
}

# Prune worktree information
gwtp() {
    git worktree prune
    echo "Pruned worktree information"
}