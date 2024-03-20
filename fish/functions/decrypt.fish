function decrypt --description "Decrypt file using the default age key"
    set -l to_decrypt $argv[1]
    set -l dest $argv[2]

    if not test -f $to_decrypt
        echo "File $to_decrypt does not exist" >/dev/stderr
        return 1
    end

    if test -z $dest
        echo "Destination cannot be an empty string" >/dev/stderr
        return 1
    end

    if not command -q age
        pkg install -y age >/dev/null
    end

    age -d -i $HOME/.age/key.txt -o $dest $to_decrypt
end
