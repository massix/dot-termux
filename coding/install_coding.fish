#!/usr/bin/env fish

# Import common functions and variables
set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"

info "Installing coding goodies"

check_install git git
check_install gcc clang
check_install pkg-config pkg-config
check_install node nodejs
check_install lua-language-server lua-language-server

