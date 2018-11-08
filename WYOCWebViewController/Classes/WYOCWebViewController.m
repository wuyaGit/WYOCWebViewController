//
//  WYOCWebViewController.m
//  WYOCWebViewController
//
//  Created by hero on 2018/11/7.
//

#import "WYOCWebViewController.h"
#import "WKCookieSyncManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <YYCategories/UIColor+YYAdd.h>

@interface WYOCWebViewController () <WKNavigationDelegate, WYOCWebJavascriptObjectInterface>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) DWKWebView *webView;
@property (nonatomic, strong) WYOCWebJavascriptModel *javascriptModel;

@end

@implementation WYOCWebViewController

- (void)dealloc {
    self.webView.UIDelegate = nil;
    [self.webView stopLoading];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    self.webView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    [self setupNavigationItem];
    [self setupSubview];
    [self setupURLRequest];
}

- (void)setupSubview {
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
}

- (void)setupNavigationItem {
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:@"/WYOCWebViewController.bundle/WYOCWebViewController.bundle"];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:@"component_left_back@3x.png" inBundle:resource_bundle compatibleWithTraitCollection:nil];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
}

- (void)setupURLRequest {
    NSString *url = self.params[WYWC_WEBPARAMS_PATH];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:[self readCurrentCookie] forHTTPHeaderField:@"Cookie"];
    [self.webView loadRequest:request];
}

#pragma mark - private

- (NSString *)readCurrentCookie {
    return @"";
}

- (NSString *)setCurrentCookie {
    return @"";
}

- (void)leftItemClick:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        if (![self.navigationController popViewControllerAnimated:YES]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)rightItemClick:(id)sender {
    if ([self.javascriptModel.rightUrl containsString:@"#app.share"]) {
        WYOCWebShareModel *model = self.javascriptModel.shareModel;
        NSLog(@"%@", model);
        
        // 分享
    }else {
        // 跳转
//        [WYOCWebViewcManager routeWebController:self.javascriptModel.rightUrl showStyle:WYWControllerShowStylePush];
    }
}

#pragma mark kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && [object isEqual:self.webView]) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress
                              animated:animated];
        if (self.webView.estimatedProgress >= 1.0f) {
            WYWC_WeakObj(self)
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 WYWC_StrongObj(self)
                                 [self.progressView setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 WYWC_StrongObj(self)
                                 [self.progressView setProgress:0.0f animated:NO];
                             }];
        }
    }else if ([keyPath isEqualToString:@"title"] && [object isEqual:self.webView]) {
        NSString *title = self.params[WYWC_WEBPARAMS_TITLE];
        if (title.length <= 0 && self.webView.title.length <=0 ) {
            self.title = @"xxxx";
        }else {
            self.title = (title.length > 0)?title:self.webView.title;
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - webview delegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    urlString = [urlString stringByRemovingPercentEncoding];//解析url
    //url截取根据自己业务增加代码
    if ([[navigationAction.request.URL host] isEqualToString:@"itunes.apple.com"] && [[UIApplication sharedApplication] openURL:navigationAction.request.URL]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else if([urlString hasPrefix:@"tel"]){
        decisionHandler(WKNavigationActionPolicyCancel);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString]];
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        // 跳转
        // [WYOCWebViewcManager routeWebController:navigationAction.request.URL.absoluteString showStyle:WYWControllerShowStylePush];
    }
    return nil;
}

#pragma mark - JavascriptObj delegate

- (void)setNavigationBarWithModel:(WYOCWebJavascriptModel *)model {
    self.javascriptModel = model;
    
    // leftImg 和 leftTitle,只能有一个
    if (model.leftImg) {
        [self.navigationItem.leftBarButtonItem setAction:@selector(leftItemClick:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
            UIImageView *image = [[UIImageView alloc] init];
            [image sd_setImageWithURL:[NSURL URLWithString:model.leftImg]];
            image;
        })];
    }else if (model.leftTitle.length) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftButton setTitle:model.leftTitle forState:UIControlStateNormal];
            [leftButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            leftButton.frame = CGRectMake(0, 0, 30, 30);
            [leftButton addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
            leftButton;
        })];
    }else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    // rightImg 和 rightTitle,只能有一个
    if (model.rightImg) {
        [self.navigationItem.rightBarButtonItem setAction:@selector(rightItemClick:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
            UIImageView *image = [[UIImageView alloc] init];
            [image sd_setImageWithURL:[NSURL URLWithString:model.rightImg]];
            image;
        })];
    }else if (model.rightTitle) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightButton setTitle:model.rightTitle forState:UIControlStateNormal];
            [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            rightButton.frame = CGRectMake(0, 0, 70, 30);
            [rightButton addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
            rightButton;
        })];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (model.titleBg) {
        self.navigationItem.titleView.backgroundColor = [UIColor colorWithHexString:model.titleBg];
        self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    }else {
        self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];
        self.navigationItem.titleView.tintColor = [UIColor colorWithHexString:@"#333333"];
    }
}

#pragma mark - getter & setter

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, WYWC_SCREEN_WIDTH, 2);
        
        [_progressView setTrackTintColor:[UIColor clearColor]];
        _progressView.progressTintColor = [UIColor redColor];
    }
    return _progressView;
}

- (DWKWebView *)webView {
    if (!_webView) {
        WKUserContentController* userContentController = WKUserContentController.new;
        WKUserScript * cookieScript = [[WKUserScript alloc]
                                       initWithSource:[NSString stringWithFormat:@"document.cookie = '%@'", [self setCurrentCookie]]
                                       injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        WKCookieSyncManager *cookiesManager = [WKCookieSyncManager sharedWKCookieSyncManager];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.processPool = cookiesManager.processPool;
        configuration.userContentController = userContentController;
        
        _webView = [[DWKWebView alloc] initWithFrame:CGRectMake(0, 0, WYWC_SCREEN_WIDTH, WYWC_SCREEN_HEIGHT - WYWC_HEIGHT_NAVBAR) configuration:configuration];
        _webView.scrollView.bounces = NO;
        _webView.navigationDelegate = self;
        [_webView addJavascriptObject:self.javascriptObject namespace:nil];
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}

- (WYOCWebJavascriptObject *)javascriptObject {
    if (!_javascriptObject) {
        _javascriptObject = [[WYOCWebJavascriptObject alloc] init];
        _javascriptObject.delegate = self;
    }
    return _javascriptObject;
}

@end
