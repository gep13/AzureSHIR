import-module au

function global:au_SearchReplace {
    @{
        #   softwareName  = 'microsoft-integration-runtime *5.36.8726.3*'
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]softwareName\s*=\s*)('.*')" = "`$1'microsoft-integration-runtime *$($Latest.version)*'"
        }
     }
}

function global:au_GetLatest {

    # download the page that contains the latest version number
    $url = "https://www.microsoft.com/en-us/download/details.aspx?id=39717"
    # regex expresion to find version number example 5.36.8726.3
    $regex = ([regex]"\d+\.\d+\.\d+\.\d+")
    # sort numbers and get highest number
    $version = (((iwr $url -UseBasicParsing).RawContent | Select-String "$regex" -AllMatches ).Matches.Value | sort -Descending -Unique)[0]

    # construct the download url for the latest version
    $URL64 = "https://download.microsoft.com/download/E/4/7/E4771905-1079-445B-8BF9-8A1A075D8A10/IntegrationRuntime_$version.msi"

    $Latest = @{ 
        URL64 = $URL64
        Version = $version
    }

    return $Latest
}

update -ChecksumFor 64