export HISTSIZE=20000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
shopt -s histappend

hh () {     # History Search
    history -d $((HISTCMD-1))

    command=$(cat -n $HISTFILE | tac | sort -uk2 | sort -nk1 | cut -f2- | fzf --tac)

    if [[ -n "$command" ]]; then

        # Allow editing
        read -e -r -p "${PS1@P}" -i "$command" command

        if [[
            -n "$HISTFILE" &&
            -n "$command" &&
            "$command" != "$FUNCNAME" &&
            "$command" != "$FUNCNAME "* &&
            ! (
                ("$HISTCONTROL" == *"ignoreboth"* || "$HISTCONTROL" == *"ignoredups"*) &&
                "$command" == $(tail -1 $HISTFILE)
            )
        ]]; then
            echo "$command" >> $HISTFILE
        fi

        if [[ -n "$STARSHIP_SHELL" ]]; then
            STARSHIP_START_TIME=$(date +%s%3N)
        fi

        eval "$command"
    fi

    unset command
}
