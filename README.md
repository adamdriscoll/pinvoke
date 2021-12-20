# P\Invoke 

PowerShell library that includes all the P\Invoke assemblies from [Microsoft](https://github.com/dotnet/pinvoke).

# Install

```powershell
Install-Module Pinvoke
```

# Use 

```powershell
[PInvoke.Kernel32Dll]::LoadLibrary('myDll.dll')
```