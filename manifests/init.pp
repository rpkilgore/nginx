class nginx (
  $package = $nginx::params::package,
  $owner = $nginx::params::owner,
  $group = $nginx::params::group,
  $docroot = $nginx::params::docroot,
  $confdir = $nginx::params::confdir,
  $blockdir = $nginx::params::blockdir,
  $logdir = $nginx::params::logdir,
  $service = $nginx::params::service,
  $user = $nginx::params::user,
) inherits nginx::params {
  File {
    ensure => file,
    owner  => $owner,
    group  => $group,
    mode   => '0644',
  }
  package { $package:
    ensure => present,
  }
  file { 'nginx main config':
    path    => "${confdir}/nginx.conf",
    content => template('nginx/nginx.conf.erb'),
    require => Package[$package],
    notify  => Service[$service],
  }
  service { $service:
    ensure => running,
    enable => true,
  }
  nginx::vhost { 'default':
    servername => '_',
    port       => 80,
    docroot    => $docroot,
  }
}
