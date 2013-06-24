//
//  HttpProxyController.m
//  test
//
//  Created by 代 震军 on 13-6-13.
//  Copyright (c) 2013年 代 震军. All rights reserved.
//

#import "HttpProxyController.h"
#include <Python.h>

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOutput:)   name:@"callback" object:nil];
}

-(void) setOutput:(NSNotification*)notification{
    NSString* replaceStr = notification.object;
    [self.serverOutput setStringValue:replaceStr];
}

-(IBAction)clearClick:(id)sender{
    [self.serverOutput setStringValue:@""];
    PyObject *svnPlugin = PyObject_GetAttrString(pModule, "console");
    PyObject *nullValue = Py_BuildValue("s", "");
    PyObject_SetAttrString(svnPlugin,"value", nullValue);
}

//http://csl.name/c-functions-from-python/
PyObject* callback(PyObject* value, PyObject* value2){
    PyObject *svnPlugin = PyObject_GetAttrString(pModule, "console");
    PyObject *output = PyObject_GetAttrString(svnPlugin,"value");
    printf("Here's the output:\n %s", PyString_AsString(output));
    NSString *result =[NSString stringWithUTF8String:PyString_AsString(output)];
    NSLog(@"%@", result);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callback" object:result];
    return output;
}

PyMethodDef ccallback_methods[]={{"callback", callback, METH_VARARGS}};

bool should_load = true;

-(void) runInBackGround{
    @try{
        Py_Initialize(); //Py_Finalize();
        Py_InitModule("CCallBack", ccallback_methods);
    //    pModule = PyImport_AddModule("__main__");
    //    PyRun_SimpleString(consoleClass);
        
        NSString* port = [self.listenPort stringValue];
        char *argv[]={ "./ProxyHTTPServer.py", [port UTF8String], NULL };
        PySys_SetArgv(2, argv);
        PyRun_SimpleString("execfile('/Users/daizhenjun/Desktop/proxhttp/proxhttp/ProxyHTTPServer.py')");
        //PyRun_SimpleString("execfile('ProxyHTTPServer.py')");
        
    //    PyObject *svnPlugin = PyObject_GetAttrString(pModule, "console");
    //    PyObject *output = PyObject_GetAttrString(svnPlugin,"value");
    //    printf("Here's the output:\n %s", PyString_AsString(output));
    //    result =[NSString stringWithUTF8String:PyString_AsString(output)];
    //    NSLog(@"%@", result);
        //result = @"OK";
        Py_Finalize();
        [[NSNotificationCenter defaultCenter] postNotificationName:@"set_callback" object:[NSString stringWithFormat:@"Serving HTTP on 0.0.0.0 port %@  ...", port]];
    }@catch (NSException* exception) {
        ;
    }

}


-(IBAction)startListenClick:(id)sender{
    [self performSelectorInBackground:@selector(runInBackGround) withObject:self];
}



@end
