//
//  WebViewController.m
//  BuyGoodeals
//
//  Created by LabanL on 6/30/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import "WebViewController.h"
#import "Utils.h"

@interface WebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) NSString* sourceUrl;
@property (strong, nonatomic) NSString* currentUrl;

@property (retain, nonatomic) UIWebView* webView;
@property (retain, nonatomic) UIView* actionViewBar;

@property (retain, nonatomic) UIButton* backAction;
@property (retain, nonatomic) UIButton* forwardAction;
@property (retain, nonatomic) UIButton* refreshAction;
@property (retain, nonatomic) UIButton* outAction;

@property (strong, nonatomic) MBProgressHUD* HUD;

@end

@implementation WebViewController

- (id) init
{
    self = [super init];
    if(!self) return nil;
    
    return self;
}

- (instancetype) initWithUrl:(NSString*)url
{
    self = [self init];
    if(!self) return nil;
    
    self.sourceUrl = url;
    
    return self;
}

- (void) loadView
{
    UIView* mainView = UIView.new;
    [mainView setBackgroundColor:[UIColor appBackground]];
    self.view = mainView;
    
    self.actionViewBar = UIView.new;
    [self.actionViewBar setBackgroundColor:[UIColor colorWithHex:0xEEEEEE]];
    [mainView addSubview:self.actionViewBar];
    [self.actionViewBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(mainView.bottom);
        make.left.equalTo(mainView.left);
        make.right.equalTo(mainView.right);
        make.height.equalTo(@44);
    }];
    
    self.webView = UIWebView.new;
    [self.webView setBackgroundColor:[UIColor clearColor]];
    self.webView.opaque = NO;
    
    self.webView.delegate = self;
    self.webView.scrollView.bounces = YES;
    self.webView.scrollView.scrollEnabled = YES;
    [self.webView setScalesPageToFit:YES];
    [mainView addSubview:self.webView];
    
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.top);
        make.left.equalTo(mainView.left);
        make.right.equalTo(mainView.right);
        make.bottom.equalTo(self.actionViewBar.top);
    }];
    
    [self generateActionBarView];
}

- (void) generateActionBarView
{
    self.backAction = UIButton.new;
    [self.backAction setContentMode:UIViewContentModeCenter];
    [self.backAction setImage:[UIImage imageNamed:@"webview_back_disable"] forState:UIControlStateDisabled];
    [self.backAction setImage:[UIImage imageNamed:@"webview_back_normal"] forState:UIControlStateNormal];
    [self.backAction setImage:[UIImage imageNamed:@"webview_back_pressed"] forState:UIControlEventTouchDown];
    [self.backAction addTarget:self action:@selector(webViewGoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.actionViewBar addSubview:self.backAction];
    
    self.forwardAction = UIButton.new;
    [self.forwardAction setContentMode:UIViewContentModeCenter];
    [self.forwardAction setImage:[UIImage imageNamed:@"webview_forward_disable"] forState:UIControlStateDisabled];
    [self.forwardAction setImage:[UIImage imageNamed:@"webview_forward_normal"] forState:UIControlStateNormal];
    [self.forwardAction setImage:[UIImage imageNamed:@"webview_forward_pressed"] forState:UIControlEventTouchDown];
    [self.forwardAction addTarget:self action:@selector(webViewGoForward) forControlEvents:UIControlEventTouchUpInside];
    [self.actionViewBar addSubview:self.forwardAction];
    
    self.refreshAction = UIButton.new;
    [self.refreshAction setContentMode:UIViewContentModeCenter];
    [self.refreshAction setImage:[UIImage imageNamed:@"webview_refresh"] forState:UIControlStateNormal];
    [self.refreshAction addTarget:self action:@selector(webViewRefresh) forControlEvents:UIControlEventTouchUpInside];
    [self.actionViewBar addSubview:self.refreshAction];
    
    self.outAction = UIButton.new;
    [self.outAction setContentMode:UIViewContentModeCenter];
    [self.outAction setImage:[UIImage imageNamed:@"webview_out_normal"] forState:UIControlStateNormal];
    [self.outAction setImage:[UIImage imageNamed:@"webview_out_pressed"] forState:UIControlEventTouchDown];
    [self.outAction addTarget:self action:@selector(webViewOut) forControlEvents:UIControlEventTouchUpInside];
    [self.actionViewBar addSubview:self.outAction];
    
    [self.backAction makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.actionViewBar.left);
        make.top.equalTo(self.actionViewBar.top);
        make.right.equalTo(self.forwardAction.left);
        make.bottom.equalTo(self.actionViewBar.bottom);
        make.width.equalTo(@[self.forwardAction.width, self.refreshAction.width, self.outAction.width]);
    }];
    
    [self.forwardAction makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backAction.right);
        make.top.equalTo(self.actionViewBar.top);
        make.right.equalTo(self.refreshAction.left);
        make.bottom.equalTo(self.actionViewBar.bottom);
        make.width.equalTo(@[self.backAction.width, self.refreshAction.width, self.outAction.width]);
    }];
    
    [self.refreshAction makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.forwardAction.right);
        make.top.equalTo(self.actionViewBar.top);
        make.right.equalTo(self.outAction.left);
        make.bottom.equalTo(self.actionViewBar.bottom);
        make.width.equalTo(@[self.backAction.width, self.forwardAction.width, self.outAction.width]);
    }];
    
    [self.outAction makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.refreshAction.right);
        make.top.equalTo(self.actionViewBar.top);
        make.right.equalTo(self.actionViewBar.right);
        make.bottom.equalTo(self.actionViewBar.bottom);
        make.width.equalTo(@[self.backAction.width, self.forwardAction.width, self.refreshAction.width]);
    }];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    //解决ContentView被NavigationBar挡住的问题
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    if(self.sourceUrl != nil && self.sourceUrl.length > 0)
    {
        NSLog(@"Url: %@", self.sourceUrl);
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.sourceUrl]]];
    }
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    self.HUD = [Utils createHUD];
    self.currentUrl = [webView.request URL].absoluteString;
    NSLog(@"%@", self.currentUrl);
    
    [self.backAction setEnabled:NO];
    [self.forwardAction setEnabled:NO];
    [self.refreshAction setEnabled:NO];
    
    NSLog(@"%@", @"Load started");
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.HUD hide:YES afterDelay:1];
    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    
    if(webView.canGoBack)
    {
        [self.backAction setEnabled:YES];
    }
    if(webView.canGoForward)
    {
        [self.forwardAction setEnabled:YES];
    }
    
    [self.refreshAction setEnabled:YES];
    
    NSLog(@"%@", @"Load finished");
}

#pragma mark ActionBar Method
- (void) webViewGoBack
{
    if(self.webView.canGoBack) [self.webView goBack];
}

- (void) webViewGoForward
{
    if(self.webView.canGoForward) [self.webView goForward];
}

- (void) webViewRefresh
{
    [self.webView reload];
}

- (void) webViewOut
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.sourceUrl]];
}

@end
