# manifests/msdtc.pp

class adv_windows::msdtc {
  # Configure MSDTC for Progresso
  exec {'Configure MSDTC':
    command   => template('adv_windows/msdtc/set.ps1.erb'),
    onlyif    => template('adv_windows/msdtc/check.ps1.erb'),
    provider  => powershell
  }
}
