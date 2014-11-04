# manifests/bitdefender.pp

class adv_windows::bitdefender($workFolder) {
  File { source_permissions => ignore }
  ensure_resource(file, $workFolder, { ensure => directory })

  file{'Bitdefender-Installer':
    ensure => present,
    path   => "${workFolder}\\bitdefender_thindownloader.exe",
    source => 'puppet:///modules/adv_windows/bitdefender_thindownloader.exe',
    notify => Exec['Bitdefender-Install']
  }

  exec{'Bitdefender-Install':
    command     => "${workFolder}\\bitdefender_thindownloader.exe /quiet',
    refreshonly => true
  }

}
