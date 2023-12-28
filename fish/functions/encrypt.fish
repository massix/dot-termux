function encrypt --description "Encrypt file using the default age key"
  set -l to_encrypt $argv[1]
  set -l dest $argv[2]

  if not test -f $to_encrypt
    echo "File $to_encrypt does not exist" > /dev/stderr
    return 1
  end

  if test -z $dest
    echo "Destination cannot be an empty string" > /dev/stderr
    return 1
  end

  if not command -q age
    pkg install -y age > /dev/null
  end

  age -e --armor -i $HOME/.age/key.txt -o $dest $to_encrypt
end

