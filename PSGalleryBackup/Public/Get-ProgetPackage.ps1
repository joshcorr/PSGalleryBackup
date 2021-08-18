function Get-ProgetPackage {
    <#
    .SYNOPSIS
        Pulls the latest version of pacakges in a Nuget feed
    .EXAMPLE
        Get-ProgetPackage -URI 'https://proget.example.com' -ApiToken <Native_API_Token> -FeedID <IDNUMBER>
    .EXAMPLE
        Get-ProgetPackage -URI 'https://proget.example.com' -ApiToken <Native_API_Token> -FeedID <IDNUMBER> -Latest
    .NOTES
        Requires that an appropriate API key for Native API be used.
    #>
    [cmdletbinding()]
    param(
        # URI for the proget server
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$URI,
        # Native API Token for accessing pacakge info
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$APIToken,
        # Int of the Feed ID that is being queried
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FeedID,
        # List only the latest package in any feed
        [Parameter()]
        [switch]$Latest
    )
    $ErrorActionPreference = 'Stop'
    [Net.servicePointManager]::SecurityProtocol = [Net.servicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    try {
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add('Content-Type','application/json')
        $headers.Add('Accept','application/json')
        $headers.Add('X-ApiKey',"$APIToken")

        $body = @{feed_id = $FeedID} | ConvertTo-Json
        if ($latest) {
            $API_URI = $URI, 'api/json/NuGetPackagesV2_GetLatest' -Join '/'
        } else {
            $API_URI = $URI, 'api/json/NuGetPackagesV2_GetPackages' -Join '/'
        }
        $results = Invoke-RestMethod -Method POST -UseBasicParsing -URI $API_URI -Headers $headers -Body $body
        $results
    } catch {
        throw
    } finally {
        $headers, $body, $API_URI, $APIToken, $results = $null
    }
}