#!/usr/bin/env fish

# Import common functions and variables
set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"
set file_path "$HOME/.config/nvim"

info "Installing nvim"
check_install nvim neovim
check_install gcc clang
check_install rg ripgrep

function symlink
    info symlinking
    ln -s $current_dir $file_path
end

if test -L $file_path
    warning "nvim already set up as a symbolic link"

    # Check if it points to where we want it to point
    set points (stat $file_path | head -n1 | cut -d ' ' -f6)

    if test $points = $current_dir
        info "already pointing here, nothing to do"
    else
        warning "not pointing here, making it point here"
        rm $file_path
        symlink
    end
else if test -d $file_path
    # Backup existing folder
    set -l backup_dest "$backup_dir/nvim-$(date +'%s')"
    backup_file $file_path $backup_dest
    symlink
else
    symlink
end
