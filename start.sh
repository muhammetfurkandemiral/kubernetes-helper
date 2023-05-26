#!/bin/bash

# We declare our own realpath function beacuse of there is no realpath function on OSX (really steve?)
realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

usage() {
    cat bin/insider_logo.txt

    echo "Usage: bash start.sh COMMAND"
    echo
    echo "Tool using to preparation for insider projects."
    echo
    echo "Commands:"
    echo "  install                 using for install "
    echo "  update                  using for update "

}

# Loads the dispatch library
export deployer_path=$(realpath .)
. "$deployer_path/bin/dispatcher.sh"

option_help () (
    usage
)

command_install () (
    . "bin/install.sh"
)

command_update () (
    . "bin/update.sh"
)

_empty_call_handler () (
    echo "deployer: '$1' is not a deployer command."
    echo "see 'bash deployer.sh --help'"
    usage
)

_no_arg_handler () {
    usage
}

dispatcher "$@"
