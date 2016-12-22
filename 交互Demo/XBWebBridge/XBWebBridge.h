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
 注册提供给JS调用的方法

 @param fn 方法名
 */
- (void)registerObjcFunctionforJavaScript:(NSString *)fn isNeedReturn:(BOOL)isNeedReturn;

/**
 *  oc调用JS方法
 *
 *  @param fn 要调用的JS方法名
 *  @param param 参数
 */
- (void)callJavaScriptFunction:(NSString *)fn param:(id)param;


/**
 *  当webView完成加载后要ObjC主动去调用的JavaScript方法
 *
 *  @param fn
 */
- (void)callJavaScriptFunctionWhenWebViewFinishLoad:(NSString *)fn param:(id)param;

/**
 *  处理webView加载失败的情况
 *
 *  @param error 
 */
@property (nonatomic,copy)  void  (^failLoadWithError)(NSError *error);

/**
 *  接收到的JS数据, 对数据进行处理后需要返回
 *  @param args JS传过来的参数列表
 *  @param fn 注册时使用的方法名,当注册了多个方法时用于区分不同方法的回调
 */
@property (nonatomic,copy) id (^JSCallHandlerWithReturn)(NSArray *args,NSString *fn);

/**
 *  接收到的JS数据, 只接收数据,不需要返回
 *  @param args JS传过来的参数列表
 *  @param fn 注册时使用的方法名,当注册了多个方法时用于区分不同方法的回调
 */
@property (nonatomic,copy) void (^JSCallHandlerNoReturn)(NSArray *args,NSString *fn);

@end
