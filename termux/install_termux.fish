#!/usr/bin/env fish

# Import common functions and variables
set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"

set termux_dir "$HOME/.termux"
set -l cache_dir "$HOME/.cache/installer"
mkdir -p {$cache_dir}/font

set -l font_url "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Recursive.zip"
set -l font_fn "RecMonoCasualNerdFontMono-Regular.ttf"

check_install curl curl

if test -f {$termux_dir}/termux.properties
    set -l existing_tprop_sha (shafile {$termux_dir}/termux.properties)
    set -l tprop_sha (shafile {$current_dir}/termux.properties)

    if test {$existing_tprop_sha} = {$tprop_sha}
        info "Properties file up to date"
    else
        backup_file {$termux_dir}/termux.properties {$backup_dir}/termux-(date +'%s').properties
        info "Copying termux properties"
        cp {$current_dir}/termux.properties {$termux_dir}/termux.properties
    end
else
    info "Copying termux properties"
    cp {$current_dir}/termux.properties {$termux_dir}/termux.properties
end

info "Downloading font"
curl -sL {$font_url} -o {$cache_dir}/font.zip

info "Unpacking font"
unzip -qq -o -x {$cache_dir}/font.zip -d {$cache_dir}/font/

set -l tf_sha (shafile {$termux_dir}/font.ttf)
set -l newtf_sha (shafile {$cache_dir}/font/{$font_fn})

if test {$tf_sha} = {$newtf_sha}
    info "Already using latest font version"
else
    info "Copying patched font"
    cp {$cache_dir}/font/{$font_fn} {$termux_dir}/font.ttf
end

info "Cleaning cache folder"
rm -rf {$cache_dir}/font/*

if command -q termux-reload-settings
    info "Reloading termux configuration"
    sleep 3
    termux-reload-settings
end
