#!/usr/bin/env fish

# Import common functions and variables
set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"

set termux_dir "$HOME/.termux"

if test -f $termux_dir/termux.properties
  backup_file "$termux_dir/termux.properties" "$backup_dir/termux-$(date +'%s').properties"
end

info "Copying termux properties"
cp $current_dir/termux.properties "$termux_dir/termux.properties"

info "Copying patched font"
cp $current_dir/font.ttf "$termux_dir/font.ttf"

if command -q termux-reload-settings
  info "Reloading termux configuration"
  termux-reload-settings
end

