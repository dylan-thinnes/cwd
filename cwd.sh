_head () { 
    echo "`head -n  1 $1`"
}
_tail () { 
    echo "`tail -n +2 $1`"
}

_history () { 
    local HIST="`realpath ${1:-~/.cwd_history}`"
    echo $HIST
}
_history_length () {
    local HIST="`_history $1`"
    if [ -f $HIST ]; then
        echo "$(wc -l < $HIST)"
    else
        echo 0
    fi
}
_history_head () { 
    echo "$(_head `_history $1`)"
}
_history_tail () { 
    echo "$(_tail `_history $1`)"
}

_history_pop () {
    local HEAD=`_history_head $1`
    local TAIL=`_history_tail $1`
    echo -n "$TAIL" > "`_history $1`"
    echo "$HEAD"
}
_history_push () {
    local HIST="`_history $1`"
    local NEWDIR="`realpath ${2:-.}`"
    if [ ! -e $NEWHIST ]; then touch "$HIST"; fi
    local NEWHIST=`cat - "$HIST" <<< "$NEWDIR"`
    echo "$NEWHIST" > "$HIST"
}
_history_clear () {
    rm "`_history $1`"
    touch "`_history $1`"
}

_cwd_broken () {
    HIST="`_history $1`"
    if [ -d $HIST ]; then
        echo "$HIST is a directory, not a file."
        return 0;
    elif [ ! -f $HIST ]; then
        echo "History file $HIST not found."
        return 0;
    fi

    echo "History file $HIST exists."
    return 1;
}

_cwd_empty () {
    if [ ! -s $HIST ]; then
        echo "History file $HIST is empty."
        return 0;
    fi

    return 1;
}

cwdadd () {
    if _cwd_broken $2; then return 1; fi;

    local DIR="$1"
    local HIST="$2"
    _history_push "$HIST" "$DIR"
    echo "$DIR added to history."
}

cwdgo () {
    if _cwd_broken $1; then return 1; fi;
    if _cwd_empty $1; then return 1; fi;

    local DIR="`_history_head $1`"
    if cd "$DIR"; then
        echo "Changed directory to $DIR."
    else
        echo "Failed to change directory."
    fi
}

cwdrem () {
    if _cwd_broken $1; then return 1; fi;
    if _cwd_empty $1; then return 1; fi;

    local N="${2:-0}"
    while [ $N -gt 0 ]; do
        N=$(( N - 1 ))
        X=`_history_pop $1`
    done

    local DIR="`_history_pop $1`"
    echo "$DIR removed from history file."
}

cwdpop () {
    if _cwd_broken $1; then return 1; fi;
    if _cwd_empty $1; then return 1; fi;

    local N="${2:-0}"
    while [ $N -gt 0 ]; do
        N=$(( N - 1 ))
        X=`_history_pop $1`
    done

    local DIR="`_history_pop $1`"
    if cd "$DIR"; then
        echo "Changed directory to $DIR."
    else
        echo "Failed to change directory."
    fi
}

cwdshow () {
    if _cwd_broken $1; then return 1; fi;
    if _cwd_empty $1; then return 1; fi;

    local DIR="`_history_head $1`"
    echo "Top entry of history is $DIR"
}

cwdlist () {
    if _cwd_broken $1; then return 1; fi;
    if _cwd_empty $1; then return 1; fi;

    local DIR="`_history $1`"
    echo "Entries in cwd history are:"
    tee < $DIR
}

cwdclear () {
    if _cwd_broken $1; then return 1; fi

    _history_clear $1
    echo "History file cleared."
}

cwdswap () {
    cwdrem
    cwdadd $1
}
