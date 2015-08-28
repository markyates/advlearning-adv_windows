# manifiest/init.pp
# == Class: adv_windows

class adv_windows($workFolder,
                  $defaultRegion,
                  $awsAccessKeyId,
                  $awsSecretAccessKey,
                  $csenv,
                  $nrlicense,
                  $iscloud = true) {
  # Defaults
  File { source_permissions => ignore }
  Package { provider => chocolatey }

  # Ensure working folder exists
  file{$workFolder:
    ensure => directory
  }

  # install chocolatey
  include chocoinst

  # should only run puppet agent once every 2h
  file{'puppet.conf':
    ensure  => present,
    path    => 'C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf',
    content => template('adv_windows/puppet.conf.erb')
  }

  # Windows Timezone
  include adv_windows::timezone

  # Windows Firewall Settings
  include adv_windows::windowsfirewall

  # MSDTC settings
  include adv_windows::msdtc

  # aws command line interface
  class{'awscli':
    dregion         => $defaultRegion,
    accessKeyId     => $awsAccessKeyId,
    secretAccessKey => $awsSecretAccessKey
  }

  # install Adobe Brackets
  package {'Brackets':
    ensure   => latest,
    provider => 'chocolatey'
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

  # AV Software
  class{'adv_windows::bitdefender':
    workFolder => $workFolder
  }

  # CloudHealth
  if $iscloud {
    class{'adv_windows::cloudhealth':
      workFolder => $workFolder
    }
  }
}
