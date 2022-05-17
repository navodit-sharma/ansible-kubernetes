
# Introduction
Ansible playbooks for installing **Kubernetes** on **Onprem/Bare-metal Ubuntu** machines.

## Version matrix -- _**[Deprecated]**_
_**Docker**_ is no longer supported and has been replaced with _**Containerd**_. Check version matrix in next section.
kubernetes | kubeadm | kubectl | kubelet | kubernetes-cni | docker-ce | containerd.io
-----------|---------|---------|---------|----------------|-----------|---------------
1.14.2 | 1.14.2-00 | 1.14.2-00 | 1.14.2-00 | 0.7.5-00 | 5:18.09.6~3-0~ubuntu-bionic | 1.2.5-1
1.14.10 | 1.14.10-00 | 1.14.10-00 | 1.14.10-00 | 0.7.5-00 | 5:19.03.11~3-0~ubuntu-bionic | 1.2.13-2
1.15.12 | 1.15.12-00 | 1.15.12-00 | 1.15.12-00 | 0.7.5-00 | 5:19.03.11~3-0~ubuntu-bionic | 1.2.13-2
1.16.12 | 1.16.12-00 | 1.16.12-00 | 1.16.12-00 | 0.8.6-00 | 5:19.03.11~3-0~ubuntu-bionic | 1.2.13-2
1.17.7 | 1.17.7-01 | 1.17.7-01 | 1.17.7-01 | 0.8.6-00 | 5:19.03.11~3-0~ubuntu-bionic | 1.2.13-2
1.17.9 | 1.17.9-00 | 1.17.9-00 | 1.17.9-00 | 0.8.6-00 | 5:19.03.11~3-0~ubuntu-bionic | 1.2.13-2

## Version matrix
Kubernetes | Kubeadm/Kubelet/Kubectl | Containerd
-----------|-----------|-----------|
1.21.12 | 1.21.12-00 | 1.5.11-1 |
1.22.9 | 1.22.9-00 | 1.5.11-1 |
## Various components
There are multiple components that can be installed using this playbook altogether or individually. All components are listed below.
- Containerd
- Docker _**[Deprecated]**_
- Haproxy
- Helm v3
- Kubernetes
- kubernetes dashboard (Kubernetes required)
- metrics-server (Kubernetes required)
- Postgresql v11
- Rook-ceph storage cluster (Kubernetes required)

## Pre-requisites
Please read information provided within following link --> https://dev.azure.com/valamis/KirklandEllis/_wiki/wikis/KirklandEllis.wiki/137/Installation. Important topics are :
- Configuration / Requirement of each VM
- Networking
- Port(s) / Service(s) to open
- Hostnames
- Service provisioning

## Installing Ansible
### Install
```
# Ubuntu
apt update -y
apt install software-properties-common -y
add-apt-repository --yes --update ppa:ansible/ansible
apt install ansible=5.7.1-1ppa~focal

# Mac - This will install the latest available ansible version - 5.7.1 at the time of writing this document
brew install ansible
```
### Check with [ _**ansible --version**_ ]
```
# sample output
# Ansible 5.7.1 includes 'ansible core v2.12.1' at the time of writing this document

ansible [core 2.12.1]
  config file = None
  configured module search path = ['/Users/navodit/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/Cellar/ansible/5.1.0/libexec/lib/python3.10/site-packages/ansible
  ansible collection location = /Users/navodit/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.10.1 (main, Dec  6 2021, 23:20:29) [Clang 13.0.0 (clang-1300.0.29.3)]
  jinja version = 3.0.3
  libyaml = True
```
## Installing Kubernetes
**NOTE :**
- Installation of kubernetes using this ansible role is expected to succeed only on fresh set of VMs where kubernetes is not already present.
- It is recommended to use this playbook for installing kubernetes v1.14.x and newer.

### Steps
1. Set correct properties in configuration files present inside _**inventory/group_vars**_ ex. _**inventory/group_vars/valpaas**_.
2. Create and inventory file for ansible playbook _**inventory**_ directory ex. _**inventory/valpaas**_.
3. Execute below command
```
# From the root of repository
ansible-playbook -i inventory/valpaas install-kubernetes.yaml
```
Upon successful execution you should have a working kubernetes cluster.
## Upgrading Kubernetes
**NOTE :**
- Upgrade is only expected to work when initial installation of kubernetes was done with this same ansible playbook.
### Steps
1. Follow step 1 & 2 from _**Installing Kubernetes**_
2. Run below command
```
ansible-playbook -i inventory/valpaas upgrade-kubernetes.yaml
```
Upon successful execution you should have a working kubernetes cluster.
## List all available ansible tags
```
ansible-playbook -i inventory/valpaas install-kubernetes.yaml --list-tags
```
**Output :**
```
playbook: install-kubernetes.yaml

  play #1 (all): Initial OS setup	TAGS: [os,os-setup]
      TASK TAGS: [feature/firewall, os, os-setup]

  play #2 (master,minion): Install containerd	TAGS: [container-runtime,containerd]
      TASK TAGS: [container-runtime, containerd, nerdctl]

  play #3 (master): Kubernetes master installation	TAGS: [k8s-master-install,k8s,k8s-install]
      TASK TAGS: [feature/firewall, feature/kubelet-csr-approver, feature/weave-sdn, k8s, k8s-install, k8s-master-install]

  play #4 (minion): Kubernetes minion installation	TAGS: [k8s,k8s-install,k8s-minion-install]
      TASK TAGS: [feature/firewall, feature/kubelet-csr-approver, feature/weave-sdn, k8s, k8s-install, k8s-minion-install]

  play #5 (master): Kubernetes addons installation	TAGS: [kubernetes-addons]
      TASK TAGS: [addon/cert-manager, addon/helm, addon/kubernetes-dashboard, addon/metrics-server, addon/volume-snapshot-controller, kubernetes-addons]

  play #6 (master): Rook-ceph server setup	TAGS: [storage]
      TASK TAGS: [rook/helm-config-only, storage]
```

You can also check tags of individual plabooks which are in _**playbooks**_ directory as below
```
ansible-playbook -i inventory/valpaas playbooks/containerd.yaml --list-tags

# OR

ansible-playbook -i inventory/valpaas playbooks/* --list-tags
```
## Installing selective components
It is possible to selectively install certain components while skipping others using ansible tags feature.
### To install only kubernetes and nothing else
```
# NOTE : This assumes you have already installed dependencies like containerd on all machines in question
ansible-playbook -i inventory/valpaas install-kubernetes.yaml --tags "k8s"
```
### To install only kubernetes master
```
ansible-playbook -i inventory/valpaas install-kubernetes.yaml --tags "k8s-master-install"
```
### To install only kubernetes minion
**NOTE :**
This is useful when you are introducing a new minion into an existing cluster.
```
ansible-playbook -i inventory/valpaas install-kubernetes.yaml --tags "k8s-minion-install"
```
### To install Storage (rook-ceph) into a kubernetes cluster
```
ansible-playbook -i inventory/valpaas install-kubernetes.yaml --tags "storage"
```
### To install only Loadbalancer
```
ansible-playbook -i inventory/valpaas upgrade-kubernetes.yaml --tags "lb"
```
It is also possible to use individual playbooks if needed. Below are some examples.
```
# To execute entire storage playbook and install everything
ansible-playbook -i inventory/valpaas playbooks/rook.yaml

# List tags available in storage playbook
ansible-playbook -i inventory/valpaas playbooks/rook.yaml --list-tags
playbook: playbooks/rook.yaml
  play #1 (master): Rook-ceph server setup	TAGS: [storage]
      TASK TAGS: [rook/helm-config-only, storage]

# To execute selective parts of storage playbook
ansible-playbook -i inventory/valpaas playbooks/rook.yaml --tags "rook/helm-config-only"
```
## Current release contains
- [x] Finalizing use of /etc/resolv.conf symbolic link
- [x] Automatic update of helm client package
- [x] Kubectl bash completion
- [x] Helm bash completion
- [x] kubectx and kubens install
- [x] metrics-server
- [x] k8s-dashboard
- [x] docker replaced with containerd
- [x] replace iptables with ufw
- [x] kube-proxy using IPVS mode instead of proxy mode
- [x] Update Readme
## TODOs for upcoming release
- [] postgresql logging update
- [] Haproxy's ansible role - logging update (logrotate & logs to file)
