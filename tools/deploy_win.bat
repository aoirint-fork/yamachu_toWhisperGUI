dotnet restore src/cs
dotnet publish src/cs --runtime win10-x86 --configuration Release

./node_modules/.bin/electron-packager ./ ToWhisper --platform=win32 --arch=x64
