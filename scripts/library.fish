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

function has_package -d "Checks if a package is installed" -a pkg
    if dpkg -L {$pkg} >/dev/null 2>/dev/null
        echo true
    else
        echo false
    end
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
    if ! type -q npm
        error "You must install npm first"
        return
    end

    if ! type -q $cmd
        info "Installing $pkg from npm"
        npm i -g $pkg
    else
        info "$cmd from npm $pkg already installed"
    end
end

function check_install_go -a binary gopkg --description "Install a Go Package"
    if ! type -q go
        error "You must install go first"
        return
    end

    set -l GO_BIN_PATH {$HOME}/go/bin
    if ! type -q $binary and ! test -f {$GO_BIN_PATH}/$binary
        info "Installing $binary from $gopkg in $GO_BIN_PATH"
        go install $gopkg
    else
        info "$binary (gopkg $gopkg) already installed"
    end
end
