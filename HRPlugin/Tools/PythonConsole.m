//
//  基本概念:
//  http://docs.python.org/2/library/subprocess.html
//  http://docs.python.org/release/1.5.2p1/ext/buildValue.html
//
//  about svn command
//  http://linux.chinaunix.net/techdoc/system/2008/08/05/1023350.shtml

//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

 //- (void)example {
 //
 //    PyObject *pName, *pModule, *pDict, *pFunc, *pArgs, *pValue;
 //    NSString *nsString;
 //
 //    // Initialize the Python Interpreter
 //    Py_Initialize();
 //
 //    // Build the name object
 //    pName = PyString_FromString("myModule");
 //
 //    // Load the module object
 //    pModule = PyImport_Import(pName);
 //
 //    // pDict is a borrowed reference
 //    pDict = PyModule_GetDict(pModule);
 //
 //    // pFunc is also a borrowed reference
 //    pFunc = PyDict_GetItemString(pDict, "doSomething");
 //
 //    if (PyCallable_Check(pFunc)) {
 //        pValue = PyObject_CallObject(pFunc, NULL);
 //        if (pValue != NULL) {
 //            if (PyObject_IsInstance(pValue, (PyObject *)&PyUnicode_Type)) {
 //                nsString = [NSString stringWithCharacters:((PyUnicodeObject *)pValue)->str length:((PyUnicodeObject *) pValue)->length];
 //            } else if (PyObject_IsInstance(pValue, (PyObject *)&PyBytes_Type)) {
 //                nsString = [NSString stringWithUTF8String:((PyBytesObject *)pValue)->ob_sval];
 //            } else {
 //                /* Handle a return value that is neither a PyUnicode_Type nor a PyBytes_Type */
//            }
//            Py_XDECREF(pValue);
//        } else {
//            PyErr_Print();
//        }
//    } else {
//        PyErr_Print();
//    }
//
//    // Clean up
//    Py_XDECREF(pModule);
//    Py_XDECREF(pName);
//
//    // Finish the Python Interpreter
//    Py_Finalize();
//
//    NSLog(@"%@", nsString);
//}

//-(void) PythonTest{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    Py_Initialize();
//
//    // import urllib
//    PyObject *mymodule = PyImport_Import(PyString_FromString("urllib"));
//    // thefunc = urllib.urlopen
//    PyObject *thefunc = PyObject_GetAttrString(mymodule, "urlopen");
//
//    // if callable(thefunc):
//    if(thefunc && PyCallable_Check(thefunc)){
//        // theargs = ()
//        PyObject *theargs = PyTuple_New(1);
//
//        // theargs[0] = "http://www.baidu.com"
//        PyTuple_SetItem(theargs, 0, PyString_FromString("http://www.baidu.com"));
//
//        // f = thefunc.__call__(*theargs)
//        PyObject *f = PyObject_CallObject(thefunc, theargs);
//
//        //read = f.read
//        PyObject *read = PyObject_GetAttrString(f, "read");

//        result = read.__call__()
//        PyObject *result = PyObject_CallObject(read, NULL);
//
//
//        if(result != NULL){
//            // print result
//            printf("Result of call: %s", PyString_AsString(result));
//            NSString *resultNS = [[[NSString alloc] initWithUTF8String:PyString_AsString(result)] autorelease];
//            NSLog(@"Python call : %@", resultNS);
//        }
//    }
//    [pool release];
//}




//-(void) SVNCommit{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    Py_Initialize();
//    
//    // import subprocess
//    PyObject *mymodule = PyImport_Import(PyString_FromString("subprocess"));
//    PyObject *thefunc = PyObject_GetAttrString(mymodule, "Popen");
//    
//    if(thefunc && PyCallable_Check(thefunc)){
//        @try{
//            PyObject *theargs = PyTuple_New(4);
            //PyTuple_SetItem(theargs, 0, Py_BuildValue("sssss", "svn", "commit", "-m", "log-info", "/users/daizhenjun/Desktop/Discuz_IOS_NEW"));
//follow code run wrong
//            PyTuple_SetItem(theargs, 1, PyString_FromString("shell=Flase"));
//            PyTuple_SetItem(theargs, 2, PyString_FromString("stdout=subprocess.STDOUT"));
//            PyTuple_SetItem(theargs, 3, PyString_FromString("stderr=subprocess.STDOUT"));
//            
//            
//            PyObject *f = PyObject_CallObject(thefunc, theargs);
//            if(f == NULL){
//                NSLog(@"SVN Python call");
//            }
//            PyObject *stdout_io = PyObject_GetAttrString(f, "stdout");
            //PyObject *read = PyObject_GetAttrString(stdout_io, "readline");
            //
             //            PyObject *result = PyObject_CallObject(read, NULL);
            //
            //            //curline = p.stdout.readline()
            //
            //            if(result != NULL){
            //                printf("Result of call: %s", PyString_AsString(result));
            //                const char* resultChar = PyString_AsString(result);
            //
            //                    NSString *resultNS =[NSString stringWithUTF8String:resultChar];
            //                    NSLog(@"SVN Python call : %@", resultNS);
            //            }
//        }
//        @catch (NSException *exception) {
//            NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
//        }
//    }
//    [pool release];
//}


#include <Python.h>
#import "Serializer.h"
#import "PythonConsole.h"
#import "DZTools.h"

@implementation PythonConsole

//python from: http://stackoverflow.com/questions/4307187/how-to-catch-python-stdout-in-c-code
static char* consoleClass =
"import sys\n\
import os\n\
import subprocess\n\
import commands\n\
class Console:\n\
    def __init__(self):\n\
        self.value = ''\n\
    def write(self, txt):\n\
        self.value += txt\n\
\n\
console = Console()\n\
sys.stdout = console\n\
sys.stderr = console\n\
";

//NSString* localUrl = @"/users/daizhenjun/Desktop/Discuz_IOS_NEW1";
//NSString* localUrl = @"/users/daizhenjun/Desktop/dzj-version/test123";
//http://bj-scm.tencent.com/dz/dz_mobile_rep/IOS_proj/branches/dzj-version

+(void) showMessage:(NSString*) message{
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    //当有错误提示时
    if([DZTools isValidString: message] && ![message isEqualTo:@"\n"]) {
        message = [message stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if(message.length > 500){
            message = [[message substringToIndex:500] stringByAppendingString:@"\n......"];
        }
        [alert setMessageText: message];
    }else{
        [alert setMessageText:@"操作成功!"];
    }
    [alert runModal];
}


+(NSString*) RunConsole:(NSString*) commandLine{
    Py_Initialize();
    PyObject *pModule = PyImport_AddModule("__main__");
    PyRun_SimpleString(consoleClass);
    //PyRun_SimpleString("print(1+1)");
    //NSLog(@"SVN Python : %@", commandLine);
    PyRun_SimpleString([commandLine UTF8String]);
    PyObject *svnPlugin = PyObject_GetAttrString(pModule, "console");
    PyObject *output = PyObject_GetAttrString(svnPlugin,"value");
    printf("Here's the output:\n %s", PyString_AsString(output));
    NSString *result =[NSString stringWithUTF8String:PyString_AsString(output)];
    Py_Finalize();
    return result;
}

+(NSString*) getSVNConfig{
    CommonConfig *config = [CommonConfig get:COMMON_CONFIG_KEY];
    if(config == nil || ![DZTools isValidString:config.svnPath] ){
        [PythonConsole showMessage:@"svn本地版本无效，请在该插件的Config中设置!"];
        return nil;
    }
    return config.svnPath;
}

+(void) SVNCommit:(NSString*)log{
    //http://hi.baidu.com/all3g/item/09f3d6f8d3e7c428753c4cfc
    NSString* localUrl = [PythonConsole getSVNConfig];
    if(localUrl != nil){
        NSString* command = [NSString stringWithFormat:@"print(subprocess.Popen(['svn', 'commit', '-m', '%@', '%@'],stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True).communicate()[1].encode())", (log == NULL) ? @"commit-files" : log, localUrl];
        [PythonConsole showMessage:[PythonConsole RunConsole:command]];
    }
}

+(NSString*) getGitConfig{
    CommonConfig *config = [CommonConfig get:COMMON_CONFIG_KEY];
    if(config == nil || ![DZTools isValidString:config.gitPath] ){
        [PythonConsole showMessage:@"git本地版本无效，请在该插件的Config中设置!"];
        return nil;
    }
    return config.gitPath;
}


+(void) SVNUpdate{
    NSString* localUrl = [PythonConsole getSVNConfig];
    if(localUrl != nil){
        NSString* command = [NSString stringWithFormat:@"print(subprocess.Popen(['svn', 'update', '%@'],stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True).communicate()[0].encode())", localUrl];
        [PythonConsole showMessage:[PythonConsole RunConsole:command]];
    }
}

+(void) SVNCleanup{
    NSString* localUrl = [PythonConsole getSVNConfig];
    if(localUrl != nil){
        NSString* command = [NSString stringWithFormat:@"print(subprocess.Popen(['svn', 'cleanup', '%@'],stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True).communicate()[1].encode())", localUrl];
        [PythonConsole showMessage:[PythonConsole RunConsole:command]];
    }
}

+(void) SVNLog{
    NSString* localUrl = [PythonConsole getSVNConfig];
    if(localUrl != nil){
        NSString* command = [NSString stringWithFormat:@"print(subprocess.Popen(['svn', 'log', '%@'],stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True).communicate()[0])", localUrl];
        [PythonConsole showMessage:[PythonConsole RunConsole:command]];
    }
}

+(void) SVNAdd{
    NSString* localUrl = [PythonConsole getSVNConfig];
    if(localUrl != nil){
        NSString* command = [NSString stringWithFormat:@"print(subprocess.Popen(['svn', 'add', '--force', '%@'],stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True).communicate()[1])", localUrl];
        [PythonConsole RunConsole:command];
        [PythonConsole SVNCommit:@"add-files"];
    }
}


+(void) GitCommit:(NSString*)log{
    //http://hi.baidu.com/all3g/item/09f3d6f8d3e7c428753c4cfc
    NSString* localUrl = [PythonConsole getGitConfig];
    if(localUrl != nil){
        NSString* command = [NSString stringWithFormat:@"print(os.popen('cd \"%@\";git commit -m  \"%@\" \"%@\";git push origin master').read().replace('#', ''))", localUrl,  (log == NULL) ? @"commit-files" : log, localUrl];
        [PythonConsole showMessage:[PythonConsole RunConsole:command]];
    }
}

+(void) GitPull{
    NSString* localUrl = [PythonConsole getGitConfig];
    if(localUrl != nil){
        NSString* command = [NSString stringWithFormat:@"print(os.popen('cd \"%@\";git pull \"%@\"').read().replace('#', ''))", localUrl, localUrl];
        [PythonConsole showMessage:[PythonConsole RunConsole:command]];
    }
}

+(void) GitStatus{
    NSString* localUrl = [PythonConsole getGitConfig];
    if(localUrl != nil){
        NSString* command = [NSString stringWithFormat:@"print(os.popen('cd \"%@\";git status \"%@\"').read().replace('#', ''))", localUrl, localUrl];
        
        [PythonConsole showMessage:[PythonConsole RunConsole:command]];
    }
}

+(void) GitAdd{
    NSString* localUrl = [PythonConsole getGitConfig];
    if(localUrl != nil){
        NSString* command = [NSString stringWithFormat:@"print(os.popen('cd \"%@\";git add --force  \"%@\"').read().replace('#', ''))", localUrl, localUrl];
        [PythonConsole RunConsole:command];
        [PythonConsole GitCommit:@"add-files"];
    }
}

-(void) PythonTest{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Py_Initialize();
    
    // import urllib
    PyObject *mymodule = PyImport_Import(PyString_FromString("ProxyHTTPServer.py"));
    // thefunc = urllib.urlopen
    PyObject *thefunc = PyObject_GetAttrString(mymodule, "urlopen");
    
    // if callable(thefunc):
    if(thefunc && PyCallable_Check(thefunc)){
        // theargs = ()
        PyObject *theargs = PyTuple_New(1);
        
        // theargs[0] = "http://www.baidu.com"
        PyTuple_SetItem(theargs, 0, PyString_FromString("http://www.baidu.com"));
        
        // f = thefunc.__call__(*theargs)
        PyObject *f = PyObject_CallObject(thefunc, theargs);
        
        //read = f.read
        PyObject *read = PyObject_GetAttrString(f, "read");
        
//        result = read.__call__()
//        PyObject *result = PyObject_CallObject(read, NULL);
//        
//        
//        if(result != NULL){
//            // print result
//            printf("Result of call: %s", PyString_AsString(result));
//            NSString *resultNS = [[[NSString alloc] initWithUTF8String:PyString_AsString(result)] autorelease];
//            NSLog(@"Python call : %@", resultNS);
//        }
    }
    [pool release];
}

@end
