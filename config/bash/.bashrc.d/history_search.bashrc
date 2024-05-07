hh () {
    search=$1
    eval $(history -w /dev/stdout | tac | fzf) 
}
