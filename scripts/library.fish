set backup_dir "$HOME/.backup"

function log
    set -l level $argv[1]
    set -l msg $argv[2]
    set color normal

    switch $level
        case debug
            set color magenta
        case info
            set color green
        case warning
            set color yellow
        case error
            set color red
    end

    echo "[$(date +'%T')] $(set_color $color)$level$(set_color normal) $msg" >/dev/stderr
end

function debug
    if test -n "$DOT_TERMUX_DEBUG"
        log debug $argv
    end
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
    debug "Backing up $src"
    if not test -d $backup_dir
        info "$backup_dir does not exist, creating it"
        mkdir -p $backup_dir
    end

    info "Moving $src to $dst"
    mv "$src" "$dst"
end

function has_package -d "Checks if a package is installed" -a pkg
    debug "Checking if package $pkg is installed"

    if dpkg -L {$pkg} >/dev/null 2>/dev/null
        echo true
    else
        echo false
    end
end

function check_install -a cmd pkg
    debug "Checking if $cmd is a command, otherwise install $pkg with termux"
    if not command -q $cmd
        info "$cmd not installed, installing it"
        pkg install -y $pkg >/dev/null 2>/dev/null
    else
        debug "$cmd (package $pkg) already installed"
    end
end

function check_install_npm -a cmd pkg
    debug "Check if $cmd is a command, otherwise install $pkg with npm"
    if ! type -q npm
        error "You must install npm first"
        return
    end

    if ! type -q $cmd
        info "Installing $pkg from npm"
        npm i -g $pkg
    else
        debug "$cmd from npm $pkg already installed"
    end
end

function check_install_go -a binary gopkg --description "Install a Go Package"
    debug "Check if $binary is a command, otherwise install $gopkg with go"

    if ! type -q go
        error "You must install go first"
        return
    end

    set -l GO_BIN_PATH (go env GOPATH)/bin
    debug "GO_BIN_PATH=$GO_BIN_PATH"

    if ! test -f {$GO_BIN_PATH}/$binary
        info "Installing $binary from $gopkg in $GO_BIN_PATH"
        go install $gopkg
    else
        debug "$binary (gopkg $gopkg) already installed"
    end
end

function shafile -a input -d "Calculates the sha256 of the file"
    debug "Calculating hash of $(basename $input)" >/dev/stderr

    if not type -q shasum
        error "shasum is not installed, install it first"
        return
    end

    if ! test -f {$input}
        warning "File $input does not exist" >/dev/stderr
        return
    end

    shasum {$input} | cut -d " " -f1
end
