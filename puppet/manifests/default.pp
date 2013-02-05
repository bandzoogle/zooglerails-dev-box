$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

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

class install_mysql {
  class { 'mysql': }

  class { 'mysql::server':
    config_hash => { 'root_password' => '' }
  }

  package { 'libmysqlclient15-dev':
    ensure => installed
  }
}
class { 'install_mysql': }

package { 'curl':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

package { ['libcurl3', 'libcurl3-gnutls', 'libcurl4-openssl-dev', 'libgeoip-dev', 'libmagick++-dev', 'libqt4-dev']:
  ensure => installed
}

exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s master'",
  creates => "${home}/.rvm",
  require => Package['curl']
}

exec { 'install_ruby':
  # We run the rvm executable directly because the shell function assumes an
  # interactive environment, in particular to display messages or ask questions.
  # The rvm executable is more suitable for automated installs.
  #
  # Thanks to @mpapis for this tip.
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install 1.9.3 --latest-binary && rvm alias create default 1.9.3'",
  creates => "${home}/.rvm/bin/ruby",
  require => Exec['install_rvm']
}

exec { "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'":
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['install_ruby']
}
