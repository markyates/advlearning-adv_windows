# manifests/microsoftnet.pp

class adv_windows::microsoftnet {
  dism {'NetFx3ServerFeatures':
    ensure => present
  } ->
  dism {'NetFx3':
    ensure => present
  }

  dism {'NetFx4ServerFeatures':
    ensure => present
  } ->
  dism {'NetFx4':
    ensure => present
  } ->
  dism {'NetFx4Extended-ASPNET45':
    ensure => present
  }
}
