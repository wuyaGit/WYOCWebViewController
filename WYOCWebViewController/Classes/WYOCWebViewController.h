//
//  WYOCWebViewController.h
//  WYOCWebViewController
//
//  Created by hero on 2018/11/7.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <dsBridge/dsBridge.h>
#import "WYOCWebJavascriptObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WYOCWebViewController : UIViewController

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) WYOCWebJavascriptObject *javascriptObject;// Native 实现API代理类

@end

NS_ASSUME_NONNULL_END
