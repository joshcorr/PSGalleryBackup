function Save-Nupkg {
    <#
    .SYNOPSIS
        Saves a nupkg file from a feed.
    .EXAMPLE
        Save-Nupkg -URI 'https://www.powershellgallery.com/api/v2/package/dbatools/1.0.155' -Path 'C:\temp\dbatools.1.0.155.nupkg'
        Expand-Archive -Path 'C:\temp\dbatools.1.0.155.nupkg' -DestinationPath C:\Users\user\Documents\WindowsPowerShell\modules\

        To Save a Module and then quickly extract it to a path. It will have some unecessary files in it.
    .EXAMPLE
        Save-Nupkg -URI 'https://www.powershellgallery.com/api/v2/package/dbatools/1.0.155' -Path 'C:\Backups\dbatools.1.0.155.nupkg'

        Save a package for later use.
    .NOTES
        Packages that are downloaded from the PowerShell gallery can be found under the path.
        https://www.powershellgallery.com/api/v2/package/<packageName>/<version>
    #>
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string]$URI,
        [Parameter(Mandatory)]
        [ValidateScript({
           if ($PSItem.extension -match '.nupkg'){
               $true
           } else {
               Throw "Path must include the .nupkg"
           }
        })]
        [IO.FileInfo]$Path,
        [switch]$Force
    )
    $ErrorActionPreference = 'STOP'
    [Net.servicePointManager]::SecurityProtocol = [Net.servicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    try {
        if (-Not $force -and (Test-Path -Path $Path.Fullname)){
            Write-Error -Message "Path $Path already exists. Use -Force to overwrite"
            break
        }
        $Downloader = New-Object -TypeName System.Net.WebClient
        $Downloader.DownloadFile("$URI", "$($path.Fullname)")

        if (Test-Path -Path $($path.Fullname)){
            Write-Output "Nupkg downloaded to $($path.Fullname)"
        } else {
            Write-Error "Nupkg missing from $($path.Fullname)"
        }
    } catch {
        throw
    }
}