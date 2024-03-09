#!/usr/bin/env fish

# Import common functions and variables
set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"

set -l config_dir $HOME/.config/zellij

info "Installing zellij"
check_install zellij zellij

info "Copying zellij configuration file"
mkdir -p $config_dir

rm -f $config_dir/config.kdl
ln -s $current_dir/zellij.kdl $config_dir/config.kdl

