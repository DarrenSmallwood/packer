$tempFolder = 'C:\temp'

if ((Test-Path $tempFolder) -eq $false)
{
    Write-Output "Creating temp folder"
    New-Item -ItemType Directory -Path $tempFolder
}

# Download build agent
$wc = New-Object System.Net.WebClient
$url = 'https://vstsagentpackage.azureedge.net/agent/2.136.1/vsts-agent-win-x64-2.136.1.zip'
$Filename = [System.IO.Path]::GetFileName($url)
Write-Output "Downloading $Filename"
$dest = Join-Path "C:\temp" $Filename
$wc.DownloadFile($url, $dest)

$agentFolder = 'C:\agent'
$agentZip =  Get-ChildItem -LiteralPath "C:\temp" -Filter vsts*.zip

if ((Test-Path $agentFolder) -eq $false)
{
    mkdir $agentFolder
}
else{
    Write-Output "Agent folder already exists, delete and rerun the script"
    exit 1
}

if ($agentZip)
{
    $agentZipPath = Join-Path "C:\temp" $agentZip
    Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$agentZipPath", "$agentFolder")
}
else{
    Write-Output "Please put the agent zip file into the downloads folder and rerun the script"
    exit 1
}
