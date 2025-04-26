#!/usr/bin/env fish

# Import common functions and variables
set current_dir (realpath (dirname (status -f)))
source "$current_dir/../scripts/library.fish"

info "Installing Taskwarrior"

check_install task taskwarrior
check_install jq jq

info "Installing configuration file"
test -f ~/.taskrc; and rm ~/.taskrc
ln -s {$current_dir}/taskrc {$HOME}/.taskrc

info "Creating hooks"
test -d ~/.task/hooks; or mkdir -p ~/.task/hooks

for existing in ~/.task/hooks/*
    rm {$existing}
end

for hook in {$current_dir}/hooks/*
    chmod +x {$hook}
    ln -s {$hook} ~/.task/hooks/
end
