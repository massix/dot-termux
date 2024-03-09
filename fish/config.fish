set -U fish_greeting

if status is-interactive
  abbr -a g git
  abbr -a j just
  abbr -a mk make

  # pkg
  abbr -a pi pkg install
  abbr -a pu pkg update
  abbr -a puu "pkg update && pkg upgrade"

  # zellij
  abbr -a zj zellij
  abbr -a zja zellij attach
  abbr -a zjd zellij delete-session
  abbr -a zjda zellij delete-all-sessions

  # Set environment variables
  set -x PAGER "bat"
  set -x EDITOR "nvim"
  set -x LEDGER_FILE "$HOME/org/.hledger.journal"
end

