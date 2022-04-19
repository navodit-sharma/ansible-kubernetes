
# Introduction
Ansible playbooks for installing **Kubernetes** on **Onprem/Bare-metal Ubuntu** machines.

## Version matrix
kubernetes | kubeadm | kubectl | kubelet | kubernetes-cni | docker-ce | containerd.io
-----------|---------|---------|---------|----------------|-----------|---------------
1.14.2 | 1.14.2-00 | 1.14.2-00 | 1.14.2-00 | 0.7.5-00 | 5:18.09.6~3-0~ubuntu-bionic | 1.2.5-1
1.14.10 | 1.14.10-00 | 1.14.10-00 | 1.14.10-00 | 0.7.5-00 | 5:19.03.11~3-0~ubuntu-bionic | 1.2.13-2
1.15.12 | 1.15.12-00 | 1.15.12-00 | 1.15.12-00 | 0.7.5-00 | 5:19.03.11~3-0~ubuntu-bionic | 1.2.13-2
1.16.12 | 1.16.12-00 | 1.16.12-00 | 1.16.12-00 | 0.8.6-00 | 5:19.03.11~3-0~ubuntu-bionic | 1.2.13-2
1.17.7 | 1.17.7-01 | 1.17.7-01 | 1.17.7-01 | 0.8.6-00 | 5:19.03.11~3-0~ubuntu-bionic | 1.2.13-2
1.17.9 | 1.17.9-00 | 1.17.9-00 | 1.17.9-00 | 0.8.6-00 | 5:19.03.11~3-0~ubuntu-bionic | 1.2.13-2
## Various components
There are multiple components that can be installed using this playbook altogether or individually. All components are listed below.
- Containerd
- Docker
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
apt update -y
apt install software-properties-common -y
add-apt-repository --yes --update ppa:ansible/ansible
apt install ansible=5.4.0-1ppa~focal
```
### Check with [ _**ansible version**_ ]
```
# sample output

ansible [core 2.12.2]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Mar 15 2022, 12:22:08) [GCC 9.4.0]
  jinja version = 2.10.1
  libyaml = True
```
## Installing Kubernetes
**NOTE :**
- Installation of kubernetes using this ansible role is expected to succeed only on fresh set of VMs where kubernetes is not already present.
- It is recommended to use this playbook for installing kubernetes v1.14.x and newer.

### Steps
1. Set correct properties in configuration files present inside ${path_to_git_repo}/group_vars
2. Create and inventory file for ansible playbook at location ${path_to_git_repo}/hosts. A sample inventory file is available at location ${path_to_git_repo}/hosts.sample
3. Execute below command
```
# From the root of repository
ansible-playbook -i ./hosts install-kubernetes.yaml
```

## List all available ansible tags
```
ansible-playbook -i inventory/sandbox ./install-kubernetes.yaml --list-tags
```
**Output :**
```
playbook: install-kubernetes.yaml

  play #1 (master): Kubernetes master installation	TAGS: [k8s-install,k8s,k8s-master-install]
      TASK TAGS: [docker, k8s, k8s-install, k8s-master-install, os]

  play #2 (minion): Kubernetes minion installation	TAGS: [k8s-minion-install,k8s-install,k8s]
      TASK TAGS: [docker, k8s, k8s-install, k8s-minion-install, os]

  play #3 (minion): Rook-ceph client setup	TAGS: [storage-clientonly,storage]
      TASK TAGS: [storage, storage-clientonly]

  play #4 (master): Rook-ceph server setup	TAGS: [storage-serveronly,storage]
      TASK TAGS: [storage, storage-serveronly]

  play #5 (database): database	TAGS: [database,db]
      TASK TAGS: [client, configure, database, db, dependencies, packages, server, service]

  play #6 (loadbalancer): Loadbalancer installation	TAGS: [haproxy,lb]
      TASK TAGS: [haproxy, lb]
```
## Upgrading Kubernetes
**NOTE :**
- Upgrade is only expected to work when initial installation of kubernetes was done with this same ansible playbook.

### Steps
1. Follow step 1 & 2 from _**Installing Kubernetes**_
2. Run below command
```
ansible-playbook -i ./hosts upgrade-kubernetes.yaml
```

## Installing selective components
It is possible to selectively install certain components while skipping others as per requirements. This is possible using ansible's **tags** feature.
### To install only kubernetes and nothing else
```
ansible-playbook -i ./hosts install-kubernetes.yaml --tags "k8s-only"
```
### To install only kubernetes master
```
ansible-playbook -i ./hosts install-kubernetes.yaml --tags "k8s-master"
```
### To install only kubernetes minion
**NOTE :**
This is useful when you are introducing a new minion into an existing cluster.
```
ansible-playbook -i ./hosts install-kubernetes.yaml --tags "k8s-minion"
```
### To install Storage (rook-ceph) into a kubernetes cluster
```
ansible-playbook -i ./hosts install-kubernetes.yaml --tags "storage"
```
### To install only Loadbalancer
```
ansible-playbook -i ./hosts upgrade-kubernetes.yaml --tags "lb"
```

## TODOs for upcoming releases
- [] Add documentation
- [] Haproxy's ansible role - logging update (logrotate & logs to file)
- [] Finalizing use of /etc/resolv.conf symbolic link
- [] Automatic update of helm client package
- [] Kubectl bash completion
- [] Helm bash completion
- [] kubectx and kubens install
- [] metrics-server
- [] k8s-dashboard
- [] containerd
- [] replace iptables with ufw
- [] postgresql logging update
