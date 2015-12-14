# Warning: this box is deprecated. Use the one in `zooglerails` project instead. Check https://github.com/bandzoogle/zooglerails/wiki/Using%20Vagrant%20for%20local%20development

# zooglerails-dev-box

This is a [Vagrant](http://www.vagrantup.com/) box for setting up a Bandzoogle development box. It includes MySQL and other needed dependencies.

This project is a modified fork of the [rails-dev-box](https://github.com/rails/rails-dev-box) by [@fxn](https://github.com/fxn). All the kudos to him.

## Initial configuration

Execute the following commands in the terminal:

1. Install [Vagrant](http://www.vagrantup.com/) and [Virtual Box](https://www.virtualbox.org/).

2. Clone the `zooglerails-dev-box` project and switch to its folder:

        git clone https://github.com/bandzoogle/zooglerails-dev-box.git
        cd zooglerails-dev-box

3. Clone `zooglerails` into the `zooglerails-dev-box` folder and checkout the `development` branch (our main branch for daily development).

        git clone https://github.com/bandzoogle/zooglerails.git
        cd zooglerails
        git checkout development
        cd ..

4. Generate the VM

        vagrant up

5. SSH into the VM

        vagrant ssh # now you are inside the VM

6. You will need to establish your SSH key in order to synch with our git repos and complete the rest of the initialization. To do this, follow the directions here: https://help.github.com/articles/generating-ssh-keys/

7. The `/vagrant` directory inside the VM will point to your `zooglerails-dev-box` directory. Switch to it and initialize the Rails environment:

        cd /vagrant/zooglerails
        cp config/local.yml.sample config/local.yml
        bundle
        bundle exec rake db:migrate
        bundle exec rake db:seed_fu

8. The app needs to be served from bandzoogle.dev (no localhost or 0.0.0.0):

  If you are on Mac, using [pow](http://pow.cx/) is recommended. Do the following in a fresh terminal window (not inside the Vagrant ssh session):

        curl get.pow.cx | sh
        cd ~/.pow
        echo 3000 > bandzoogle

  If you are not on Mac, you need to modify your `/etc/hosts` and add the following entries:

        0.0.0.0 bandzoogle.dev
        0.0.0.0 xyz.bandzoogle.dev # to serve a site named xyz locally

9. The app will need to process the stock images that have been loaded with the seeds. To do so it does make use of a tmp directory which may not have the permissions set accordingly. To change this, you can ssh into the box, create the folder, adjust its permissions, and then return to your zooglerails directory:

        cd /mnt
        mkdir tmp
        sudo chmod 777 tmp
        cd /vagrant/zooglerails

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
