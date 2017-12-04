//
//  GoodsDetailsViewController.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/27.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "GoodsDetailsViewController.h"
#import "BGDNetworkManager.h"
#import "Utils.h"
#import "BGDAPI.h"
#import "BGDGoodsDetailsInfo.h"
#import "WebViewController.h"
#import "GoodsDetailsCommentViewController.h"
#import "BGDTagCollectionView.h"
#import "GoodsSearchViewController.h"

#import <MJExtension/MJExtension.h>

@interface GoodsDetailsViewController () <UIWebViewDelegate, BGDTagActionDelegate>

@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIView* contentView;
@property (strong, nonatomic) UIView* actionBarView;

//@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
//@property (weak, nonatomic) IBOutlet UILabel *goodsDetailsPrice;
//@property (weak, nonatomic) IBOutlet UILabel *goodsDetailsSourceAndTime;
//@property (weak, nonatomic) IBOutlet UIWebView *goodsDetailsContentWebView;
//@property (weak, nonatomic) IBOutlet UILabel *goodsDetailsTitle;

@property (retain, nonatomic) UIImageView *goodsImageView;
@property (retain, nonatomic) UILabel *goodsDetailsPrice;
@property (retain, nonatomic) UILabel *goodsDetailsSourceAndTime;
@property (retain, nonatomic) UIWebView *goodsDetailsContentWebView;
@property (retain, nonatomic) UILabel *goodsDetailsTitle;
@property (retain, nonatomic) UILabel* tagLabel;
@property (retain, nonatomic) BGDTagCollectionView* tagCollectionView;
@property (retain, nonatomic) UIButton* btnFavo;
@property (retain, nonatomic) UIButton* goodsDetailsUpBtn;
@property (retain, nonatomic) UIButton* goodsDetailsDownBtn;

@property (nonatomic, strong) NSString* detailsId;
@property (nonatomic, strong) BGDGoodsDetailsInfo* detailsInfo;
@property (nonatomic, strong) NSArray* tagArray;

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic) BOOL isContentLoaded;

@end

@implementation GoodsDetailsViewController

- (id) init
{
    self = [super init];
    if(!self) return nil;
    
    self.isContentLoaded = NO;
    
    UIButton* btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(0, 0, 32, 32);
    [btnShare setBackgroundImage:[UIImage imageNamed:@"goods_details_action_share"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(shareGoodsDetails) forControlEvents: UIControlEventTouchUpInside];
    
    self.btnFavo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnFavo.frame = CGRectMake(0, 0, 32, 32);
    [self.btnFavo setBackgroundImage:[UIImage imageNamed:@"goods_details_action_favo"] forState:UIControlStateNormal];
    [self.btnFavo addTarget:self action:@selector(runGoodsDetailsFavo) forControlEvents: UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:btnShare],[[UIBarButtonItem alloc] initWithCustomView:self.btnFavo],nil];

    return self;
}

- (void) loadView
{
    self.title = @"";
    UIView* mainView = UIView.new;
    self.scrollView = UIScrollView.new;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.backgroundColor = [UIColor appBackground];
    self.view = mainView;
    [mainView addSubview:self.scrollView];
    
    self.actionBarView = UIView.new;
    //TODO 设置边框颜色
//    self.actionBarView.layer.borderWidth = 1.0f;
//    self.actionBarView.layer.borderColor = [UIColor blackColor].CGColor;
    self.actionBarView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
    [mainView addSubview:self.actionBarView];
    
    [self.actionBarView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(mainView.bottom);
        make.left.equalTo(mainView.left);
        make.right.equalTo(mainView.right);
        make.width.equalTo(mainView.width);
        make.height.equalTo(@44);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.top);
        make.left.equalTo(mainView.left);
        make.right.equalTo(mainView.right);
        make.bottom.equalTo(self.actionBarView.top);
        make.width.equalTo(mainView.width);
    }];
    
    NSLog(@"MainView : %0.f %0.f", [mainView frame].size.width, [mainView frame].size.height);
    
    self.contentView = UIView.new;
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}

- (void) generateActionBarView
{
    UIButton* goodsDetailsViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
    UIImage* viewImage = [[UIImage imageNamed:@"goods_details_action_view"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 20, 40, 0)];
    [goodsDetailsViewBtn setBackgroundImage:viewImage forState:UIControlStateNormal];
    [goodsDetailsViewBtn setTitle:@"View Deal" forState:UIControlStateNormal];
    [goodsDetailsViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goodsDetailsViewBtn addTarget:self action:@selector(naviToGoodsDetailsSource) forControlEvents:UIControlEventTouchUpInside];
    [self.actionBarView addSubview:goodsDetailsViewBtn];
    [goodsDetailsViewBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.actionBarView.right);
        make.top.equalTo(self.actionBarView.top);
        make.bottom.equalTo(self.actionBarView.bottom);
        make.height.equalTo(self.actionBarView.height);
        make.width.equalTo(@110);
    }];
    
    UIView* actionBarOtherView = UIView.new;
    [actionBarOtherView setBackgroundColor:[UIColor clearColor]];
    [self.actionBarView addSubview:actionBarOtherView];
    [actionBarOtherView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.actionBarView.left);
        make.top.equalTo(self.actionBarView.top);
        make.bottom.equalTo(self.actionBarView.bottom);
        make.right.equalTo(goodsDetailsViewBtn.left);
    }];
    
    self.goodsDetailsUpBtn = UIButton.new;
    [self.goodsDetailsUpBtn setTitle:self.detailsInfo.vote_up forState:UIControlStateNormal];
    [self.goodsDetailsUpBtn setImage:[UIImage imageNamed:@"goods_details_action_up"] forState:UIControlStateNormal];
    self.goodsDetailsUpBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.goodsDetailsUpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.goodsDetailsUpBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlEventTouchDown];
    [self.goodsDetailsUpBtn addTarget:self action:@selector(runGoodsDetailsUp) forControlEvents:UIControlEventTouchUpInside];
    [actionBarOtherView addSubview:self.goodsDetailsUpBtn];
    
    self.goodsDetailsDownBtn = UIButton.new;
    [self.goodsDetailsDownBtn setTitle:self.detailsInfo.vote_down forState:UIControlStateNormal];
    [self.goodsDetailsDownBtn setImage:[UIImage imageNamed:@"goods_details_action_down"] forState:UIControlStateNormal];
    self.goodsDetailsDownBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.goodsDetailsDownBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.goodsDetailsDownBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlEventTouchDown];
    [self.goodsDetailsDownBtn addTarget:self action:@selector(runGoodsDetailsDown) forControlEvents:UIControlEventTouchUpInside];
    [actionBarOtherView addSubview:self.goodsDetailsDownBtn];
    
    UIButton* goodsDetailsCommentBtn = UIButton.new;
    [goodsDetailsCommentBtn setTitle:self.detailsInfo.comment_count forState:UIControlStateNormal];
    [goodsDetailsCommentBtn setImage:[UIImage imageNamed:@"goods_details_action_comment"] forState:UIControlStateNormal];
    goodsDetailsCommentBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [goodsDetailsCommentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goodsDetailsCommentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlEventTouchDown];
    [goodsDetailsCommentBtn addTarget:self action:@selector(naviToGoodsDetailsComment) forControlEvents:UIControlEventTouchUpInside];
    [actionBarOtherView addSubview:goodsDetailsCommentBtn];
    
    [self.goodsDetailsUpBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionBarView);
        make.left.equalTo(@10);
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.width.equalTo(@[self.goodsDetailsDownBtn.width, goodsDetailsCommentBtn.width]);
    }];
    
    [self.goodsDetailsDownBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionBarView);
        make.left.equalTo(self.goodsDetailsUpBtn.right).offset(@10);
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.width.equalTo(@[self.goodsDetailsUpBtn.width, goodsDetailsCommentBtn.width]);
    }];
    
    [goodsDetailsCommentBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionBarView);
        make.left.equalTo(self.goodsDetailsDownBtn.right).offset(@10);
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.width.equalTo(@[self.goodsDetailsDownBtn.width, self.goodsDetailsUpBtn.width]);
    }];
    
    NSLog(@"goodsDetailsCommentBtn: %0.f %0.f %0.f %0.f", self.goodsDetailsUpBtn.frame.origin.x, self.goodsDetailsUpBtn.frame.origin.y, self.goodsDetailsUpBtn.frame.size.width, self.goodsDetailsUpBtn.frame.size.height);
}

- (void) generateContent
{
    //若该商品已收藏则改变收藏按钮状态
    if([self.detailsInfo.faves isEqualToString:@"1"])
    {
        [self.btnFavo setBackgroundImage:[UIImage imageNamed:@"goods_details_action_favo_had"] forState:UIControlStateNormal];
    }
    
    int padding = 10;
    
    self.goodsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_default_image"]];
    self.goodsImageView.backgroundColor = [UIColor whiteColor];
    [self.goodsImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:self.goodsImageView];
    [self.goodsImageView loadPortrait:[NSURL URLWithString:self.detailsInfo.thumb]];
    
    self.goodsDetailsTitle = UILabel.new;
//    self.goodsDetailsTitle.text = @"Microsoft xBox Microsoft xBox Microsoft xBox Microsoft xBox Microsoft xBox Microsoft xBox Microsoft xBox";
    self.goodsDetailsTitle.text = self.detailsInfo.title;
    [self.goodsDetailsTitle setFont:[UIFont systemFontOfSize:[@16 floatValue]]];
    [self.goodsDetailsTitle setTextColor:[UIColor appColorForeground]];
    [self.goodsDetailsTitle setNumberOfLines:[@2 integerValue]];
    [self.contentView addSubview:self.goodsDetailsTitle];
    
    self.goodsDetailsPrice = UILabel.new;
//    self.goodsDetailsPrice.text = @"$34,908 %80 OFF";
    self.goodsDetailsPrice.text = self.detailsInfo.red_value;
    [self.goodsDetailsPrice setFont:[UIFont systemFontOfSize:[@16 floatValue]]];
    [self.goodsDetailsPrice setTextColor:[UIColor appColorPrimary]];
    [self.goodsDetailsPrice setNumberOfLines:[@1 integerValue]];
    [self.contentView addSubview:self.goodsDetailsPrice];
    
    self.goodsDetailsSourceAndTime = UILabel.new;
//    self.goodsDetailsSourceAndTime.text = @"Amazon | 18:10";
    self.goodsDetailsSourceAndTime.text = [NSString stringWithFormat:@"%@ | %@", self.detailsInfo.mall, [Utils getShortTimeStr:self.detailsInfo.post_date]];
    [self.goodsDetailsSourceAndTime setFont:[UIFont systemFontOfSize:[@14 floatValue]]];
    [self.goodsDetailsSourceAndTime setTextColor:[UIColor appColorWeaknessForeground]];
    [self.goodsDetailsSourceAndTime setNumberOfLines:[@1 integerValue]];
    [self.contentView addSubview:self.goodsDetailsSourceAndTime];
    
    self.goodsDetailsContentWebView = UIWebView.new;
    //设置webView背景透明
    [self.goodsDetailsContentWebView setBackgroundColor:[UIColor clearColor]];
    self.goodsDetailsContentWebView.opaque = NO;
    
    self.goodsDetailsContentWebView.delegate = self;
    self.goodsDetailsContentWebView.scrollView.bounces = NO;
    self.goodsDetailsContentWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.goodsDetailsContentWebView.scrollView.scrollEnabled = NO;
//    [self.goodsDetailsContentWebView sizeToFit];
    [self.goodsDetailsContentWebView setScalesPageToFit:YES];
    [self.contentView addSubview:self.goodsDetailsContentWebView];
    
    //<style>* {font-size:16px;line-height:20px;color:#000000;} a {color:#0000FF;}</style>
    //<style>* {font-size:16px;line-height:20px;color:#A8A8A8;} a {color:#1128d4;}</style> Night
//    int textFontSize=20;
//    NSString *strHTML=[NSString stringWithFormat: @"<html><body><script>var str = '%@'; document.write(str.fontsize(%d));</script></body></html>",_detailsInfo.content,textFontSize];
    
    NSString *strHTML=[NSString stringWithFormat: @"<html><head><style>* {font-size:32px;line-height:40px;color:#000000;} a {color:#0000FF;}</style></head><body>%@</body></html>", self.detailsInfo.content];
    [self.goodsDetailsContentWebView loadHTMLString:strHTML baseURL:nil];
    
    //TODO Add Tags
    
    [self.goodsImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.width.equalTo(self.contentView.width);
        make.height.lessThanOrEqualTo(@160);
    }];
    
    [self.goodsDetailsTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.bottom).offset(padding);
        make.left.equalTo(padding);
        make.right.equalTo(-padding);
    }];
    
    [self.goodsDetailsPrice makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsDetailsTitle.bottom).offset(padding);
        make.left.equalTo(padding);
        make.right.equalTo(-padding);
    }];
    
    [self.goodsDetailsSourceAndTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsDetailsPrice.bottom).offset(padding);
        make.left.equalTo(padding);
        make.right.equalTo(-padding);
    }];
    
    [self.goodsDetailsContentWebView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsDetailsSourceAndTime.bottom).offset(padding);
        make.left.equalTo(padding);
        make.right.equalTo(-padding);
        make.height.greaterThanOrEqualTo(@120);
    }];
    
    if(self.detailsInfo.tag.count > 0)
    {
        self.tagLabel = UILabel.new;
        self.tagLabel.text = @"Tags";
        [self.tagLabel setFont:[UIFont systemFontOfSize:[@14 floatValue]]];
        [self.tagLabel setTextColor:[UIColor appColorWeaknessForeground]];
        [self.tagLabel setNumberOfLines:[@1 integerValue]];
        [self.contentView addSubview:self.tagLabel];
        
        [self.tagLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsDetailsContentWebView.bottom).offset(padding);
            make.left.equalTo(self.contentView.left).offset(padding);
            make.right.equalTo(self.contentView.right).offset(-padding);
        }];
        
        self.tagArray = [NSArray arrayWithArray:self.detailsInfo.tag];
        
        self.tagCollectionView = [[BGDTagCollectionView alloc] initWithFrame:CGRectMake(padding, self.tagLabel.frame.origin.y + self.tagLabel.frame.size.height + padding, self.contentView.frame.size.width - 2 * padding, 0) withTagArray:self.tagArray];
        [self.tagCollectionView setBackgroundColor:[UIColor clearColor]];
        self.tagCollectionView.tagActionDelegate = self;
        [self.contentView addSubview:self.tagCollectionView];
        
        CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.tagCollectionView.collectionViewLayout.collectionViewContentSize.height);
        [self.tagCollectionView setFrame:rect];
        
        [self.tagCollectionView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tagLabel.bottom).offset(padding);
            make.left.equalTo(self.contentView.left).offset(padding);
            make.right.equalTo(self.contentView.right).offset(-padding);
            make.height.equalTo(self.tagCollectionView.frame.size.height);
        }];
        
        [self.contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tagCollectionView.bottom).offset(padding);
        }];
    }
    else
    {
        [self.contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.goodsDetailsContentWebView.bottom).offset(padding);
        }];
    }
    
    
    [self.HUD hide:YES afterDelay:1];
}

- (instancetype) initWithDetailsId:(NSString *)id
{
    if([self init])
    {
        self.detailsId = id;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.HUD = [Utils createHUD];
    self.HUD.userInteractionEnabled = NO;
    
    [self loadDetailsInfo];
}

- (void) loadDetailsInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary* parameterDic = [NSDictionary dictionaryWithObjectsAndKeys:self.detailsId, PARAM_GOODS_DETAILS_ID, nil];
        
        [[BGDNetworkManager sharedManager] requestWithMethod:GET
                                                     WithURL:[NSString stringWithFormat:@"%@%@",API_HOST, API_GOODS_DETAILS]
                                                  WithParams:parameterDic
                                            WithSuccessBlock:^(NSDictionary *dic) {

            self.detailsInfo = [BGDGoodsDetailsInfo mj_objectWithKeyValues:dic];
                                                
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.detailsInfo != nil)
                {
                    [self generateContent];
                    [self generateActionBarView];
                }
            });
            
        } WithFailureBlock:^(NSError *error) {
            NSLog(@"Error:%@", error);
            
            MBProgressHUD* HUD = [Utils createHUD];
            HUD.mode = MBProgressHUDModeText;
            HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
            
            [HUD hide:YES afterDelay:1];
        }];
    });

}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    int fontValue = 150;
    //document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'
//    NSString *webviewFontSize = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",fontValue];
    NSString *webviewFontSize = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",fontValue];
    [webView stringByEvaluatingJavaScriptFromString:webviewFontSize];

//    UIScrollView *scrollView = (UIScrollView *)[[webView subviews] objectAtIndex:0];
    
    CGFloat webViewHeight = [webView.scrollView contentSize].height;
//    NSString *curHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    
    CGRect newFrame = webView.frame;
    NSLog(@"Old: %0.f", newFrame.size.height);
    newFrame.size.height = webViewHeight;
    NSLog(@"New: %0.f", newFrame.size.height);
    webView.frame = newFrame;
    
    [self updateConstraints];
    
    self.isContentLoaded = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(!self.isContentLoaded) return YES;
    
    NSLog(@"WebView inside link: %@", [request URL].absoluteString);
    
    WebViewController* webVC = [[WebViewController alloc] initWithUrl:[request URL].absoluteString];
    [self.navigationController pushViewController:webVC animated:YES];
    
    return NO;
}

#pragma mark 投票
- (void) runGoodsDetailsUp
{
    [self runGoodsDetailsUpOrDown:YES];
}

- (void) runGoodsDetailsDown
{
    [self runGoodsDetailsUpOrDown:NO];
}

- (void) runGoodsDetailsUpOrDown:(BOOL)isUp
{
    if(self.detailsInfo == nil)
    {
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"An error occurred, please try again later"];
        
        [HUD hide:YES afterDelay:1];
        return;
    }
    
    NSString* url = [NSString stringWithFormat:@"%@%@", API_HOST, API_GOODS_PRAISE];
    NSString* upOrDownActionStr = isUp ? @"up" : @"down";
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:self.detailsInfo.id, PARAM_GOODS_PRAISE_ID,upOrDownActionStr, PARAM_GOODS_PRAISE_ACT, nil];
    [[BGDNetworkManager sharedManager] requestWithMethod:GET WithURL:url WithParams:params WithSuccessBlock:^(NSDictionary* dic){
        if(dic != nil)
        {
            int code = [dic[@"code"] intValue];
            if(code == 1)
            {
                MBProgressHUD *HUD = [Utils createHUD];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                HUD.detailsLabelText = [NSString stringWithFormat:@"%@", @"Vote success"];
                if(isUp)
                {
                    int count = [self.detailsInfo.vote_up intValue];
                    count++;
                    self.detailsInfo.vote_up = [NSString stringWithFormat:@"%d",count];
                    [self.goodsDetailsUpBtn setTitle:self.detailsInfo.vote_up forState:UIControlStateNormal];
                }
                else
                {
                    int count = [self.detailsInfo.vote_down intValue];
                    count++;
                    self.detailsInfo.vote_down = [NSString stringWithFormat:@"%d",count];
                    [self.goodsDetailsDownBtn setTitle:self.detailsInfo.vote_down forState:UIControlStateNormal];
                }
                [HUD hide:YES afterDelay:1];
            }
            else
            {
                NSString* errorStr = [NSString stringWithFormat:@"%@", dic[@"msg"]];
                MBProgressHUD *HUD = [Utils createHUD];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                HUD.detailsLabelText = [NSString stringWithFormat:@"%@", errorStr];
                
                [HUD hide:YES afterDelay:1];
            }
        }
    } WithFailureBlock:^(NSError* error){
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
        
        [HUD hide:YES afterDelay:1];
    }];
}

- (void) naviToGoodsDetailsComment
{
    GoodsDetailsCommentViewController* commentVC = [[GoodsDetailsCommentViewController alloc] initWithGoodsDetailsId:self.detailsId];
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void) naviToGoodsDetailsSource
{
    WebViewController* webVC = [[WebViewController alloc] initWithUrl:self.detailsInfo.mall_link];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void) runGoodsDetailsFavo
{
    //TODO 先判断用户是否登录，没有登录则弹出登录窗口
    return;
    if(self.detailsInfo == nil)
    {
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"An error occurred, please try again later"];
        
        [HUD hide:YES afterDelay:1];
        return;
    }
    NSString* url = [NSString stringWithFormat:@"%@%@", API_HOST, API_GOODS_FAVO];
    NSString* favoActionStr = [self.detailsInfo.faves isEqualToString:@"1"] ? @"rem" : @"add";
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:self.detailsInfo.id, PARAM_GOODS_FAVO_ID, favoActionStr, PARAM_GOODS_FAVO_ACT, nil];
    [[BGDNetworkManager sharedManager] requestWithMethod:GET WithURL:url WithParams:params WithSuccessBlock:^(NSDictionary* dic){
        //TODO 处理收藏或取消收藏成功
//        [self.btnFavo setBackgroundImage:[UIImage imageNamed:@"goods_details_action_favo"] forState:UIControlStateNormal];
//        [self.btnFavo setBackgroundImage:[UIImage imageNamed:@"goods_details_action_favo_had"] forState:UIControlStateNormal];
    } WithFailureBlock:^(NSError* error){
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
        
        [HUD hide:YES afterDelay:1];
    }];
}

- (void) shareGoodsDetails
{
    if(self.detailsInfo == nil)
    {
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"Can't share, please try again later"];
        
        [HUD hide:YES afterDelay:1];

        return;
    }
    //分享内容
    NSArray* activityItems = [[NSArray alloc] initWithObjects:self.detailsInfo.title,
                              self.detailsInfo.mall_link,
                              [self.goodsImageView image],nil];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    UIActivityViewControllerCompletionHandler block = ^(NSString* activityType, BOOL completed)
    {
        if(completed)
        {
            NSLog(@"Share success");
            MBProgressHUD *HUD = [Utils createHUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            HUD.detailsLabelText = [NSString stringWithFormat:@"Share success"];
            
            [HUD hide:YES afterDelay:1];
        }
        else
        {
            NSLog(@"Cancel the share");
            MBProgressHUD *HUD = [Utils createHUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            HUD.detailsLabelText = [NSString stringWithFormat:@"Cancel the share"];
            
            [HUD hide:YES afterDelay:1];
        }
        [activityVC dismissViewControllerAnimated:YES completion:nil];
    };
    
    activityVC.completionHandler = block;
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void) updateConstraints
{
    NSLog(@"ScrollView old Height:%0.f", [self.scrollView contentSize].height);
    
    int padding = 10;
    CGFloat webViewHeight = [self.goodsDetailsContentWebView.scrollView contentSize].height;
    [self.goodsDetailsContentWebView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsDetailsSourceAndTime.bottom).offset(padding);
        make.left.equalTo(padding);
        make.right.equalTo(-padding);
        make.height.equalTo(webViewHeight);
    }];
    
    if(self.tagArray != nil && self.tagArray.count > 0)
    {
        [self.tagLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsDetailsContentWebView.bottom).offset(padding);
            make.left.equalTo(self.contentView.left).offset(padding);
            make.right.equalTo(self.contentView.right).offset(-padding);
        }];
        
        [self.tagCollectionView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tagLabel.bottom).offset(padding);
            make.left.equalTo(self.contentView.left).offset(padding);
            make.right.equalTo(self.contentView.right).offset(-padding);
            make.height.equalTo(self.tagCollectionView.frame.size.height);
        }];
        
        [self.contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tagCollectionView.bottom).offset(padding);
        }];
    }
    else
    {
        [self.contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.goodsDetailsContentWebView.bottom).offset(padding);
        }];
    }
    
    
    NSLog(@"ScrollView Height:%0.f", [self.scrollView contentSize].height);
}

- (void) tagClicked:(NSString *)tagStr
{
    //删除后退栈中的搜索VC，防止多个搜索VC
    NSMutableArray* VCs = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for(id vc in VCs)
    {
        if([vc isMemberOfClass:[GoodsSearchViewController class]])//某类的实例; isKindOfClass 某类或其子类的实例
        {
            [VCs removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = VCs;
    
    GoodsSearchViewController* searchVC = [[GoodsSearchViewController alloc] initWithSearchKey:tagStr];
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
