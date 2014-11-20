# manifests/papertrail.pp

class adv_windows::papertrail($host,
                              $port) {

  package{'nxlog':
    ensure   => present,
    provider => 'chocolatey'
  }

  ensure_resource(file, 'C:\\Program Files (x86)\\nxlog', {ensure => directory})
  ensure_resource(file, 'C:\\Program Files (x86)\\nxlog\\conf', {ensure => directory})  # lint:ignore:80chars

  file{'nxlog.conf':
    ensure  => present,
    path    => 'C:\Program Files (x86)\nxlog\conf\nxlog.conf',
    content => template('adv_windows/nxlog.conf.erb'),
    require => Package['nxlog']
  }

  service{'nxlog':
    ensure  => 'running',
    enable  => true,
    require => Package['nxlog']
  }
}
