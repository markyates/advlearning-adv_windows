# manifiest/init.pp
# == Class: adv_windows

class adv_windows($workFolder,
                  $defaultRegion,
                  $awsAccessKeyId,
                  $awsSecretAccessKey,
                  $csenv,
                  $nrlicense,
                  $pthost,
                  $ptport,
                  $iscloud = true) {
  # Defaults
  File { source_permissions => ignore }
  Package { provider => chocolatey }

  # Ensure working folder exists
  file{$workFolder:
    ensure => directory
  }

  # install chocolatey
  exec {'execPolicy':
    command  => 'Set-ExecutionPolicy Unrestricted -Force; exit 0',
    unless   => '$policy = get-executionpolicy; if ($policy -eq "Unrestricted") {exit 1}',
    provider => powershell
  }->
  exec {'chocoInst':
    command  => template('adv_windows/chocolatey.ps1'),
    creates  => 'C:\ProgramData\chocolatey',
    provider => powershell
  }

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

  # basic .NET install for 3.5 and 4
  include adv_windows::microsoftnet

  # .net framework 4.5
  package {'dotnet4.5':
    ensure   => latest,
    provider => 'chocolatey'
  }

  # MSDTC settings
  include adv_windows::msdtc

  # aws command line interface
  class{'adv_windows::awscli':
    region          => $defaultRegion,
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

  # PaperTral - centralised log collection
  class{'adv_windows::papertrail':
    host => $pthost,
    port => $ptport
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
