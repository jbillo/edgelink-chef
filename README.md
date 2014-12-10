# Overview

This repository contains Chef cookbooks and recipes used in setting up a default general-purpose Ubuntu 14.04 server, meant for SSH, IRC, webhosting and email. 

# Installation Steps

## SSH server and lockdown

We run the distribution's SSH server on port 55022 as well as 8080. Users in the `sudo` group *must* use key authentication.

Because we may switch servers and IPs at any given point, `default['edgelink']['sshd_config']['ListenAddress']` is defined as a node attribute. `edgelink_base::default` will query these addresses and if they are not defined on the system, they get removed from the `node['ssh']['sshd_config']['ListenAddress']`  attributes.

Node attributes:
```
# Contains all the separate ListenAddresses
node['ssh']['sshd_config']['ListenAddress'] = %w{}
```

## Firewall

I hate ufw for various reasons. iptables all the way.



## User accounts

There are several user accounts