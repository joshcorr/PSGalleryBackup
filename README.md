# PSGalleryBackup

Functions to internalize PowerShell modules as nupgk packages into a self hosted nupkg repo (Proget, nexus, etc)  

This module currently supports Saving Nupkg from various feeds (remote and local), Get a list of  current PowerShell packages hosted by a ProGet Feed, and Uploading desired packages to a ProGet  Feed. In the future we may support Nexus and other feed types.

## Requirements

- API Token for your internal repo (Proget requires a Native API token)
- Nuget.exe on the system running Invoke-LocalPowerShellGalleryUpdate (if you intend to upload the package to an internal repo) [Install Nuget Client Tools](https://docs.microsoft.com/en-us/nuget/install-nuget-client-tools)

## Scheduling up a Backup

The function `Invoke-LocalPowerShellGalleryUpdate` works to save desired PowerShell Modules and upload them to a local Proget Server. The command downloads modules based on a JSON document and the existing packages on in the repo. The JSON document should be formated in the following way:  

```json
[
    {
        "Package_Id": "dbatools",
        "Version_Text": "latest"
    },
    {
        "Package_Id": "acltools",
        "Version_Text": "latest"
    },
    {
        "Package_Id": "PSSlack",
        "Version_Text": "1.0.6"
    }
]
```

This can be stored next to the function, or you can store it in a web hosted source control system. The function can then be scheduled to backup desired modules and upload them to a local Proget server.
