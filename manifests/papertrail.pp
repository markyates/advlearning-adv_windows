# manifests/papertrail.pp

class adv_windows::papertrail($workFolder,
                              $host,
                              $port) {

  File { source_permissions => ignore }
  ensure_resource(file, $workFolder, {ensure => directory})

  file{'nxlog':
    ensure => present,
    path   => "${workFolder}\\nxlog-ce-2.8.1248.msi",
    source => 'puppet:///modules/adv_windows/nxlog-ce-2.8.1248.msi',
    notify => Exec['InstallPapertrail']
  }

  exec{'InstallPapertrail':
    command     => "msiexec.exe /i ${workFolder}\\nxlog-ce-2.8.1248.msi /qb",
    path        => 'C:\Windows\system32',
    refreshonly => true,
  }

  ensure_resource(file, 'C:\\Program Files (x86)\\nxlog', {ensure => directory})
  ensure_resource(file, 'C:\\Program Files (x86)\\nxlog\\conf', {ensure => directory})  # lint:ignore:80chars

  file{'nxlog.conf':
    ensure  => present,
    path    => 'C:\Program Files (x86)\nxlog\conf\nxlog.conf',
    content => template('adv_windows/nxlog.conf.erb')
  }

  service{'nxlog':
    ensure => 'running',
    enable => true
  }
}
