Describe  'Dev Tools installation' {
    It 'installs nuget' {
        { Get-Command "nuget.exe" -ErrorAction Stop } | Should Not Throw
    }

    It 'installs git' {
        { Get-Command "git" -ErrorAction Stop } | Should Not Throw
    }

    It 'installs web server' {
        { Get-WindowsFeature -Name web-Server -ErrorAction Stop } | Should Not Throw
    }
}