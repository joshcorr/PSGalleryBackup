function Invoke-LocalPowerShellGalleryUpdate {
    <#
    .SYNOPSIS
        Function that can be a scheduled to Update a local PowerShellGallery-Mirror
    .EXAMPLE
        '[
            {
                "Package_Id": "dbatools",
                "Version_Text": "latest"
            }
        ]' | out-file C:\temp\Test.json
        Invoke-LocalPowerShellGalleryUpdate -ConfigFile C:\Temp\test.json -FeedURI https://proget.example.com -FeedToken <someAPIKey> -FeedID 2
    #>
    [cmdletbinding()]
    param(
        # Path to Configuration File expected in JSON format
        [Parameter(Mandatory)]
        [string]$ConfigFile,
        # URL where Config file is stored
        [Parameter()]
        [string]$ConfigFileURI,
        # URI for the local package server
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FeedURI,
        # Token used for your local feed
        [Parameter()]
        [string]$FeedToken,
        # Feed ID
        [Parameter()]
        [string]$FeedID

    )
    $ErrorActionPreference = 'Stop'
    [Net.servicePointManager]::SecurityProtocol = [Net.servicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    try {
        if($ConfigFileURL){
            Write-Host "Download config from source"
            $Downloader = New-Object -TypeName System.Net.WebClient
            $Downloader.DownloadFile("$ConfigFileURI", "$ConfigFile")
        }
        $DesiredPackages = Get-Content -raw $ConfigFile | ConvertFrom-Json
        Write-Host "Packages in Config:"
        Write-Host "$($DesiredPackages | Out-String)"
        Write-Host "Get Current Cache of Packages"
        $LocalPackages = Get-ProgetPackage -URI $FeedURI -APIToken $FeedToken -FeedID $FeedID
        Write-Host "Figure out which packages we need"
        $NeededPackages = foreach ($p in $DesiredPackages){
            $CurrentPackageList = $LocalPackages | Where-Object { $_.Package_ID -eq $p.Package_ID }
            if ($p.Version_Text -ne 'Latest') {
                $RemotePackage = Find-Module -Name $p.Package_ID -Repository PSGallery -RequiredVersion $p.Version_Text -ErrorAction SilentlyContinue
            } else {
                $RemotePackage = Find-Module -Name $p.Package_ID -Repository PSGallery -ErrorAction SilentlyContinue
            }
            if ($null -ne $RemotePackage -and ($RemotePackage.Version -notin $CurrentPackageList.Version_Text -or $null -eq $CurrentPackageList)) {
                $Version = $RemotePackage.Version
                [PSCustomObject]@{
                    Package_ID = $P.Package_ID
                    Version_Text = $Version
                }
            }
        }
        Write-Host "Packages Needed:"
        Write-Host "$($NeededPackages | Out-String)"
        Write-Host "Attempt to Download from PowerShell Gallery and Upload to $FeedURI"
        foreach ($n in $NeededPackages) {
            $SavedPackage = [environment]::GetEnvironmentVariable('TEMP'), "$($n.Package_ID).$($n.Version_Text).nupkg" -join [io.path]::DirectorySeparatorChar
            Save-Nupkg -URI "https://www.powershellgallery.com/api/v2/package/$($n.Package_ID)/$($n.Version_Text)" -Path $SavedPackage
            nuget push "$SavedPackage" -apikey $FeedToken -source $FeedURI
            Remove-Item -Path $SavedPackage -Confirm:$false -ErrorAction SilentlyContinue
        }
    } Catch {
        throw
    } finally {
        $ConfigFile, $NeededPackages, $RemotePackage, $LocalPackages, $FeedToken, $FeedID, $FeedURI = $null
    }
}