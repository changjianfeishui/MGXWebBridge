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

@property (nonatomic,copy) NSString  *loadedFn; /**<      webview加载完成后调用的fn*/
@property (nonatomic,strong) id loadedParam; /**< webview加载完成后调用的fn的参数*/
@end

@implementation XBWebBridge

- (instancetype)initWithWebView:(UIWebView *)webView
{
    if (self = [super init]) {
        self.webView = webView;
        self.fns = [NSMutableArray array];
        self.webView.delegate = self;
    }
    return self;
}


- (void)registerObjcFunctionforJavaScriptWithFunctionName:(NSString *)fn
{
    [self.fns addObject:fn];
}


#pragma - mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setupBridgeWithNativeFunctionName];
    [self callJavaScriptWithFunctionName:self.loadedFn param:self.loadedParam];

}

#pragma - mark Public Method
- (void)setupBridgeWithNativeFunctionName
{
    JSContext  *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) weakSelf = self;
    //注册给JS调用的方法,用来接收JS传递过来的参数
    for (int i = 0; i < self.fns.count; i++) {
        NSString *fn = self.fns[i];
        context[fn] = ^() {
            NSArray *args = [JSContext currentArguments];
            for (JSValue *jsVal in args) {
                NSDictionary * dic = [jsVal toDictionary];
                if (weakSelf.handleResultDictionary) {
                    weakSelf.handleResultDictionary(dic,fn);
                }
            }
        };
    }
}

- (void)callJavaScriptFunctionWhenWebViewFinishLoadWithFunctionName:(NSString *)fn param:(id)param
{
    self.loadedFn = fn;
    self.loadedParam = param;
}

- (void)callJavaScriptWithFunctionName:(NSString *)fn param:(id)param
{
    NSString *jsStr;
    JSContext  *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    if (!param) {
        jsStr = [NSString stringWithFormat:@"%@()",fn];
    }else{
        NSAssert([NSJSONSerialization isValidJSONObject:param], @"参数不能JSON序列化");
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        jsStr = [NSString stringWithFormat:@"%@(%@)",fn,jsonString];
    }
    [context evaluateScript:jsStr];
}

@end
