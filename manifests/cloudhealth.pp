# manifests/cloudhealth.pp

class adv_windows::cloudhealth($workFolder) {
  File { source_permissions => ignore }
  ensure_resource(file, $workFolder, { ensure => directory })

  file{'BitdefenderInstaller':
    ensure => present,
    path   => "${workFolder}\\CloudHealthAgent.exe",
    source => 'puppet:///modules/adv_windows/CloudHealthAgent.exe',
    notify => Exec['CloudHealthInstall']
  }

  exec{'CloudHealthInstall':
    command     => "${workFolder}\\CloudHealthAgent.exe /S /v\"/l* install.log /qn CLOUDNAME=aws CHTAPIKEY=b8749822-2fb1-4292-b4e6-8c35fbcb5e41\"",
    refreshonly => true
  }

}
