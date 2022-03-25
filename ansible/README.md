
# Introduction
Ansible project for installing kubernetes on Onprem Ubuntu servers.

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
- Kubernetes
- Rook-ceph storage cluster (Kubernetes required)
- Helm v2 (Kubernetes required)
- Postgresql v11
- Elasticsearch (Part of Centralized logging stack)
- Kibana (Part of Centralized logging stack)
- Fluentd (Kubernetes required) (Part of Centralized logging stack)
- Prometheus (Part of Monitoring stack)
- Grafana (Part of Monitoring stack)
- Nginx (Part of Monitoring & Centralized logging stack)
- Haproxy

## Pre-requisites
Please read information provided within following link --> https://dev.azure.com/valamis/KirklandEllis/_wiki/wikis/KirklandEllis.wiki/137/Installation. Important topics are :
- Configuration / Requirement of each VM
- Networking
- Port(s) / Service(s) to open
- Hostnames
- Service provisioning

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

## TODO
- [x] Update README
- [x] Add kubectl bash auto-complete script
- [x] Haproxy's ansible role
- [x] Finalizing use of /etc/resolv.conf symbolic link
- [ ] Automatic update of kubectl client package
- [ ] Kubectl bash completion
- [ ] Automatic update of helm client package
- [ ] Helm bash completion
- [ ] Postgresql : ability to add users and roles
- [ ] Postgresql : Master-slave configuration (possibly with HA features)
