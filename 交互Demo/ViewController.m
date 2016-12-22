//
//  ViewController.m
//  交互Demo
//
//  Created by XB on 15/12/17.
//  Copyright © 2015年 XB. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "XBWebBridge.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) JSContext  *context; /**< note*/
@property (nonatomic,strong) XBWebBridge  *bridge; /**< <#note#>*/

@property (nonatomic,copy) NSString  *callBack; /**<     要回调的JS方法名*/

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"混合开发示例";  
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"send2JS" style:UIBarButtonItemStyleDone target:self action:@selector(send2JS)];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"bridge-raw"ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    __weak typeof(self) weakSelf = self;
    self.bridge = [[XBWebBridge alloc]initWithWebView:self.webView];
    [self.bridge registerObjcFunctionforJavaScript:@"liveCallHanlder" isNeedReturn:NO];
    [self.bridge registerObjcFunctionforJavaScript:@"liveAjax" isNeedReturn:NO];

    self.bridge.JSCallHandlerNoReturn = ^(NSArray *args,NSString *registerFunctionName){
        if ([registerFunctionName isEqualToString:@"liveCallHanlder"]) {
            NSLog(@"liveCallHanlder === %@",args);
        }else{
            NSLog(@"liveAjax === %@",args);
        }
    };
}


- (void)send2JS
{
    NSDictionary *param = @{
                            @"name":@"lilei",
                            @"age":@"13",
                            @"sex":@"1",
                            @"friends":@[@"han",@"li"]
                            
                            };

    [self.bridge callJavaScriptFunction:@"liveAjaxResult.guardList" param:param];
}


@end
