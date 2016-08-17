if ($ENV:APPVEYOR -ne 'true')
{
	$ENV:APPVEYOR_BUILD_VERSION = '99.99'
	. (Join-Path $PSScriptRoot 'CreateModuleManifest.ps1') 
}

Import-Module (Join-Path $PSScriptRoot 'PInvoke.psd1') -Force

Describe "New-PinvokeCommand" {
	Context "Create a command for Beep" {
		It "Returns true" {
			New-PinvokeCommand -Module Kernel32 -Function 'Beep' -CommandName 'Invoke-Beep'
			$ShouldBe = $ENV:APPVEYOR -ne 'true'
			Invoke-Beep -dwFreq 1 -dwDuration 1 | Should be $ShouldBe
		}
	}
}