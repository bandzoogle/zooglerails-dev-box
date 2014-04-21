# zooglerails-dev-box

This is a [Vagrant](http://www.vagrantup.com/) box for setting up a Bandzoogle development box. It includes MySQL and other needed dependencies.

This project is a modified fork of the [rails-dev-box](https://github.com/rails/rails-dev-box) by [@fxn](https://github.com/fxn). All the kudos to him.

## Initial configuration

Execute the following commands in the terminal:

0. Install [Vagrant](http://www.vagrantup.com/) and [Virtual Box](https://www.virtualbox.org/).

1. Clone the `zooglerails-dev-box` project and switch to its folder:

        git clone https://github.com/bandzoogle/zooglerails-dev-box.git
        cd zooglerails-dev-box

2. Clone `zooglerails` into the `zooglerails-dev-box` folder and checkout the `development` branch (our main branch for daily development).

        git clone https://github.com/bandzoogle/zooglerails.git
        cd zooglerails
        git checkout development
        cd ..

3. Generate the VM

        vagrant up

4. SSH into the VM

        vagrant ssh # now you are inside the VM

5. The `/vagrant` directory inside the VM will point to your `zooglerails-dev-box` directory. Switch to it and initialize the Rails environment:

        cd /vagrant/zooglerails
        cp config/local.yml.sample config/local.yml
        bundle
        bundle exec rake db:migrate
        bundle exec rake db:seed_fu

7. The app needs to be served from bandzoogle.dev (no localhost or 0.0.0.0):

If you are on Mac, using [pow](http://pow.cx/) is recommended. Do the following in a fresh terminal window (not inside the Vagrant ssh session):

        curl get.pow.cx | sh
        cd ~/.pow
        echo 3000 > banzdoogle

If you are not on Mac, you need to modify your `/etc/tabs` and add the following entries:

        0.0.0.0 bandzoogle.dev
        0.0.0.0 xyz.bandzoogle.dev # to serve a site named xyz locally

### Run the server

Now you can run the server: this command will run the server and a delayed job process for background jobs

        foreman start

Bandzoogle will be running in [http://bandzoogle.dev](http://bandzoogle.dev)


## Daily workflow

Work normally using your local editor in the folder `zooglerails-dev-box/zooglerails`. Use git normally to update and push your changes.

Start the server in the VM:

1. SSH into the VM

        vagrant up # not needed if the VM is already running
        vagrant ssh

2. Run the server

        cd /vagrant/zooglerails
        foreman start

### Commands to run ocassionally:

        bundle install # install new libraries/versions. They change often. The app will fail to load until you do this
        bundle exec rake db:migrate # if you need to run the migrations because the database structure has changed
