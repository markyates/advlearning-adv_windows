# == Class: adv_windows
#
# A class to serve as example to do some tests on.
#

class adv_windows($workFolder,
                  $defaultRegion,
                  $awsAccessKeyId,
                  $awsSecretAccessKey,
                  $csenv,
                  $nrlicense) {
  # Defaults
  File { source_permissions => ignore }

  # Ensure working folder exists
  file{$workFolder:
    ensure => directory
  }

  # Windows Timezone
  include adv_windows::timezone

  # ipv6 settings
  class{'windows_disable_ipv6':
    ipv6_disable => true,
    ipv6_reboot  => false
  }

  # Windows Firewall Settings
  include adv_windows::windowsfirewall

  # basic .NET install for 3.5 and 4
  include adv_windows::microsoftnet

  # MSDTC settings
  include adv_windows::msdtc

  # aws command line interface
  class{'adv_windows::awscli':
    workFolder         => $workFolder,
    defaultRegion      => $defaultRegion,
    awsAccessKeyId     => $awsAccessKeyId,
    awsSecretAccessKey => $awsSecretAccessKey
  }

  # install Adobe Brackets
  class{'adv_windows::brackets':
    workFolder => $workFolder
  }

  # install CentraStage
  class{'adv_windows::centrastage':
    workFolder => $workFolder,
    csenv      => $csenv
  }

  # Install New Relic Server Monitor
  class{'adv_windows::nrserver':
    workfolder => $workFolder,
    nrlicense  => $nrlicense
  }

  # PaperTral - centralised log collection
  class{'adv_windows::papertrail':
    workFolder => $workFolder
  }

  # AV Software
  class{'adv_windows::bitdefender':
    wofkFolder => $workFolder
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
      notify      => Exec['remediateDriverIssue.ps1']
    }

    exec{'remediateDriverIssue.ps1':
      command     => 'RemediateDriverIssue.ps1',
      path        => $workFolder,
      provider    => powershell,
      refreshonly => true
    }
  }
}
