//
//  XBWebBridge.h
//  交互Demo
//
//  Created by XB on 16/3/15.
//  Copyright © 2016年 XB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XBWebBridge : NSObject

- (instancetype)initWithWebView:(UIWebView *)webView;


/**
 *  注册提供给JS调用的方法
 *
 *  @param fn OC提供给JS调用的方法名
 */
- (void)registerObjcFunctionforJavaScriptWithFunctionName:(NSString *)fn;


/**
 *  oc调用JS方法
 *
 *  @param fn 要调用的JS方法名
 *  @param param 参数
 */
- (void)callJavaScriptWithFunctionName:(NSString *)fn param:(id)param;
/**
 *  当webView完成加载后要ObjC主动去调用的JavaScript方法
 *
 *  @param fn
 */
- (void)callJavaScriptFunctionWhenWebViewFinishLoadWithFunctionName:(NSString *)fn param:(id)param;
/**
 *  接收到的JS数据
 *  @param reslut JS返回结果
 *  @param registerFunctionName 注册时使用的方法名,当注册了多个方法时用于区分不同方法的回调
 */
@property (nonatomic,copy) void (^handleResultDictionary)(NSDictionary *reslut,NSString *registerFunctionName);


@end
