//
//  WYOCWebViewControllerViewController.m
//  WYOCWebViewController
//
//  Created by 407671883@qq.com on 11/07/2018.
//  Copyright (c) 2018 407671883@qq.com. All rights reserved.
//

#import "WYOCWebViewControllerViewController.h"

#import <WYOCWebViewController/WYOCWebViewController.h>

@interface WYOCWebViewControllerViewController ()

@end

@implementation WYOCWebViewControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [WYOCWebViewcManager routeWebController:@"https://www.jianshu.com/p/0f69030e9cb3" showStyle:WYWControllerShowStylePush];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    WYOCWebViewController *controller = [[WYOCWebViewController alloc] init];
    controller.params = @{WYWC_WEBPARAMS_PATH: @"https://www.jianshu.com/p/0f69030e9cb3",
                          WYWC_WEBPARAMS_HIDDENNAVBAR: @(NO)
                          };
    
    UINavigationController *wrappedNav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:wrappedNav animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
