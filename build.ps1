cls

Remove-Module [p]sake

# find psake's path
$psakeModule = (Get-ChildItem (".\packages\psake*\tools\psake.psm1")).FullName | Sort-Object $_ | select -last 1

Import-Module $psakeModule

Invoke-psake     -buildFile .\Build\default.ps1 `
				 -taskList Test `
				 -framework 4.5.2 `
				 -properties @{
					 "buildConfiguration"="Release"
					 "buildPlatform" = "Any CPU"} `
				 -parameters @{
					 "solutionFile" = "..\FabrikamFiber.CallCenter.sln"}

 Write-Host "Build exit code:" $LASTEXITCODE

 # Propagating the exit code so that the build actually fails when there is a problem
 exit $LASTEXITCODE