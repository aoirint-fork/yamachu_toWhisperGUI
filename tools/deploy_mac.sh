#!/bin/bash

type dotnet >/dev/null 2>&1
DOTNET_EXIST=$?

if [[ $DOTNET_EXIST != 0 ]]; then
    echo 'This project required dotnet core'
    echo 'https://www.microsoft.com/net/core'
    exit 1
fi

dotnet restore src/cs
dotnet publish src/cs --runtime osx.10.12-x64 --configuration Release

./node_modules/.bin/electron-packager ./ ToWhisper --platform=darwin --arch=x64
