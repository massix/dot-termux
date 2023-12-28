# Capture today's note
function orgmode
  set today "$(date +'%Y-%m-%d').org"
  cd ~/org/
  touch $today
  nvim $today
end

