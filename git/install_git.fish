#!/usr/bin/env fish

# Import common functions and variables
set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"
set file_path "$HOME/.gitconfig"

function backup_existing
    set -l backup_path "$HOME/.backup/gitconfig"
    if test -f $file_path
        info "Backing up .gitconfig"
        backup_file $file_path $backup_path
    end
end

function link_new
    info "Creating symlink"
    ln -s "$current_dir/.gitconfig" ~/.gitconfig
end

backup_existing
link_new
