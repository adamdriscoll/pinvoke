function Get-Window {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = "Search")]
        [string]$ClassName,
        [Parameter(ParameterSetName = "Search")]
        [string]$Title,
        [Parameter(ParameterSetName = "Search")]
        [PSCustomObject]$Parent,
        [Parameter(ParameterSetName = "Hwnd")]
        [IntPtr]$Hwnd
    )

    Process {
        $proc = {
            $hwnd = $args[0]
            $lParam = $args[1]

            $windowTitle = [PInvoke.User32]::GetWindowText($hwnd)
            $windowClassName = [PInvoke.User32]::GetClassName($hwnd, 1024)

            if ($windowTitle -match $ClassName -and $windowClassName -match $Title) {
                $Window = [PSCustomObject]@{
                    Hwnd      = $hwnd
                    Title     = $windowClassName
                    ClassName = $windowTitle
                }

                $PSCmdlet.WriteObject($Window)
            }

            return $true
        }

        if ($Hwnd) {
            & $proc $Hwnd 0 | Out-Null
            return
        } 

        if ($Parent) {
            [PInvoke.User32]::EnumChildWindows($parent.Hwnd, $proc, 0) | Out-Null
        }
        else {
            [PInvoke.User32]::EnumWindows($proc, 0) | Out-Null
        }
    }
}

function Remove-Window {
    param(
        [Parameter(Mandatory, ValueFromPipeline = $true)]
        [PSCustomObject]$Window
    )

    [PInvoke.User32]::PostMessage($Window.Hwnd, [PInvoke.User32+WindowMessage]::WM_CLOSE, 0, 0) | Out-Null
}