#!/usr/bin/env fish

set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"

set -l azure_dir {$HOME}/.azure
set -l k9s_dir {$HOME}/.config/k9s
set -l catppuccin https://github.com/catppuccin
set -x SODIUM_INSTALL system

info "Installing packages"
check_install pip python3
check_install k9s k9s
check_install kubectl kubectl
check_install helm helm
check_install curl curl

# Needed to compile pycrypto
info "Installing azure-cli dependencies"

# If the package was installed before launching this script, then do not
# remove it afterwards, as it means it was installed by the user
set -l prev_rust (has_package rust)
check_install rustc rust
check_install aarch64-linux-android-ld binutils-is-llvm

# Need to install this first
pkg install -y libsodium >/dev/null 2>/dev/null
pip install pynacl >/dev/null

info "Installing azure-cli (this may take a while)"
pip install azure-cli >/dev/null

info "Configuring azure"
mkdir -p {$azure_dir}
rm -f {$azure_dir}/config
ln -s {$current_dir}/azure/config {$azure_dir}/config

info "Configuring k9s"
mkdir -p {$k9s_dir}
rm -f {$k9s_dir}/config.yaml
ln -s {$current_dir}/k9s/config.yaml {$k9s_dir}/config.yaml

info "Installing completion for fish"
k9s completion fish >~/.config/fish/completions/k9s.fish

info "Downloading skins for k9s"
rm -fr {$k9s_dir}/skins
mkdir -p {$k9s_dir}/skins
curl -sL {$catppuccin}/k9s/archive/main.tar.gz | tar xz -C "$k9s_dir/skins" --strip-components=2 k9s-main/dist

# Remove packages used for building azure-cli
info "Cleaning up"
if not $prev_rust
    pkg remove -y rust >/dev/null 2>/dev/null
end

pkg remove -y libsodium >/dev/null 2>/dev/null
pkg remove -y aarch64-linux-android-ld >/dev/null 2>/dev/null
pkg remove -y binutils-is-llvm >/dev/null 2>/dev/null
apt autoremove -y >/dev/null 2>/dev/null
set -e SODIUM_INSTALL
