# P\Invoke 

PowerShell library that includes all the P\Invoke assemblies from [Microsoft](https://github.com/dotnet/pinvoke). P\Invoke is method for calling native functions in .NET. The P\Invoke assemblies are generated based on the latest version of the Windows API.

# Install

Install the module from the PowerShell Gallery.

```powershell
Install-Module Pinvoke
```

# Use 

Call native functions directly in PowerShell.

```powershell
[PInvoke.Kernel32Dll]::LoadLibrary('myDll.dll')
```