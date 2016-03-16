# 一个简单的ObjC与JavaScript交互封装

项目中涉及到ObjC与JavaScript交互,于是封装了一个简单的`XBWebBridge`.

[个人博客链接](http://coderzhang.xyz)

## 使用方法

* 1.导入`JavaScriptCore.framework`
* 2.导入`XBWebBridge.h`
* 3.创建`XBWebBridge`对象
	
	    self.bridge = [[XBWebBridge alloc]initWithWebView:self.webView];
	    
* 4.注册给JS调用的方法(JS中通过注册使用的方法名调用ObjC):

		[self.bridge registerObjcFunctionforJavaScriptWithFunctionName:@"liveCallHanlder"];
		[self.bridge registerObjcFunctionforJavaScriptWithFunctionName:@"liveAjax"];

* 5.处理JS传递到ObjC的参数:

	    __weak typeof(self) weakSelf = self;
	    self.bridge.handleResultDictionary = ^(NSDictionary *result,NSString *registerFunctionName){
        if ([registerFunctionName isEqualToString:@"liveCallHanlder"]) {
            NSLog(@"liveCallHanlder === %@",result);
        }else{
            NSLog(@"liveAjax === %@",result);
        }
        weakSelf.callBack = result[@"callBack"];
    };

* 6.Objc调用JS方法:

	    NSDictionary *param = @{
                            @"name":@"lilei",
                            @"age":@"13",
                            @"sex":@"1",
                            @"friends":@[@"han",@"li"]
                            
                            };
   		[self.bridge callJavaScriptWithFunctionName:self.callBack param:param];
