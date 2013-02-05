# z-test-box

This is a vagrant box for Rails development that includes MySQL and other common dependencies. This project is a modified fork of the [rails-dev-box](https://github.com/rails/rails-dev-box) by @fxn. All the kudos to him.

## Requirements

* [VirtualBox](https://www.virtualbox.org)

* [Vagrant](http://vagrantup.com)

## How To Build The Virtual Machine

    host $ git clone https://github.com/jorgemanrubia/z-test-box
    host $ cd z-dev-box
    host $ vagrant up

## What's In The Box

* Git

* RVM

* Ruby 1.9.3 (binary RVM install)

* Bundler

* MySQL

* System dependencies for nokogiri, mysql, capybara-webkit and imagemagick

## Recommended Workflow

The recommended workflow is

* edit in the host computer and

* test within the virtual machine.

Just clone your repo fork in the very directory of the Rails development box in the host computer:

    host $ ls
    README.md   Vagrantfile puppet
    host $ git clone <your target git repo>

Vagrant mounts that very directory as _/vagrant_ within the virtual machine:

    vagrant@rails-dev-box:~$ ls /vagrant
    puppet  rails  README.md  Vagrantfile

so we are ready to go to edit in the host, and test in the virtual machine.

This workflow is convenient because in the host computer one normally has his editor of choice fine-tuned, Git configured, and SSH keys in place.

## Virtual Machine Management

When done just log out with `^D` and suspend the virtual machine

    host $ vagrant suspend

then, resume to hack again

    host $ vagrant resume

Run

    host $ vagrant halt

to shutdown the virtual machine, and

    host $ vagrant up

to boot it again.

You can find out the state of a virtual machine anytime by invoking

    host $ vagrant status

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

    host $ vagrant destroy # DANGER: all is gone

Please check the [Vagrant documentation](http://vagrantup.com/v1/docs/index.html) for more information on Vagrant.
