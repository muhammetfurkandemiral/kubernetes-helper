#!/bin/bash

# We declare our own realpath function beacuse of there is no realpath function on OSX (really steve?)
realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

usage() {
    cat bin/insider_logo.txt

    echo "Usage: bash update.sh COMMAND"
    echo
    echo "You have to turn on the VPN!"
    echo "Tool using to update aws credentials."
    echo
    echo "Commands:"
    echo "  install                   using for install"
    echo "  update                    using for update"
    echo
    echo "  example ./start.sh update vpncheck"
    echo "  example ./start.sh update awscred taskid accesskeyid secretaccesskey"

}

VPN_IP="YOUR_COMPANY_SECURE_IP"
BRed='\033[1;31m'
BGreen='\033[1;32m'
Default='\033[0;37m'

task_id="${2%.text}"           
access_key_id="${3%.text}"
secret_access_key="${4%.text}"

export deployer_path=$(realpath .)
. "$deployer_path/bin/dispatcher.sh"


function awscred () {
    vpncheck
    params_control
    cd ~
    aws configure set aws_access_key_id "$access_key_id" --profile $task_id 
    aws configure set aws_secret_access_key "$secret_access_key" --profile $task_id 
    aws configure set region "" --profile $task_id 
    aws configure set output "" --profile $task_id
    kubeconf
    echo -e "${BGreen}" 
    kubectl get pods -n $task_id
}

function kubeconf () {
    cd ~
    aws eks --region us-east-1 update-kubeconfig --name eks-qa --profile $task_id
    kubectl config set-context --current --namespace $task_id
}

function delete_aws_keys () {
    echo -e -n "${BRed} All aws keys will be deleted! Do you want to continue? [y/n]"
    read -r ans
    if [ $ans == "y" ];then
        > ~/.aws/credentials
        echo -e "${BGreen} Cleaned! ${Default}" 
    else
        echo -e "${BRed} Process canceled! ${Default}"
    fi
}

function vpncheck () {
    if [ "$(curl ifconfig.me)" = "$VPN_IP" ]; then
        echo -e "${BGreen} VPN connection available! ${Default}"
    else 
        echo -e "\n${BRed}You have to turn on the VPN! ${Default}"
        "_no_arg_handler"
        exit 0
    fi
}

function params_control () {
    if [ -z "$task_id" ]; then
        "_no_arg_handler"
        exit 0
    elif [ -z "$access_key_id" ]; then
        "_no_arg_handler"
        exit 0
    elif [ -z "$secret_access_key" ]; then
        "_no_arg_handler"
        exit 0
    fi
}

command_awscred () {
    awscred
}

command_kubeconf () {
    kubeconf
}

command_delete_aws_keys () {
    delete_aws_keys
}

command_vpncheck () {
    vpncheck
}

command_params_control () {
    params_control
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
