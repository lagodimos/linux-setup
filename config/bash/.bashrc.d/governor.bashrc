governor () {
    $ESCALATION_TOOL cpupower frequency-set -g $1
}

_governor_completions () {
    if [[ ${#COMP_WORDS[@]} -gt 2 ]]; then
        COMPREPLY=()
    else
        governors=$(cpupower frequency-info --governors | tail -1 | cut -d ':' -f 2-)
        COMPREPLY=($(compgen -W "$governors" -- "${COMP_WORDS[1]}"))
    fi
}

complete -F _governor_completions governor
