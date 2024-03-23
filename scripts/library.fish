set backup_dir "$HOME/.backup"

function log
    set -l level $argv[1]
    set -l msg $argv[2]
    set color normal

    switch $level
        case info
            set color green
        case warning
            set color yellow
        case error
            set color red

    end

    echo "[$(date +'%Y-%m-%d %T')]$(set_color $color) $msg$(set_color normal)"
end

function info
    log info $argv
end

function warning
    log warning $argv
end

function error
    log error $argv
end

function backup_file -a src dst
    if not test -d $backup_dir
        info "$backup_dir does not exist, creating it"
        mkdir -p $backup_dir
    end

    info "Moving $src to $dst"
    mv "$src" "$dst"
end

function check_install -a cmd pkg
    if not command -q $cmd
        info "$cmd not installed, installing it"
        pkg install -y $pkg >/dev/null 2>/dev/null
    else
        info "$cmd (package $pkg) already installed"
    end
end

function check_install_npm -a cmd pkg
    if ! type -q npm then
        error "You must install npm first"
        return
    end

    if ! type -q $cmd then
        info "Installing $pkg from npm"
        npm i -g $pkg
    else
        info "$cmd from npm $pkg already installed"
    end
end
