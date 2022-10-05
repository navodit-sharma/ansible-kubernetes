# Change Log
---
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [ Upcoming changes ]
---
## [x.y.z]
### [ Added / changed / fixed / removed ]
- Postgresql logging and log rotation
- Haproxy logging and log rotation
## [ Released ]
---
## [1.0.1]
### Changed
Versions changed / updated :
- Helm v3.8.2

Other changes :
- Helm is now installed from official helm tar ball instead of snap. Auto-patches are no longer supported.
### Fixed
- Kubernetes kube-proxy firewall rule's protocol changed from udp to tcp.
## [1.0.0]
### Added
Ansible playbooks & modules for setting up kubernetes cluster and other infra services required on an Onprem environment. This entire playbook was verified against _**Ubuntu 20.04 LTS**_.

Ansible roles added for following services :
- Kubernetes v1.22.9
- Containerd v1.5.11 [_**Default**_ : container runtime for kubernetes cluster]
- Helm v3.7.0+ (Auto updates patch version through snap)
- Docker v19.03.0+ [_**Deprecated**_ : It will be removed completely in next minor release]
- Kubernetes addons like
    - metrics-server
    - kubernetes dashboard
    - volume-snapshot-controller
    - cert-manager v1.8.0
    - weave (SDN)
- Kubectx & kubens v0.9.4
- Rook v1.9.1
- Postgresql v11
- Haproxy (Latest : stable)
- OS-SETUP role performs following main tasks
  - Disable IPV6
  - Updates & upgrades OS packages [_**Optional**_]
  - Enable automatic security updates
  - Install & configure NTP service on all nodes
  - Add rules to firewall (UFW)
  - Install necessary OS packages
