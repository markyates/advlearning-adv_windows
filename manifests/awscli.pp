# manifests/awscli.pp

class adv_windows::awscli($region,
                          $accessKeyId,
                          $secretAccessKey) {

  package{'awscli':
    ensure   => present,
    provider => 'chocolatey'
  }

  # set th environment variables
  registry_value{'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_DEFAULT_REGION':
    ensure => present,
    type   => string,
    data   => $region
  }
  registry_value{'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_ACCESS_KEY_ID':
    ensure => present,
    type   => string,
    data   => $accessKeyId
  }
  registry_value{'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\AWS_SECRET_ACCESS_KEY':
    ensure => present,
    type   => string,
    data   => $secretAccessKey
  }
}
