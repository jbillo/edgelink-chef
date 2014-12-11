# Overview

This repository contains Chef cookbooks and recipes used in setting up a default general-purpose Ubuntu 14.04 server, meant for SSH, IRC, webhosting and email. Chances are if you're reading this document, you're probably not one of the brute-forcing script kiddies or bots that regularly try and attack our boxes, so I don't care about telling you which ports we're listening on; you could nmap us anyway. If you do notice a security problem, though, I'd appreciate hearing about it and given a chance to fix the issue.

# Standard Configuration

## SSH server and lockdown

We run the distribution's SSH server on port 55022 as well as 8080. Users in the `sudo` and `admin` group *must* use key authentication.

Because we may switch servers and IPs at any given point, `default['edgelink']['sshd_config']['ListenAddress']` is defined as a node attribute. `edgelink_base::default` will query these addresses and if they are not defined on the system, they get removed from the `node['ssh']['sshd_config']['ListenAddress']`  attributes. We also happen to convert this to a Hash to work around <https://github.com/chr4-cookbooks/sshd/issues/8>.

Node attributes that are not set in this Git repository:
```
# Contains all the separate ListenAddresses
node['edgelink']['sshd_config']['ListenAddress'] = []
```

## Firewall

I hate ufw for various reasons. iptables all the way. My wonderful employer has taken over maintenance of the `simple_iptables` cookbook, which saves everyone a lot of time and irritation.

We do take a list of the `Port`s defined in `node['sshd']['sshd_config']['Port']`, and allow inbound connectivity there first.

Default TCP and UDP allow inbound rules are in the role attributes. No node attributes currently go above and beyond this.

## Fail2ban/denyhosts

TBD. May need something custom to handle its iptables rules.

## User accounts

We have several users with direct shell access. Some of them will have SSH keys and some will just use password authentication. Not sure how to define these yet, possibly an environment attribute.

## Base nginx webserver

We use a wrapper cookbook around `nginx`, called `edgelink_nginx`.

Changes from the old server:
* "index" directive moved into individual site definitions
* "upstream" directives moved into separate conf.d file
* "ssl" directive moved into separate conf.d file

TBD: Site creation mechanism from template (specify site and options in attributes, config gets created, site gets enabled.)

## php-fpm

From community cookbook. Small patch in place to avoid disabling/re-enabling the default pool every time (https://github.com/yevgenko/cookbook-php-fpm/pull/62/).

## Dockerized websites

TBD

## Mailserver

TBD. Needs TCP ports `25,465,587,110,995,143,993` or a reasonable subset opened. Also needs:

* Dovecot
* Exim4
* Spamassassin

## IRC

TBD. Includes Qw0Bot.

## Internal webapps

* phpMyAdmin
* Nagios
* Roundcube
* Squirrelmail



