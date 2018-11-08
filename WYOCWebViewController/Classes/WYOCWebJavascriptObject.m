//
//  WYOCWebJavascriptObject.m
//  WYOCWebViewController
//
//  Created by hero on 2018/11/8.
//

#import "WYOCWebJavascriptObject.h"
#import <YYModel/YYModel.h>

@implementation WYOCWebJavascriptObject

- (void)navigationBarView:(id)data {
    WYOCWebJavascriptModel *model = [WYOCWebJavascriptModel yy_modelWithDictionary:data];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(setNavigationBarWithModel:)]) {
        [self.delegate setNavigationBarWithModel:model];
    }
}

@end

@implementation WYOCWebJavascriptModel

@end

@implementation WYOCWebShareModel

@end
