# manifests/timezone.pp

class adv_windows::timezone {
  # Configure timezone for Progresso
  exec {'Configure timezone':
    command  => template('adv_windows/timezone/set.cmd.erb'),
    onlyif   => template('adv_windows/timezone/check.ps1.erb'),
    provider => powershell
  }
}
