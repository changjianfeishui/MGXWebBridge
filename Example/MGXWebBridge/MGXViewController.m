//
//  MGXViewController.m
//  MGXWebBridge
//
//  Created by 329735967@qq.com on 11/05/2018.
//  Copyright (c) 2018 329735967@qq.com. All rights reserved.
//

#import "MGXViewController.h"
#import "MGXWebBridge.h"

@interface MGXViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) MGXWebBridge  *bridge;

@end

@implementation MGXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"混合开发示例";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"callJS" style:UIBarButtonItemStylePlain target:self action:@selector(send2JS)];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"bridge-raw"ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.bridge = [[MGXWebBridge alloc]initWithWebView:self.webView];
    [self.bridge registerObjcFuncForJS:@"liveCallHanlder"];
    __weak typeof(self) weakSelf = self;
    self.bridge.JSHander = ^id(NSString * _Nonnull funcName, NSArray * _Nonnull params) {
        NSLog(@"%@===%@",funcName,params);
        if ([funcName isEqualToString:@"liveCallHanlder"]) {
            return [weakSelf liveCallHanlder];
        }
        return nil;
    };

}

- (NSString *)liveCallHanlder
{
    return @"abcdefg";
}


- (void)send2JS
{
    NSDictionary *param = @{
                            @"name":@"lilei",
                            @"age":@"13",
                            @"sex":@"1",
                            @"friends":@[@"han",@"li"]
                            };
    //support param type: NSString , NSArray, NSDictionary
    [self.bridge invokeJSFunc:@"ajaxResult.list" params:param];
    
}

@end
