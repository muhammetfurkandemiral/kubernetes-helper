#!/bin/bash

# We declare our own realpath function beacuse of there is no realpath function on OSX (really steve?)
realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

usage() {
    cat bin/insider_logo.txt

    echo "Usage: bash install.sh COMMAND"
    echo
    echo "Tool using to install packages."
    echo
    echo "Commands:"
    echo "  install                   using for install"
    echo "  update                    using for update"
    echo
    echo "  example ./start.sh install preinstall"
    echo
    echo "  example ./start.sh install all"
    echo
    echo "  example ./start.sh install awscli"
    echo "  example ./start.sh install kubectl"
    echo "  example ./start.sh install k9s"
}

export deployer_path=$(realpath .)
. "$deployer_path/bin/dispatcher.sh"

function preinstall () {
    cd ~
    if [[ "$(uname -s)" == "Linux" ]]; then
        sudo apt install curl
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install curl 
    fi
}

function awscli () {
    cd ~
    mkdir .aws
    if [[ "$(uname -s)" == "Linux" ]]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install --update
    else
        curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
        sudo installer -pkg AWSCLIV2.pkg -target /
    fi
}

function k9s () {
    cd ~
    if [[ "$(uname -s)" == "Linux" ]]; then
        wget https://github.com/derailed/k9s/releases/download/v0.27.3/k9s_Linux_amd64.tar.gz
        tar xfv k9s_Linux_amd64.tar.gz
        sudo chmod +x k9s 
        sudo mv k9s /usr/local/bin
    else
        brew install k9s
    fi
}

function kubectl () {
    cd ~
    if [[ "$(uname -s)" == "Linux" ]]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo chmod +x kubectl 
        sudo mv kubectl /usr/local/bin/kubectl
    else
        curl -LO "https://dl.k8s.io/release/v1.25.3/bin/darwin/arm64/kubectl"
        sudo chmod +x kubectl 
        sudo mv kubectl /usr/local/bin/kubectl
    fi
}

command_preinstall () {
    preinstall
}

command_awscli () {
    awscli
}

command_k9s () {
    k9s
}

command_kubectl () {
    kubectl
}

command_all () {
    kubectl
    awscli
    k9s
}

_empty_call_handler () (
    echo "deployer: '$1' is not a deployer command."
    echo "see 'bash deployer.sh --help'"
    usage
)

_no_arg_handler () {
    usage
}

dispatcher "$@"
