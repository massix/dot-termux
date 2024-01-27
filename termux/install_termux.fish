#!/usr/bin/env fish

# Import common functions and variables
set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"

set termux_dir "$HOME/.termux"
set -l cache_dir "$HOME/.cache/installer"
mkdir -p $cache_dir

set -l font_url "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Agave.zip"
check_install curl curl

if test -f $termux_dir/termux.properties
  backup_file "$termux_dir/termux.properties" "$backup_dir/termux-$(date +'%s').properties"
end

info "Copying termux properties"
cp $current_dir/termux.properties "$termux_dir/termux.properties"

if ! test -f "$cache_dir/font.zip"
  info "Downloading font"
  curl -sL "$font_url" -o "$cache_dir/font.zip"
end

info "Unpacking font"
unzip -qq -o -x "$cache_dir/font.zip" -d "$cache_dir"

info "Copying patched font"
cp $cache_dir/*Mono-Regular.ttf $termux_dir/font.ttf

info "Cleaning cache folder"
rm -f $cache_dir/*.ttf
rm -f $cache_dir/*.md
rm -f $cache_dir/LICENSE*
rm -f $cache_dir/*.txt

if command -q termux-reload-settings
  info "Reloading termux configuration"
  termux-reload-settings
end

