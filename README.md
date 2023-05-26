# Kubernetes Helper

Kubernetes Helper is a project install all required services and update aws crendentials for Insider.
Let's dive into it!
[![-----------------------------------------------------](
https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](https://github.com/muhammetfurkandemiral?tab=repositories)

### Requirements

- Terminal

### How to clone / install Kubernetes Helper

Open your terminal, go to your favorite directory for projects, type  
`git clone https://github.com/muhammetfurkandemiral/kubernetes-helper.git`  
and hit enter. Kubernetes Helper will be cloned current directory.

After cloning, open Kubernetes Helper project with terminal
From this point you can run scripts, but you need
one more thing, described in next step.
<hr>

## How to use
Making the installations

### Install

> **Information**
>
> For Mac devices:
> Please do not use ***sudo*** notation when using the ./start.sh install commands.
>
> For example: ```./start.sh install preinstall```

Firstly, it needs to be pre install.
```bash
sudo ./start.sh install preinstall
```

If you do not have awscli, kubectl and k9s installed on your computer before, you can do all the installations at once with this option.

```bash
sudo ./start.sh install all
```

If you have some of these, you can install them one by one from here.
```bash
sudo ./start.sh install awscli
sudo ./start.sh install kubectl
sudo ./start.sh install k9s
```
<hr>

### Update
Update options

After doing update, you need a vpn connection to see the pods, so you can test vpn connection using this command.
```bash
./start.sh update vpncheck
```

Now it's time for the command we will use the most.

Here, you can use this command by typing your task id and the keys that Vision Bot gives you, as in the example.

After running this command, we are now connected to our namespace.
You can start the test.
```bash
sudo ./start.sh update awscred taskid accesskeyid secretaccesskey
```

And finally, if you want to clean your aws keys, you can use this command.
> **Warning :**
> Note this command will delete all saved keys!
```bash
./start.sh update delete_aws_keys
```
