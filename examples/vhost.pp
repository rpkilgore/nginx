include nginx
nginx::vhost { 'dev': }
nginx::vhost { 'qa': }
nginx::vhost { 'prod':
  docroot => '/var/www/prod',
}
