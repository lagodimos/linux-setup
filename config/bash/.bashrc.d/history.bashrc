export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export HISTSIZE=20000
export HISTFILESIZE=20000
HISTCONTROL=ignoreboth
shopt -s histappend

hh () {     # History Search
    command=$(history -w /dev/stdout | fzf --tac)
    read -e -p "${PS1@P}" -i "$command" command

    history -d $((HISTCMD-1))

    if [[ ! -z "$HISTFILE" && ! -z "$command" && ! "$command" == "hh"* ]]; then
        echo $command >> $HISTFILE
    fi

    if [[ ! -z "$STARSHIP_SHELL" ]]; then
        STARSHIP_START_TIME=$(date +%s%3N)
    fi

    eval "$command"
    unset command
}
