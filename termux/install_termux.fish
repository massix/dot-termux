#!/usr/bin/env fish

# Import common functions and variables
set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"

set termux_dir "$HOME/.termux"
set -l cache_dir "$HOME/.cache/installer"
mkdir -p {$cache_dir}/font

set -l font_url "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/0xProto.zip"

check_install curl curl

if test -f {$termux_dir}/termux.properties
    backup_file "$termux_dir/termux.properties" "$backup_dir/termux-$(date +'%s').properties"
end

info "Copying termux properties"
cp {$current_dir}/termux.properties "$termux_dir/termux.properties"

info "Downloading font"
curl -sL "$font_url" -o "$cache_dir/font.zip"

info "Unpacking font"
unzip -qq -o -x "$cache_dir/font.zip" -d "$cache_dir/font/"

info "Copying patched font"
cp {$cache_dir}/font/0xProtoNerdFont-Regular.ttf {$termux_dir}/font.ttf

info "Cleaning cache folder"
rm -rf {$cache_dir}/font/*

if command -q termux-reload-settings
    info "Reloading termux configuration"
    termux-reload-settings
end
