//
//  WYOCWebJavascriptObject.h
//  WYOCWebViewController
//
//  Created by hero on 2018/11/8.
//

#import <Foundation/Foundation.h>

#define WYWC_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define WYWC_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// iPhone X
#define WYWC_IPHONEX (WYWC_SCREEN_HEIGHT == 896.f || WYWC_SCREEN_HEIGHT == 812.f)
#define WYWC_HEIGHT_NAVBAR        ((WYWC_IPHONEX) ? 88.0f : 64.0f) //导航栏总高度（加上导航栏高度）

//#define WYWC_COLOR_HEX(rgbValue) \
//[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
//green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
//blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

///弱引用
#define WYWC_WeakObj(type) @autoreleasepool{} __weak typeof(type) type##Weak = type;

///强引用
#define WYWC_StrongObj(type) @autoreleasepool{} __strong typeof(type) type = type##Weak;

#define WYWC_WEBPARAMS_TITLE  @"title"
#define WYWC_WEBPARAMS_PATH   @"path"
#define WYWC_WEBPARAMS_HIDDENNAVBAR @"hiddenNavBar"

NS_ASSUME_NONNULL_BEGIN

@interface WYOCWebShareModel : NSObject

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *imageUrl;
@end

@interface WYOCWebJavascriptModel : NSObject

@property (nonatomic, copy) NSString *leftImg;
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *rightImg;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, copy) NSString *titleBg;
@property (nonatomic, copy) NSString *rightUrl;

@property (nonatomic, copy) WYOCWebShareModel *shareModel;
@end

@protocol WYOCWebJavascriptObjectInterface <NSObject>
@optional

/**
 * 在H5中设置原生导航栏样式
 */
- (void)setNavigationBarWithModel:(WYOCWebJavascriptModel *)model;
@end

@interface WYOCWebJavascriptObject : NSObject <WYOCWebJavascriptObjectInterface>

@property (nonatomic, weak) id<WYOCWebJavascriptObjectInterface> delegate;

// Javascript中调用Native API:https://www.jianshu.com/p/633d9fde946f
- (void)navigationBarView:(id)data;

@end

NS_ASSUME_NONNULL_END
