# https://superuser.com/questions/91881/invoke-zsh-having-it-run-a-command-and-then-enter-interactive-mode-instead-of
SHELL=/bin/zsh RUN="${1:-echo "No command passed"}" zsh -i -l
