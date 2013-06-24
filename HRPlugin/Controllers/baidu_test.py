#!/usr/bin/env python
import urllib
import sysimport getopt

shortargs = 'f:t'#longargs = ['port=', 'format', '--f_long=']
opts, args = getopt.getopt( sys.argv[1:], shortargs ) #longargs
port = "8000"
if ( len( sys.argv ) == 2 ):    port = args[0] #print '-h or --help for detail'
#for opt, val in opts:
#    if opt in ( '-f', '--f_long' ):
#         pass

try:
    proxy = {"http":"http://127.0.0.1:"+ port}
    f = urllib.urlopen("http://www.baidu.com", proxies = proxy)#print f.read()
    #print f.read()
    print 'http header:/n', f.info()  
    print 'http status:', f.getcode()  
    print 'url:', f.geturl()  
    for line in f:  
        print line,  
    f.close()  
except:
    print "proxy fails!"



