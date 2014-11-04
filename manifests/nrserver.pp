# manifests/nrserver.pp

class adv_windows::nrserver($workFolder,
                            $nrlicense) {

  File { source_permissions => ignore }

  ensure_resource(file, $workFolder, { ensure => directory })

  # if have a license key install server monitor
  file{'New Relic Server Monitor':
    path   => "${workFolder}\NewRelicServerMonitor_x64.msi",
    ensure => present,
    source => 'puppet:///modules/adv_windows/NewRelicServerMonitor_x64.msi',
    notify => Exec['InstallServerMonitor']
  }

  exec{'InstallServerMonitor':
    command     => "msiexec.exe /i ${workFolder}\NewRelicServerMonitor_x64.msi /L*v install.log /qn NR_LICENSE_KEY=$nrlicense",
    path        => 'C:\Windows\system32',
    refreshonly => true
  }
}
