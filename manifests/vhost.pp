define nginx::vhost (
  $docroot = "${nginx::docroot}/${title}",
  $port = 80,
  $servername = "${title}.${::fqdn}",
) {
  file { "${title} vhost config":
    ensure  => file,
    path    => "${nginx::blockdir}/${title}.conf",
    content => template('nginx/vhost.conf.erb'),
    notify  => Service[$nginx::service],
  }
  file { $docroot:
    ensure => directory,
  }
  file { "${docroot}/index.html":
    ensure  => file,
    content => template('nginx/index.html.erb'),
  }
  
  file { "${docroot}/puppet_old_logo.jpg":
    ensure => file,
	source => 'puppet:///modules/nginx/puppet_old_logo.jpg',
	require => File["${docroot}/index.html"],
  }
  
  if $servername != '_' {
    host { $servername:
      ensure       => present,
      ip           => $::ipaddress,
      host_aliases => [$title],
      before       => File["${title} vhost config"],
    }
  }
}
