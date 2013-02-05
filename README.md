# z-dev-box

This is a [Vagrant](http://www.vagrantup.com/) box for Rails development that includes MySQL and other common dependencies.

This project is a modified fork of the [rails-dev-box](https://github.com/rails/rails-dev-box) by [@fxn](https://github.com/fxn). All the kudos to him.

## Requirements

You need to install:

1. [VirtualBox](https://www.virtualbox.org)

2. [Vagrant](http://vagrantup.com)

## Usage

1. Build the virtual machine

    ```
    git clone https://github.com/jorgemanrubia/z-dev-box
    cd z-dev-box
    vagrant up
    ```

2. Clone the repo containing the code you want to edit inside the VM folder:

    ```bash
    git clone https://github.com/jorgemanrubia/some-repo.git
    ls # README.md puppet Vagrantfile some-repo
    ```

3. Now you can connect to the virtual machine and check the source code in the shared directory `/vagrant` mounted in the virtual box:

    ```bash
    vagrant ssh 
    ls /vagrant # README.md puppet Vagrantfile some-repo
    ```

The recommended workflow is

* Edit in the host computer where you have your editor, git and your SSH keys properly configured

* Test and run things in the virtual machine

## Box contents

It is a minimal Ubuntu (Precise Pangolin) containing:

* Git

* RVM

* Ruby 1.9.3 (binary RVM install)

* Bundler

* MySQL

* System dependencies for nokogiri, mysql, capybara-webkit and imagemagick

## Documentation

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
