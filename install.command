#!/bin/sh
cd $(dirname "$0")

dire="/Users/""$USER""/Library/Application Support/Developer/Shared/Xcode/Plug-ins/"
if [ ! -d "$dire" ]
then
   mkdir -p "$dire" 
fi

sudo cp -p -R "HRXCodePlugin.xcplugin/ProxyHTTPServer.py" "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/"

sudo cp -p -R "HRXCodePlugin.xcplugin/baidu.py" "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/"

cp  -R "HRXCodePlugin.xcplugin" "/Users/""$USER""/Library/Application Support/Developer/Shared/Xcode/Plug-ins/"


echo "HRPlugin install successfully!"