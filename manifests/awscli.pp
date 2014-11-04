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
  windows_env{'AWS_DEFAULT_REGION':
    ensure    => present,
    value     => $defaultRegion,
    mergemode => clobber
  }
  windows_env{'AWS_ACCESS_KEY_ID':
    ensure    => present,
    value     => $awsAccessKeyId,
    mergemode => clobber
  }
  windows_env{'AWS_SECRET_ACCESS_KEY':
    ensure    => present,
    value     => $awsSecretAccessKey,
    mergemode => clobber
  }
}
