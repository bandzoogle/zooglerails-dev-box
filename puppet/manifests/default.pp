$banzdoogle_databases = ['bzrails', 'bzrails_test']
$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

# Pick a Ruby version modern enough, that works in the currently supported Rails
# versions, and for which RVM provides binaries.
$ruby_version = '2.1.2'

Exec {
path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
exec { 'apt-get -y update':
  unless => "test -e ${home}/.rvm"
}
}
class { 'apt_get_update':
  stage => preinstall
}


# --- MySQL --------------------------------------------------------------------

class install_mysql {
class { 'mysql': }

class { 'mysql::server':
  config_hash => { 'root_password' => '' }
}

database { $banzdoogle_databases:
  ensure  => present,
  charset => 'utf8',
  require => Class['mysql::server']
}

package { 'libmysqlclient15-dev':
  ensure => installed
}
}
class { 'install_mysql': }

# --- Memcached ----------------------------------------------------------------

class { 'memcached': }

# --- Packages -----------------------------------------------------------------

package { 'curl':
  ensure => installed
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

package { ['libcurl3', 'libcurl3-gnutls', 'libcurl4-openssl-dev', 'libgeoip-dev', 'imagemagick', 'libmagick++-dev', 'libqt4-dev', 'openjdk-7-jre-headless']:
  ensure => installed
}

# ImageOptim dependencies.
package { ['advancecomp', 'gifsicle', 'jhead', 'jpegoptim', 'libjpeg-progs', 'optipng', 'pngcrush', 'pngquant']:
  ensure => installed
}

# ExecJS runtime.
package { 'nodejs':
  ensure => installed
}

# --- Ruby ---------------------------------------------------------------------

exec { 'prepare gpg':
  command => "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3; ",
  creates => "${home}/.gnupg/trustdb.gpg"
}

exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm/bin/rvm",
  require => Package['curl']
}

exec { 'install_ruby':
  # We run the rvm executable directly because the shell function assumes an
  # interactive environment, in particular to display messages or ask questions.
  # The rvm executable is more suitable for automated installs.
  #
  # use a ruby patch level known to have a binary
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install ruby-${ruby_version} --binary --autolibs=enabled && rvm alias create default ${ruby_version}'",
  creates => "${home}/.rvm/bin/ruby",
  require => Exec['install_rvm']
}

# RVM installs a version of bundler, but for edge Rails we want the most recent one.
exec { "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'":
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['install_ruby']
}

# --- Locale -------------------------------------------------------------------

# Needed for docs generation.
exec { 'update-locale':
  command => 'update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8'
}
