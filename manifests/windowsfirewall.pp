# manifests/windowsfirewall.pp

class adv_windows::windowsfirewall {
  # Configure Windows Firewall setting domain disabled
  exec {'Configure Domain Firewall':
    command   => template('adv_windows/windowsfirewall/set.ps1.erb'),
    onlyif    => template('adv_windows/windowsfirewall/check.ps1.erb'),
    provider  => powershell
  }
}
