dotnet restore src/cs

if %platform%==x86 (
    dotnet publish src/cs --runtime win10-x86 --configuration Release
)
if %platform%==x64 (
    dotnet publish src/cs --runtime win10-x64 --configuration Release
)
if %platform%==x86 (
.\node_modules\.bin\electron-packager .\ ToWhisper --platform=win32 --arch=ia32 --ignore="node_modules/@yamachu/edge/lib/native/win32/(ia32|x64)/(4\.1\.1|5\.1\.0|6\.4\.0|7\.10\.0|8\.2\.1|electron-1\.3\.13|electron-1\.4\.16|electron-1\.6\.11)" --ignore="\.git(ignore|modules)" --ignore="\.travis\.yml" --ignore="appveyor\.yml" --ignore="tools" --ignore="ToWhisper-win32-x64" --ignore="src/cs/bin/Release/netstandard1\.6/win10-x64"
)
if %platform%==x64 (
.\node_modules\.bin\electron-packager .\ ToWhisper --platform=win32 --arch=x64 --ignore="node_modules/@yamachu/edge/lib/native/win32/(ia32|x64)/(4\.1\.1|5\.1\.0|6\.4\.0|7\.10\.0|8\.2\.1|electron-1\.3\.13|electron-1\.4\.16|electron-1\.6\.11)" --ignore="\.git(ignore|modules)" --ignore="\.travis\.yml" --ignore="appveyor\.yml" --ignore="tools" --ignore="ToWhisper-win32-ia32" --ignore="src/cs/bin/Release/netstandard1\.6/win10-x86"
)
