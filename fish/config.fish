set -U fish_greeting

if status is-interactive
  # git
  abbr -a g git

  # just
  abbr -a j just

  # pkg
  abbr -a pi pkg install
  abbr -a pu pkg update
  abbr -a puu "pkg update && pkg upgrade"

  # Set environment variables
  set -x PAGER "bat"
  set -x EDITOR "nvim"
end

