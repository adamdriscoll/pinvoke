$Version = "2.0.0"
$OutputPath = "$PSScriptRoot\bin\Release\netstandard2.0\publish"

task Build {
    Set-Location $PSScriptRoot
    
    dotnet publish -c Release

    $Assemblies = @(
        'AdvApi32', 
        'BCrypt', 
        'Cabinet', 
        'CfgMgr32', 
        'Crypt32', 
        'DwmApi', 
        'Fusion', 
        'Gdi32',
        'Hid', 
        'Iphlpapi', 
        'Kernel32', 
        'Magnification', 
        'MSCorEE',
        'Msi',
        'NCrypt',
        'NetApi32',
        'NewDev',
        'NtDll',
        'Psapi',
        'SetupApi',
        'SHCore',
        'Shell32',
        'User32',
        'Userenv',
        'UxTheme',
        'WinUsb',
        'Wtsapi32'
    )
    
    New-ModuleManifest -Path (Join-Path $OutputPath "pinvoke.psd1") `
        -ModuleVersion $Version `
        -Author 'Adam Driscoll' `
        -Copyright '2021 Adam Driscoll' `
        -RequiredAssemblies ($Assemblies | ForEach-Object { "PInvoke.$_.dll" }) `
        -LicenseUri 'https://github.com/adamdriscoll/pinvoke/blob/master/LICENSE' `
        -CompanyName 'Ironman Software, LLC' `
        -Description 'P\Invoke library for PowerShell' `
        -FunctionsToExport @() `
        -CmdletsToExport @() `
}

task Publish {
    Publish-Module -Path $OutputPath -NuGetApiKey $Env:APIKEY
}

task . Build
