@{
RootModule = 'PSGalleryBackup.psm1'
ModuleVersion = '0.0.1'
GUID = 'b84d839b-f6fc-4b7d-b9d6-26bb1d7339d6'
Author = 'Josh Corrick (@Joshcorr)'
CompanyName = 'blog.corrick.io'
Copyright = '(c) 2021 Josh Corrick (@joshcorr). All rights reserved.'
Description = 'Backup and Internalize PSGallery Modules'
PowerShellVersion = '5.1'
FunctionsToExport = 'Get-ProgetPackage', 'Invoke-LocalPowerShellGalleryUpdate',
               'Save-Nupkg'

CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = @()
PrivateData = @{
    PSData = @{
        Tags = @('Backup','nupkg','PowerShellGallery')
        LicenseUri = 'https://raw.githubusercontent.com/joshcorr/PSGalleryBackup/main/LICENSE'
        ProjectUri = 'https://github.com/joshcorr/PSGalleryBackup'
        ReleaseNotes = 'https://raw.githubusercontent.com/joshcorr/PSGalleryBackup/main/CHANGELOG.md'
        # Prerelease = ''
    }
}
}

