//
//  HttpProxyController.m
//  test
//
//  Created by 代 震军 on 13-6-13.
//  Copyright (c) 2013年 代 震军. All rights reserved.
//

#import "HttpProxyController.h"
#include <Python.h>
#import "PythonConsole.h"
@interface HttpProxyController ()

@end

@implementation HttpProxyController

static char* consoleClass =
"import sys\n\
import subprocess\n\
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

PyObject *pModule;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setResponseOutput:)   name:@"responseCallBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRequestOutput:)   name:@"requestCallBack" object:nil];
}

-(void) setResponseOutput:(NSNotification*)notification{
    NSString* replaceStr = notification.object;
    [self.serverOutput setStringValue:replaceStr];
}

-(void) setRequestOutput:(NSNotification*)notification{
    NSString* replaceStr = notification.object;
    [self.clientOutput setStringValue:replaceStr];
}

-(IBAction)clearClick:(id)sender{
    [self.serverOutput setStringValue:@""];
    [self.clientOutput setStringValue:@""];
    
    PyObject *svnPlugin = PyObject_GetAttrString(pModule, "console");
    PyObject *nullValue = Py_BuildValue("s", "");
    PyObject_SetAttrString(svnPlugin,"value", nullValue);
}

//http://csl.name/c-functions-from-python/
static PyObject* responseCallBack(PyObject* value, PyObject* value2){
    PyObject *svnPlugin = PyObject_GetAttrString(pModule, "console");
    PyObject *output = PyObject_GetAttrString(svnPlugin,"value");
    printf("Here's the output:\n %s", PyString_AsString(output));
    NSString *result =[NSString stringWithUTF8String:PyString_AsString(output)];
    NSLog(@"%@", result);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"responseCallBack" object:result];
    
    //clear output for request content
    PyObject *nullValue = Py_BuildValue("s", "");
    PyObject_SetAttrString(svnPlugin,"value", nullValue);
    
    return output;
}

static PyObject* requestCallBack(PyObject* value, PyObject* value2){
    PyObject *svnPlugin = PyObject_GetAttrString(pModule, "console");
    PyObject *output = PyObject_GetAttrString(svnPlugin,"value");
    printf("Here's the output:\n %s", PyString_AsString(output));
    NSString *result =[NSString stringWithUTF8String:PyString_AsString(output)];
    NSLog(@"%@", result);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestCallBack" object:result];
    
    //clear output for response content
    PyObject *nullValue = Py_BuildValue("s", "");
    PyObject_SetAttrString(svnPlugin,"value", nullValue);
    return output;
}

static char py_add_doc[] = "Adds two numbers.";
static char py_add_doc1[] = "Adds two numbers.";
static PyMethodDef ccallback_methods[]={{"responseCallBack", responseCallBack, METH_VARARGS, py_add_doc}, {"requestCallBack", requestCallBack, METH_VARARGS, py_add_doc1},{NULL, NULL, 0, NULL}};

bool should_load = true;

-(void) runInBackGround{
    NSString* port = [self.listenPort stringValue];
    char* port_str = (char*)[port UTF8String];
    
    try{
        if(should_load == false){
            should_load = true;
            [self close];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"responseCallBack" object:[NSString stringWithFormat:@"Serving HTTP on 0.0.0.0 port %@  ...", port]];
            
            Py_Initialize();
            should_load= false;
            pModule = PyImport_AddModule("__main__");
            PyRun_SimpleString(consoleClass);
            Py_InitModule("c_notice", ccallback_methods);
            
            
            char *argv[]={ "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/ProxyHTTPServer.py", port_str, NULL };
            PySys_SetArgv(2, argv);
            [self.startListenButton setTitle:@"关闭侦听"];
            PyRun_SimpleString("execfile('/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/ProxyHTTPServer.py')");
            Py_Finalize();
            [PythonConsole showMessage:@"end2"];
            
        }
        
    }catch(NSException *e) {
        [PythonConsole showMessage:e.description];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"responseCallBack" object:@"Serving Exit!"];
    }
    
}


-(IBAction)startListenClick:(id)sender{
    [self performSelectorInBackground:@selector(runInBackGround) withObject:self];
    //[self runInBackGround];
}

-(IBAction)demoClick:(id)sender{
    NSString* port = [self.listenPort stringValue];
    char* port_str = (char*)[port UTF8String];
    
    Py_Initialize();
    char *argv[]={ "", port_str, NULL };
    PySys_SetArgv(2, argv);
    PyRun_SimpleString("execfile('/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/baidu_test.py')");
    
    Py_Finalize();
    //终端下运行  python /System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/baidu_test.py 8000
}

@end
