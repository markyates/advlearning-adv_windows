# manifiest/init.pp
# == Class: adv_windows

class adv_windows($workFolder,
                  $defaultRegion,
                  $awsAccessKeyId,
                  $awsSecretAccessKey,
                  $csenv,
                  $nrlicense,
                  $pthost,
                  $ptport) {
  # Defaults
  File { source_permissions => ignore }

  # Ensure working folder exists
  file{$workFolder:
    ensure => directory
  }

  # should only run puppet agent once every 2h
  file{'puppet.conf':
    ensure  => present,
    path    => 'C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf',
    content => template('adv_windows/puppet.conf.erb')
  }

  # Chocolate package manager install
  include chocolatey_sw

  # Windows Timezone
  include adv_windows::timezone

  # Windows Firewall Settings
  include adv_windows::windowsfirewall

  # basic .NET install for 3.5 and 4
  include adv_windows::microsoftnet

  # .net framework 4.5
  package {'dotnet4.5':
    ensure   => 'present',
    provider => 'chocolatey',
    require  => Class['chocolatey_sw']
  }

  # MSDTC settings
  include adv_windows::msdtc

  # aws command line interface
  class{'adv_windows::awscli':
    region          => $defaultRegion,
    accessKeyId     => $awsAccessKeyId,
    secretAccessKey => $awsSecretAccessKey,
    require         => Class['chocolatey_sw']
  }

  # install Adobe Brackets
  package {'Brackets':
    ensure   => present,
    provider => 'chocolatey',
    require  => Class['chocolatey_sw']
  }

  # install CentraStage
  class{'adv_windows::centrastage':
    workFolder => $workFolder,
    csenv      => $csenv
  }

  # Install New Relic Server Monitor
  class{'adv_windows::nrserver':
    workFolder => $workFolder,
    nrlicense  => $nrlicense
  }

  # PaperTral - centralised log collection
  class{'adv_windows::papertrail':
    host    => $pthost,
    port    => $ptport,
    require => Class['chocolatey_sw']
  }

  # AV Software
  class{'adv_windows::bitdefender':
    workFolder => $workFolder
  }


  if $::osfamily == 'windows' and $::kernelmajversion == '6.3' {
    file{"${workFolder}\\RemediateDriverIssue.ps1":
      ensure  => present,
      content => template('adv_windows/RemediateDriverIssue.ps1'),
      require => File[$workFolder]
    }

    file{"${workFolder}\\AWSPVDriverPackager.exe":
      ensure  => present,
      source  => 'puppet:///modules/adv_windows/AWSPVDriverPackager.exe',
      require => File[$workFolder,"${workFolder}\\RemediateDriverIssue.ps1"],
      notify  => Exec['AWSPVDriverPackager']
    }

    exec{'AWSPVDriverPackager':
      command     => 'AWSPVDriverPackager.exe /install /silent /noreboot',
      path        => $workFolder,
      refreshonly => true,
    }

    exec{'remediateDriverIssue.ps1':
      command  => 'RemediateDriverIssue.ps1',
      path     => $workFolder,
      creates  => "${workFolder}\\RemediateDriverIssue.log",
      provider => powershell
    }
  }
}
