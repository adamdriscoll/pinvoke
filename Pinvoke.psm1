$Script:PinvokeNetWebServiceProxy = New-WebServiceProxy -Uri http://www.pinvoke.net/pinvokeservice.asmx?wsdl -Class Service -Namespace PInvokeDotNet

function Find-PinvokeSignature {
    <#
        .SYNOPSIS
            Finds a Pinvoke signature based on the name of the module or function.
    #>
	param(
		[Parameter(Mandatory)]
		[string]$Name
	)

	$WikiVersion = New-Object -TypeName PInvokeDotNet.WikiVersion 
	$WikiVersion.Major = 1
	$WikiVersion.Minor = 0
	$WikiVersion.Build = 0
	$WikiVersion.Revision = 153

	$Script:PinvokeNetWebServiceProxy.SearchFunction($name, $WikiVersion)
}

function Get-PinvokeSignature {
    <#
        .SYNOPSIS
            Returns a P\Invoke signature for the specified module and function.
    #>
	param(
		[Parameter(Mandatory)]
		[string]$Module,
		[Parameter(Mandatory)]
		[string]$Function
	)

	$Script:PinvokeNetWebServiceProxy.GetResultsForFunction($Function, $Module)
}

function New-PinvokeCommand {
    <#
         .SYNOPSIS
            Creates a new PowerShell command that wraps the P\Invoke module and function.
    #>
	param(
		[Parameter(Mandatory)]
		[string]$Module,
		[Parameter(Mandatory)]
		[string]$Function,
        [Parameter()]
        [string]$CommandName = $Function
	)

	$Signature = Get-PinvokeSignature -Module $Module -Function $Function | Where Language -EQ 'C#'
    $Signature = $Signature.Signature.Replace('|', [Environment]::NewLine)

    if (-not $Signature.Contains('public'))
    {
        $Signature = $Signature.Replace('static', 'public static')
    }

    $ClassName = $Module + [DateTime]::Now.Ticks

	Add-Type "
        using System;
        using System.Runtime.InteropServices;

	    public static class $ClassName {
		    $($Signature)
	    }
	" 

	$ModuleType = Invoke-Expression "[$ClassName]"
	$MethodInfo = $ModuleType.GetMethod($Function)
	$Parameters = $MethodInfo.GetParameters()

    $CommandSignature = "function Global:$CommandName { param("
    $Body = "[$ClassName]::$Function("
	foreach($Parameter in $Parameters)
	{
        $CommandSignature += "[$($Parameter.ParameterType)]`$$($Parameter.Name),"
        $Body += "`$$($Parameter.Name),"
	}

    $CommandSignature = $CommandSignature.TrimEnd(',')
    $CommandSignature += ")"

    $Body = $Body.TrimEnd(',')
    $Body += ")"

    $CommandSignature += $Body + "}"

    Invoke-Expression $CommandSignature
}
