properties {
	$testMessage = 'Executed Test!'
	$compileMessage = 'Executed Compile!'
	$cleanMessage = 'Executed Clean'

	$solutionDirectory = (Get-Item $solutionFile).DirectoryName
	$outputDirectory = "$solutionDirectory\.build"
	$temporaryOutputDirectory = "$outputDirectory\temp"
	$buildConfiguration ="Release"
	$buildPlatform = "Any CPU"
}
FormatTaskName "`r`n`r`n ----------------Executing {0} Task ---------- "

task default -depends Test

task Init -description "Initializes the build by removing the previous artifacts
and creating output directories" -requiredVariables outputDirectory,temporaryOutputDirectory {
	Assert ("Debug","Release" -contains $buildConfiguration)`
	"Invalid build configuration '$buildConfiguration' . Valid values are 'Debug' or 'Release'"

	Assert ("x86","x64","Any CPU" -contains $buildPlatform )`
	"Invalid build platform '$buildPlatform'. Valid values are 'x86' , 'x64' or 'Any CPU' "
	# Remove previous byuild results
	if (Test-Path $outputDirectory)
	{
		Write-Host "Removing O/P directory located at $outputDirectory"
		Remove-Item $outputDirectory -Force -Recurse
	}

	Write-Host "Creating output directory located at ..\.build"
	New-Item $outputDirectory -ItemType Directory | Out-Null

	Write-Host "Creating Temperory directory located
		at $temporaryOutputDirectory"
	New-Item $temporaryOutputDirectory -ItemType Directory | Out-Null
}


task Clean  -description "Removes temperory code" {
	Write-Host $cleanMessage
	
}
 
task Compile `
     -depends Init `
	 -description "Compliles the code" `
	 -requiredVariables solutionFile,buildConfiguration,buildPlatform,temporaryOutputDirectory `
	 {
	 Write-Host "Building soltion $solutionFile"
	 Exec{
		 msbuild $solutionFile "/p:OutDir=$temporaryOutputDirectory"
		 }
	 Write-Host "Ms build completed"		 

	}
task Test -depends Compile, Clean -description "Executes the test" {
	Write-Host $testMessage
}