$URL1 = "https://github.com/GDRETools/gdsdecomp/releases/download/v2.6.4/GDRE_tools-v2.6.4-windows.zip"
$URL2 = "https://github.com/godotengine/godot/releases/download/4.4.1-stable/Godot_v4.4.1-stable_win64.exe.zip"
$URL3 = "https://godot-releases.nbg1.your-objectstorage.com/4.4.1-stable/Godot_v4.4.1-stable_export_templates.tpz"
$GDREPresent = Get-ChildItem . -Filter "*gdre*"
if ( !$GDREPresent )
{
    Write-Host "Downloading Godot RE Tools..."
    Invoke-WebRequest -Uri $URL1 -OutFile output.zip
    Write-Host "Extracting Godot RE Tools..."
    Expand-Archive -Path output.zip -DestinationPath .
    Remove-Item ./output.zip
}
Write-Host "Searching TheChoicerVoicer*.exe in current dir"
$GamePath = Get-ChildItem . -Filter "*TheChoicerVoicer*.exe"
$ProjectPath = Get-ChildItem . -Filter "*TheChoicerVoicer*" -Attributes D
$ProjectPresent = Get-ChildItem $ProjectPath -Filter "project.godot"
if ( !$ProjectPresent )
{
    Write-Host "Recovering project..."
    .\gdre_tools --recover=$GamePath
    Start-Sleep 20
}
$ProjectPath = Get-ChildItem . -Filter "*TheChoicerVoicer*" -Attributes D
Write-Host "Adding Android export preset..."
Copy-Item ./export_presets.cfg -Destination $ProjectPath
Write-Host "Patching files..."
# changing user:// to Documents/YeahMaybe/TCV because the user folder is unaccessible
Get-ChildItem -Path $ProjectPath -File -Recurse | ForEach-Object {
    $file = $_;
    $content = Get-Content -Path $file.FullName -Raw;
    $newContent = $content -replace 'user://', '/sdcard/Documents/YeahMaybe/The Choicer Voicer/';
    
    if ($content -ne $newContent) {
        Set-Content -Path $file.FullName -Value $newContent;
    }
}
# using opengl for better stability
if (!(Select-String -Path $ProjectPath\project.godot -Pattern 'renderer/rendering_method.mobile="gl_compatibility"'))
{
    Add-Content -Path $ProjectPath\project.godot -Value 'renderer/rendering_method.mobile="gl_compatibility"'
    Add-Content -Path $ProjectPath\project.godot -Value 'textures/vram_compression/import_etc2_astc=true'
}
Write-Host "Searching Godot binary"
$GodotPath = Get-ChildItem . -Filter "Godot.exe"
if ( !$GodotPath )
{
    Write-Host "Downloading Godot..."
    Invoke-WebRequest -Uri $URL2 -OutFile output.zip
    Write-Host "Extracting Godot..."
    Expand-Archive -Path output.zip -DestinationPath .
    Remove-Item ./output.zip
    $OldGodotPath = Get-ChildItem . -Filter "*Godot*win64.exe"
    Rename-Item -Path $OldGodotPath -NewName Godot.exe
    $ConsoleGodotPath = Get-ChildItem . -Filter "*Godot*win64_console.exe"
    Remove-Item $ConsoleGodotPath
}
$ExportTemplate = Get-ChildItem "$env:APPDATA\Godot\export_templates\4.4.1.stable" -Filter "android*"
if ( !$ExportTemplate )
{
    Write-Host "Downloading Android export template..."
    Invoke-WebRequest -Uri $URL3 -OutFile output.zip
    Expand-Archive -Path output.zip -DestinationPath "$env:APPDATA\Godot\export_templates\4.4.1.stable"
    $AndroidTemplate = Get-ChildItem "$env:APPDATA\Godot\export_templates\4.4.1.stable\templates" -Filter "android_release*"
    Copy-Item  $AndroidTemplate -Destination "$env:APPDATA\Godot\export_templates\4.4.1.stable\"
    Remove-Item "$env:APPDATA\Godot\export_templates\4.4.1.stable\templates"
}
Write-Host "Compiling Android project..."
.\Godot --path $ProjectPath --headless --export-release "Android" TheChoicerVoicer.apk
Copy-Item $ProjectPath/TheChoicerVoicer.apk -Destination .
Remove-Item $ProjectPath/TheChoicerVoicer.apk