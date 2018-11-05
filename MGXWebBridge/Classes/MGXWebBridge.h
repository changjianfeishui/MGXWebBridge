//
//  MGXWebBridge.h
//  MGXWebBridge
//
//  Created by Miu on 2018/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MGXWebBridgeDelegate <NSObject>
/**
 webView加载完成
 */
- (void)mgx_webViewDidFinishLoad:(UIWebView *)webView;

/**
 webView加载失败
 */
- (void)mgx_webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end


@interface MGXWebBridge : NSObject

@property (nonatomic,weak) id<MGXWebBridgeDelegate> delegate;


/**
 创建MGXWebBridge
 
 @param webView 需要与JS进行交互的UIWebView对象
 @return MGXWebBridge Obj
 */
- (instancetype)initWithWebView:(UIWebView *)webView;


/**
 注册Objc方法,供JS调用

 @param aObjcFuncName Objc方法名称
 @discussion 延迟到webView加载完成后才会执行真正的注册
 */
- (void)registerObjcFuncForJS:(NSString *)aObjcFuncName;

/**
 调用JS方法

 @param aJSFuncName JS方法名称
 @param params 调用参数, 支持NSString, NSArray, NSDictionary
 @discussion 调用时需要注意js是否加载完成
 */
- (void)invokeJSFunc:(NSString *)aJSFuncName params:(nullable id)params;


/**
 响应JS调用
 无返回值则return nil
 */
@property (nonatomic,copy) id (^JSHander)(NSString *funcName,NSArray *params);

@end

NS_ASSUME_NONNULL_END
