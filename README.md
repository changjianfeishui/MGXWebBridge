# MGXWebBridge

[![CI Status](https://img.shields.io/travis/329735967@qq.com/MGXWebBridge.svg?style=flat)](https://travis-ci.org/329735967@qq.com/MGXWebBridge)
[![Version](https://img.shields.io/cocoapods/v/MGXWebBridge.svg?style=flat)](https://cocoapods.org/pods/MGXWebBridge)
[![License](https://img.shields.io/cocoapods/l/MGXWebBridge.svg?style=flat)](https://cocoapods.org/pods/MGXWebBridge)
[![Platform](https://img.shields.io/cocoapods/p/MGXWebBridge.svg?style=flat)](https://cocoapods.org/pods/MGXWebBridge)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
JS to Objc:

```
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

```

Objc to JS: 

```
    NSDictionary *param = @{
                            @"name":@"lilei",
                            @"age":@"13",
                            @"sex":@"1",
                            @"friends":@[@"han",@"li"]
                            };
    //support param type: NSString , NSArray, NSDictionary
    [self.bridge invokeJSFunc:@"ajaxResult.list" params:param];
```


## Requirements
iOS 7.0

## Installation

MGXWebBridge is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MGXWebBridge'
```


## License

MGXWebBridge is available under the MIT license. See the LICENSE file for more info.
