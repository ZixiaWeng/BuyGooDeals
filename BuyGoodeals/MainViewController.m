//
//  MainViewController.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/21.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+Util.h"
#import "SwipableViewController.h"

//#import "AFHTTPSessionManager+Util.h"
#import "BGDAPI.h"
#import "BGDNetworkManager.h"

#import "TestViewController.h"
#import "GoodsListViewController.h"

#import "UserSettingsTableViewController.h"
#import "GoodsSearchViewController.h"

@interface MainViewController () <UINavigationBarDelegate>
{
    GoodsListViewController* latestVC;
    GoodsListViewController* campaignVC;
    GoodsListViewController* surpriseVC;
}

@end

@implementation MainViewController

- (instancetype) init
{
    latestVC = [[GoodsListViewController alloc] initWithPostType:@"headlines"];
    campaignVC = [[GoodsListViewController alloc] initWithPostTag:@"campaign"];
    surpriseVC = [[GoodsListViewController alloc] initWithPostTag:@"surprise"];
    
    SwipableViewController* mainSVC = [[SwipableViewController alloc] initWithTitle:@""
                           andSubTitles:@[@"Latest", @"Campaign", @"Surprise!"]
                         andControllers:@[latestVC, campaignVC,surpriseVC]];
    
    self = [super initWithRootViewController:mainSVC];

    
    UIButton* btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, 32, 32);
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"navi_action_search_image"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(pushSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    mainSVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    
    UIButton* btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSetting.frame = CGRectMake(0, 0, 32, 32);
    [btnSetting setBackgroundImage:[UIImage imageNamed:@"navi_action_setting_image"] forState:UIControlStateNormal];
    [btnSetting addTarget:self action:@selector(pushSettingViewController) forControlEvents: UIControlEventTouchUpInside];
    mainSVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSetting];
    
//    mainSVC.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_action_search_image"]
//                                                                                 style:UIBarButtonItemStylePlain
//                                                                                target:self
//                                                                                action:@selector(pushSearchViewController)];
    
//    mainSVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_action_setting_image"]
//                                                                                        style:UIBarButtonItemStylePlain
//                                                                                       target:self
//                                                                                       action:@selector(pushSettingViewController)];
    
    UIImageView* titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    [titleImageView setImage:[UIImage imageNamed:@"main_head_logo"]];
    [titleImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    mainSVC.navigationItem.titleView = titleImageView;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* url = [NSString stringWithFormat:@"%@%@", API_HOST, API_GOODS_LIST];
    
    NSLog(@"%@", url);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        AFHTTPSessionManager* manager = [AFHTTPSessionManager BGDManager];
//        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask* task, id responseObject){
//            NSLog(@"JSON:%@", responseObject);
//        } failure:^(NSURLSessionTask* operation, NSError* error){
//            NSLog(@"Error:%@", error);
//        }];
        
//        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"headlines", PARAM_GOODS_LIST_POST_TYPE, nil];
//        
//        [[BGDNetworkManager sharedManager] requestWithMethod:GET WithURL:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
//            NSLog(@"Page:%@", dic[@"page"][@"next"]);
//            NSLog(@"Items:%@", dic[@"items"]);
//        } WithFailureBlock:^(NSError *error) {
//            NSLog(@"Error:%@", error);
//        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    
    viewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_action_search_image"]
                                                                                           style:UIBarButtonItemStylePlain
                                                                                          target:self
                                                                                          action:@selector(pushSearchViewController)];
    
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_action_setting_image"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                                     target:self
                                                                                                     action:@selector(pushSettingViewController)];
    navigationController.title = @"hahhahhahaa";
    navigationController.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_head_logo"]];
    
    return navigationController;
}

- (void)pushSearchViewController
{
    NSLog(@"---pushSearchViewController");
    
    GoodsSearchViewController* searchVC = [[GoodsSearchViewController alloc] init];
    [self pushViewController:searchVC animated:YES];
}

- (void) pushSettingViewController
{
    NSLog(@"---pushSettingViewController");
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserSettings" bundle:[NSBundle mainBundle]];
    //由storyboard根据view的storyBoardID来获取我们要切换的视图
    UserSettingsTableViewController *settingsVC = [story instantiateViewControllerWithIdentifier:@"UserSettingsTableViewController"];
    
    [self pushViewController:settingsVC animated:YES];
}

@end
