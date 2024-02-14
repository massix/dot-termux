set -U fish_greeting

if status is-interactive
  abbr -a g git
  abbr -a j just
  abbr -a mk make

  # pkg
  abbr -a pi pkg install
  abbr -a pu pkg update
  abbr -a puu "pkg update && pkg upgrade"

  # Set environment variables
  set -x PAGER "bat"
  set -x EDITOR "nvim"
end

