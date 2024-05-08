export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
HISTCONTROL=ignoreboth
shopt -s histappend

hh () {     # History Search
    command=$(history -w /dev/stdout | fzf --tac)
    read -e -p "${PS1@P}" -i "$command" command

    if [[ ! -z "$STARSHIP_SHELL" ]]; then
        STARSHIP_START_TIME=$(date +%s%3N)
    fi

    eval "$command"
    unset command
}
