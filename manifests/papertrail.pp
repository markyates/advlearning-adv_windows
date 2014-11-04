# manifests/papertrail.pp

class adv_windows::papertrail($workFolder) {
  File { source_permissions => ignore }
  ensure_resource(file, $workFolder, {ensure => directory})

  file{'nxlog':
    path   => "${workFolder}\\nxlog-ce-2.8.1248.msi",
    ensure => present,
    source => 'puppet:///modules/adv_windows/nxlog-ce-2.8.1248.msi',
    notify => Exec['InstallPapertrail']
  }

  exec{'InstallPapertrail':
    command     => "msiexec.exe /i ${workFolder}\\nxlog-ce-2.8.1248.msi /qb",
    path        => 'C:\\Windows\\system32',
    refreshonly => true,
  }

  ensure_resource(file, 'C:\\Program Files (x86)\\nxlog', {ensure => directory})
  ensure_resource(file, 'C:\\Program Files (x86)\\nxlog\\conf', {ensure => directory})

  file{'nxlog.conf':
    path        => 'C:\\Program Files (x86)\\nxlog\\conf\\nxlog.conf',
    ensure      => present,
    source     => 'puppet:///modules/adv_windows/nxlog.conf'
  }

  service{'nxlog':
    ensure   => $running,
    enable   => $enable
  }
}
