$FunctionsToExport = @(
'Find-PinvokeSignature',
'Get-PinvokeSignature',
'New-PinvokeCommand')

$NewModuleManifestParams = @{
	ModuleVersion = $ENV:APPVEYOR_BUILD_VERSION
	Path = (Join-Path $PSScriptRoot '.\PInvoke.psd1')
	Author = 'Adam Driscoll'
	Company = 'Adam Driscoll'
	Description = 'PowerShell module accessing the PInvoke.NET APIs and generating commands from signatures.'
	RootModule = 'Pinvoke.psm1'
	FunctionsToExport = $FunctionsToExport
	ProjectUri = 'https://github.com/adamdriscoll/pinvoke'
	Tags = @('PInvoke', 'PinvokeDotNet')
}

New-ModuleManifest @NewModuleManifestParams