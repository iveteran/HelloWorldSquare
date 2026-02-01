# PowerShell module uage:
refer: https://developer.aliyun.com/article/1430304

## Show modules path
```
$Env:PSModulePath
```
Or:
```
Get-ChildItem Env:
```

## Find modules:
```
Find-Module [[-Name] <string[]>]
```

## List installed modules:
```
Get-InstalledModule
```

## List available modules:
```
Get-Module -ListAvailable
```

## Install module
Install-Module [-Name] <ModuleName>

## Install Useful Modules:
```
Install-Module PsReadline -Scope CurrentUser
Install-Module -Name ZLocation
Install-Module PSCompletions
```

## Uninstall module
```
Uninstall-Module [-Name] <ModuleName>
```

## Update module
Update-Module [ModuleName]
