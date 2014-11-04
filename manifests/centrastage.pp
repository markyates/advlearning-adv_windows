# manifests/centrastage.pp

class adv_windows::centrastage($workFolder,
                               $csenv){

  File { source_permissions => ignore }

  ensure_resource(file, $workFolder, { ensure => directory })

  file{"CSInstaller-${csenv}":
    ensure => present,
    path   => "${workFolder}\\AgentSetup_${csenv}.exe",
    source => "puppet:///modules/adv_windows/centrastage/AgentSetup_${csenv}.exe"
  }

  exec{"CSInstall-${csenv}":
    command => "${workFolder}\\AgentSetup_${csenv}.exe",
    creates => 'C:\\Program Files (x86)\\CentraStage',
    require => File["CSInstaller-${csenv}"]
  }
}
