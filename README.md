# Vagrant: Debian VM (wheezy 64bit) with PHP 5.5, MySQL, Nginx, Redis

Vagrant + Puppet installation of Debian focusing on PHP development.

## Introduction

This vagrant/puppet build includes the following:
- PHP 5.5
- Nginx
- PHP-FPM
- Redis
- Memcached
- MySQL
- ElasticSearch
- RabbitMQ

## Installation

The following instructions are specific to OSX.

### Requirements

- OSX 10.8+
- Vagrant

### Install Vagrant

Download and install vagrant (1.2.2+): http://downloads.vagrantup.com

### Clone the git repository

Clone the repository in your prefered location, initialize submodules, and update:

```sh
$ git clone https://github.com/sqmk/vagrant-debian-php-vm
$ git submodule init
$ git submodule update
```

### Vagrant up

From the root of the directory of the cloned project, vagrant up:

```sh
$ cd vagrant-debian-php-vm
$ vagrant up
```

*Note:* You may be prompted with your OSX password during the point where NFS is enabled. You must provide your password to proceed.
