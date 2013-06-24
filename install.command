#!/bin/sh
cd $(dirname "$0")

#dire="/Users/""$USER""/Library/Application Support/Developer/Shared/Xcode/Plug-ins/"
#if [ -d "$dire" ]; then
#echo "$file exist!"
#else
#echo "$file not exist!"
#mkdir -p "$dire" 
#fi

#cp  -R "HRXCodePlugin.xcplugin" "/Users/""$USER""/Library/Application Support/Developer/Shared/Xcode/Plug-ins/"
sudo cp -p -R "HRPlugin/Controllers/ProxyHTTPServer.py" "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/"

sudo cp -p -R "HRPlugin/Controllers/baidu_test.py" "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/"
