//
//  MGXWebBridge.m
//  MGXWebBridge
//
//  Created by Miu on 2018/11/5.
//

#import "MGXWebBridge.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface MGXWebBridge()<UIWebViewDelegate>
@property (nonatomic,weak)   UIWebView  *webView;
@property (nonatomic,strong) NSMutableArray  *fns;
@property (nonatomic,assign,getter=isWebFinish) BOOL webFinish;
@end

@implementation MGXWebBridge
#pragma mark LifeCycle
- (void)dealloc
{
    [_webView stopLoading];
    _webView = nil;
}
- (instancetype)initWithWebView:(UIWebView *)webView
{
    if (self = [super init]) {
        _webView = webView;
        _webView.delegate = self;
        _fns = [NSMutableArray array];
    }
    return self;
}
#pragma mark Event
- (void)registerObjcFuncForJS:(NSString *)aObjcFuncName
{
    if (self.webFinish) {
        [self realRegisterObjcFunc:aObjcFuncName];
    }else{
        [self.fns addObject:aObjcFuncName];
    }
}

- (void)registerCachedObjcFuncs
{
    for (NSString *funcName in self.fns) {
        [self realRegisterObjcFunc:funcName];
    }
}

- (void)realRegisterObjcFunc:(NSString *)aObjcFuncName
{
    JSContext  *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) weakSelf = self;
    context[aObjcFuncName] = ^id(){
        NSArray *args = [JSContext currentArguments];
        NSMutableArray *format = [NSMutableArray arrayWithCapacity:args.count];
        for (JSValue *js in args) {
            if (js.isObject) {
                [format addObject:[js toDictionary]];
            }else if (js.isString){
                NSString *str = [js toString];
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (dic) {
                    [format addObject:dic];
                }else{
                    [format addObject:str];
                }
            }else if (js.isNumber){
                [format addObject:[js toNumber]];
            }else if (js.isDate){
                [format addObject:[js toDate]];
            }else if (js.isArray){
                [format addObject:[js toArray]];
            }else{
                NSLog(@"MGXWebBridge_unsupported===%@",js);
            }
            if (weakSelf.JSHander) {
                return weakSelf.JSHander(aObjcFuncName,format);
            }
        }
        return nil;
    };
}

- (void)invokeJSFunc:(NSString *)aJSFuncName params:(id)params
{
    NSString *jsStr;
    JSContext  *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    if (!params) {
        jsStr = [NSString stringWithFormat:@"%@()",aJSFuncName];
    }else{
        if (![NSJSONSerialization isValidJSONObject:params]) {
            NSString *paramsStr = [NSString stringWithFormat:@"\"%@\"",params];
            jsStr = [NSString stringWithFormat:@"%@(%@)",aJSFuncName,paramsStr];
        }else{
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
            NSString *jsonString = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            jsStr = [NSString stringWithFormat:@"%@(%@)",aJSFuncName,jsonString];
        }
    }
    if (jsStr) {
        [context evaluateScript:jsStr];
    }
}

#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webFinish = YES;
    [self registerCachedObjcFuncs];
    if ([self.delegate respondsToSelector:@selector(mgx_webViewDidFinishLoad:)]) {
        [self.delegate mgx_webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.webFinish = NO;
    if ([self.delegate respondsToSelector:@selector(mgx_webView:didFailLoadWithError:)]) {
        [self.delegate mgx_webView:webView didFailLoadWithError:error];
    }
}

@end
