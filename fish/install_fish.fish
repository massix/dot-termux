#!/usr/bin/env fish

set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"

set fish_config_root "$HOME/.config/fish"
set fisher_repo "https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions"

function symlink_file
    set -l file "$current_dir/$argv[1]"
    set -l file_name $argv[1]
    set -l dst $fish_config_root/$file_name
    info "Symlinking $file to $dst"

    if test -L $dst
        warning "$dst is a symbolic link"
        set -l points (stat $dst | head -n1 | cut -d ' ' -f6)
        if test $points = $file
            info "$dst already symlinked to $file"
        else
            warning "Removing current link (points to $points)"
            rm $dst
            ln -s $file $dst
        end
    else if test -f $dst
        mkdir -p $backup_dir/fish/functions
        backup_file $dst $backup_dir/fish/$file_name
        ln -s $file $dst
    else
        ln -s $file $dst
    end
end

# fisher is the plugin manager for fish
function download_fisher
    set -l tmpdir (mktemp -d)
    curl -sL $fisher_repo/fisher.fish -o $tmpdir/fisher.fish
    # info "Downloaded fisher to $tmpdir/fisher.fish"
    echo "$tmpdir/fisher.fish"
end

check_install curl curl
check_install rg ripgrep
check_install bat bat
check_install fd fd
check_install fzf fzf
check_install tldr tealdeer
check_install broot broot
check_install age age
check_install uuidgen uuid-utils
check_install eza eza
check_install htop htop
check_install ledger ledger
tldr --update >/dev/null

# Load fisher
source (download_fisher)
info "Downloaded and loaded fisher"

info "Copying base files"
symlink_file ./config.fish
symlink_file ./fish_plugins

info "Copying functions"
mkdir -p $fish_config_root/functions/
symlink_file ./functions/cat.fish
symlink_file ./functions/grep.fish
symlink_file ./functions/find.fish
symlink_file ./functions/decrypt.fish
symlink_file ./functions/encrypt.fish
symlink_file ./functions/ls.fish
symlink_file ./functions/top.fish

info "Finalizing installation"
fisher update >/dev/null

info "Configuring broot"
mkdir -p ~/.config/broot

rm -f ~/.config/broot/conf.hjson
rm -f ~/.config/broot/verbs.hjson
ln -s $current_dir/broot/conf.hjson ~/.config/broot/conf.hjson
ln -s $current_dir/broot/verbs.hjson ~/.config/broot/verbs.hjson
