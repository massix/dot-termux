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
check_install make make
check_install xmake xmake
check_install lldb-dap lldb
check_install cppcheck cppcheck
check_install npm nodejs
check_install typst typst
check_install typst-lsp typst-lsp
check_install go golang
check_install gopls gopls
check_install dlv delve
check_install gleam gleam
check_install_go gofumpt mvdan.cc/gofumpt@latest
check_install_go golangci-lint github.com/golangci/golangci-lint/cmd/golangci-lint@latest
check_install_go impl github.com/josharian/impl@latest
check_install_npm yaml-language-server yaml-language-server
check_install_npm vscode-json-language-server vscode-langservers-extracted
check_install_npm bash-language-server bash-language-server

info "Installing rebar3 for gleam"
check_install curl curl
curl -sLO https://s3.amazonaws.com/rebar3/rebar3
chmod +x ./rebar3
./rebar3 local install >/dev/null
rm ./rebar3
fish_add_path {$HOME}/.cache/rebar3/bin

info "Patching shebang"
sed -i 's|#!/usr/bin/env|#!/data/data/com.termux/files/usr/bin/env|' {$HOME}/.cache/rebar3/bin/rebar3

info "Done!"
