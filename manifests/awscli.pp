# manifests/awscli.pp

class adv_windows::awscli($workFolder,
                          $defaultRegion,
                          $awsAccessKeyId,
                          $awsSecretAccessKey) {

  File { source_permissions => ignore }

  ensure_resource(file, $workFolder, { ensure => directory })

  file{'AWSCLI':
    ensure => present,
    path   => "${workFolder}\\AWSCLI64.msi",
    source => 'puppet:///modules/adv_windows/AWSCLI64.msi',
    notify => Exec['AWSCLIInstall']
  }

  exec{'AWSCLIInstall':
    command     => "C:\\Windows\\system32\\msiexec.exe /i ${workFolder}\\AWSCLI64.msi /qn INSTALLLEVEL=1", # lint:ignore:80chars
    refreshonly => true
  }

  # set th environment variables
  registry_value{'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_DEFAULT_REGION':
    ensure => present,
    type   => string,
    data   => $defaultRegion
  }
  registry_value{'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_ACCESS_KEY_ID':
    ensure => present,
    type   => string,
    data   => $awsAccessKeyId
  }
  registry_value{'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_SECRET_ACCESS_KEY':
    ensure => present,
    type   => string,
    data   => $awsSecretAccessKey
  }
}
