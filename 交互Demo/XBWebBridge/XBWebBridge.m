//
//  XBWebBridge.m
//  交互Demo
//
//  Created by XB on 16/3/15.
//  Copyright © 2016年 XB. All rights reserved.
//

#import "XBWebBridge.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface XBWebBridge()<UIWebViewDelegate>
@property (nonatomic,copy) NSString  *fn; /**<      */
@property (nonatomic,weak) UIWebView  *webView; /**< */

@property (nonatomic,strong) NSMutableArray  *fns; /**< */
@property (nonatomic,strong) NSMutableArray  *returnTypes; /**< */


@property (nonatomic,copy) NSString  *loadedFn; /**<      webview加载完成后调用的fn*/
@property (nonatomic,strong) id loadedParam; /**< webview加载完成后调用的fn的参数*/
@end

@implementation XBWebBridge


- (void)dealloc
{
    self.webView.delegate = nil;
    [self.webView stopLoading];
}

- (instancetype)initWithWebView:(UIWebView *)webView
{
    if (self = [super init]) {
        self.webView = webView;
        self.fns = [NSMutableArray array];
        self.returnTypes = [NSMutableArray array];
        self.webView.delegate = self;
    }
    return self;
}


- (void)registerObjcFunctionforJavaScript:(NSString *)fn isNeedReturn:(BOOL)isNeedReturn
{
    [self.fns addObject:fn];
    [self.returnTypes addObject:@(isNeedReturn)];
}

#pragma - mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setupBridgeWithNativeFunctionName];
    [self callJavaScriptFunction:self.loadedFn param:self.loadedParam];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.failLoadWithError) {
        self.failLoadWithError(error);
    }
}

#pragma - mark Public Method
- (void)setupBridgeWithNativeFunctionName
{
    JSContext  *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) weakSelf = self;
    //注册给JS调用的方法,用来接收JS传递过来的参数
    for (int i = 0; i < self.fns.count; i++) {
        
        //要注册的方法名
        NSString *fn = self.fns[i];
        //要注册方法的返回值
        BOOL needReturn = [self.returnTypes[i] boolValue];
        if (!needReturn) { //如果没有返回值
            context[XBWebBridge.h
                    XBWebBridge.mns:0 error:nil];
                        if (!dic) {
                            dic = str;
                        }
                    }
                    [argList addObject:dic];
                }

                if (weakSelf.JSCallHandlerNoReturn) {
                    weakSelf.JSCallHandlerNoReturn(argList,fn);
                }
            };
        }
        else
        {
            context[fn] = ^(id returnValue) {
                NSArray *args = [JSContext currentArguments];
                NSMutableArray *argList = [NSMutableArray arrayWithCapacity:0];
                for (JSValue *jsVal in args) {
                    id dic;
                    if (jsVal.isObject) {
                        dic = [jsVal toDictionary];
                    }else if(jsVal.isString){
                        NSString *str = [jsVal toString];
                        NSData *data = [[jsVal toString] dataUsingEncoding:NSUTF8StringEncoding];
                        dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        if (!dic) {
                            dic = str;
                        }
                    }else if (jsVal.toInt32) {
                        dic = [NSString stringWithFormat:@"%d",jsVal.toInt32];
                    }else{
                        dic = @"";
                    }
                    [argList addObject:dic];
                }
                if (weakSelf.JSCallHandlerWithReturn) {
                    return weakSelf.JSCallHandlerWithReturn(argList,fn);
                }
                
                return (id)nil;
            };
        }
    }
}

- (void)callJavaScriptFunctionWhenWebViewFinishLoad:(NSString *)fn param:(id)param;
{
    self.loadedFn = fn;
    self.loadedParam = param;
}

- (void)callJavaScriptFunction:(NSString *)fn param:(id)param;
{
    NSString *jsStr;
    JSContext  *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    if (!param) {
        jsStr = [NSString stringWithFormat:@"%@()",fn];
    }else{
        NSAssert([NSJSONSerialization isValidJSONObject:param], @"参数不能JSON序列化");
        if (![NSJSONSerialization isValidJSONObject:param]) {
            return;
        }
        
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        jsStr = [NSString stringWithFormat:@"%@(%@)",fn,jsonString];
    }
    if (jsStr) {
        [NBSAppAgent setCustomerData:jsStr forKey:@"callJS"];
        [context evaluateScript:jsStr];
    }
}

@end
