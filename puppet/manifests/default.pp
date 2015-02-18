$ar_databases = ['activerecord_unittest', 'activerecord_unittest2']
$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

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

# --- SQLite -------------------------------------------------------------------

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => installed;
}


# --- PostgreSQL ---------------------------------------------------------------

class install_postgres {
  class { 'postgresql': }

  class { 'postgresql::server': }

  pg_database { $ar_databases:
    ensure   => present,
    encoding => 'Unicode',
    locale   => 'en_US.UTF-8',
    require  => Class['postgresql::server']
  }

  pg_user { 'vagrant':
    ensure    => present,
    superuser => true,
    require   => Class['postgresql::server']
  }
 
  pg_user { 'smalljobs':
    ensure    => present,
    superuser => false,
    createdb   => true,
    createrole => true,
    require   => Class['postgresql::server']
  }
  
  package { 'libpq-dev':
    ensure => installed
  }

  package { 'postgresql-contrib':
    ensure  => installed,
    require => Class['postgresql::server'],
  }
}
class { 'install_postgres': }


# --- Packages -----------------------------------------------------------------

package {[ 'curl','build-essential','git-core','mc','htop','vim','tmux']: 
  ensure => installed 
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}


# --- Ruby ---------------------------------------------------------------------


exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm/bin/rvm",
  require => Package['curl']
}

exec {'rvm_pgp_keys':
  command => "${as_vagrant} 'gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 BF04FF17'",
}

exec { 'install_ruby':
  # We run the rvm executable directly because the shell function assumes an
  # interactive environment, in particular to display messages or ask questions.
  # The rvm executable is more suitable for automated installs.
  #
  # Thanks to @mpapis for this tip.
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install 2.1.0 --autolibs=enabled && rvm --fuzzy alias create default 2.1.0'",
  creates => "${home}/.rvm/bin/ruby",
  require => Exec['install_rvm','rvm_pgp_keys']
}

exec { "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'":
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['install_ruby']
}
