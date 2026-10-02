
# [The Choicer Voicer](https://yeahmaybe.itch.io/the-choicer-voicer) Android recompiler
It downloads tools needed, recovers the Godot project, patches it then compiles it to Android
## Optional
If you have these following files, you can put it in the root directory:
`Godot_v4.4.1-stable_win64.exe` (rename it to Godot.exe),
`gdre_tools.exe`, `gdre_tools.pck` and `GodotMonoDecompNativeAOT.dll`
## Usage
You need to have TheChoicerVoicer*.exe (any versions of The Choicer Voicer will work)

**You will need to sign the apk yourself!**
#### With PowerShell in the root directory type:
```console
.\script.ps1
```
## TODO
- Add a way to sign the apk automaticaly

## Credit:

- [Godot RE Tools v2.6.4](https://github.com/GDRETools/gdsdecomp/)
- [Godot v4.4.1](https://github.com/godotengine/godot/)
- [YeahMaybe](https://yeahmaybe.itch.io/) for making this awesome game
