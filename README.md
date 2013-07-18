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

Clone the repository in your prefered location:

```sh
$ git clone clone https://github.com/sqmk/vagrant-debian-php-vm
```

### Vagrant up

From the root of the directory of the cloned project, vagrant up:

```sh
$ cd vagrant-debian-php-vm
$ vagrant up
```
