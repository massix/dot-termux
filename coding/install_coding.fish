#!/usr/bin/env fish

function check_install_npm
  set -l cmd $argv[1]
  set -l pkg $argv[2]

  if ! type -q $cmd then
    info "Installing $pkg from npm"
    npm i -g $pkg
  else
    info "$cmd already installed"
  end
end

# Import common functions and variables
set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"

info "Installing coding goodies"

check_install git git
check_install gcc clang
check_install pkg-config pkg-config
check_install node nodejs
check_install lua-language-server lua-language-server
check_install make make
check_install xmake xmake
check_install npm nodejs
check_install lldb-vscode lldb
check_install_npm yaml-language-server yaml-language-server
check_install_npm vscode-json-language-server vscode-langservers-extracted
check_install_npm bash-language-server bash-language-server

