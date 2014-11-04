# manifests/brackets.pp

class adv_windows::brackets($workFolder) {
  File { source_permissions => ignore }

  ensure_resource(file, $workFolder, { ensure => directory })

  file{'BracketsInstaller':
    ensure => present,
    path   => "${workFolder}\\Brackets.msi",
    source => 'puppet:///modules/adv_windows/Brackets.msi',
    notify => Exec['BracketsInstall']
  }

  exec{'BracketsInstall':
    command     => "C:\\Windows\\system32\\msiexec.exe /i ${workFolder}\\Brackets.msi /qn", # lint:ignore:80chars
    refreshonly => true
  }

}
