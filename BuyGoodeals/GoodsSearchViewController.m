//
//  GoodsSearchViewController.m
//  BuyGoodeals
//
//  Created by LabanL on 7/5/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import "GoodsSearchViewController.h"
#import "Utils.h"
#import "BGDAPI.h"
#import "BGDNetworkManager.h"
#import "BGDTagCollectionView.h"
#import "GoodsListViewController.h"
#import "SwipableViewController.h"

@interface GoodsSearchViewController () <UISearchBarDelegate, BGDTagActionDelegate>
{
    int padding;
    GoodsListViewController* localVC;
    GoodsListViewController* globalVC;
}

@property (nonatomic, strong) NSUserDefaults* userDefaults;

@property (nonatomic, copy) NSString* searchKey;

@property (nonatomic, strong) UIView* mainView;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) UIView* searchHistoryView;

@property (nonatomic, strong) UIView* searchHotTitleView;
@property (nonatomic, strong) UIView* searchHotTagsView;
@property (nonatomic, strong) UIActivityIndicatorView* hotTagLoadingView;

@property (nonatomic, assign) BOOL hasSearchHistory;
@property (nonatomic, strong) NSMutableArray* historyObjs;

@property (nonatomic, strong) UIView* resultView;

@end

@implementation GoodsSearchViewController

- (id) init
{
    self = [super init];
    if(!self) return nil;
    
    padding = 10;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    return self;
}

- (instancetype) initWithSearchKey:(NSString *)searchKey
{
    self = [self init];
    if(!self) return nil;
    
    self.searchKey = searchKey;
    
    return self;
}

- (void) loadView
{
    [super loadView];
    
    self.searchBar = UISearchBar.new;
    self.searchBar.placeholder = @"Input search key";
    self.searchBar.delegate = self;
//    self.searchBar.showsCancelButton = YES;
    self.navigationItem.titleView = self.searchBar;
    
    self.view.backgroundColor = [UIColor appBackground];
    
    self.mainView = UIView.new;
    self.mainView.backgroundColor = [UIColor appBackground];
    [self.view addSubview:self.mainView];
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNavi = self.navigationController.navigationBar.frame;
    float offsetHeight = rectStatus.size.height + rectNavi.size.height;
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.view.top).offset(offsetHeight);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    self.resultView = UIView.new;
    self.resultView.backgroundColor = [UIColor appBackground];
    [self.view addSubview:self.resultView];
    [self.resultView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.view.top).offset(offsetHeight);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    [self.resultView setHidden:YES];
    
    self.searchHistoryView = UIView.new;
    self.searchHistoryView.backgroundColor = [UIColor appColorItemBackground];
    [self.mainView addSubview:self.searchHistoryView];
    
    self.searchHotTitleView = UIView.new;
    self.searchHotTitleView.backgroundColor = [UIColor appColorItemBackground];
    [self.mainView addSubview:self.searchHotTitleView];
    
    self.searchHotTagsView = UIView.new;
    self.searchHotTagsView.backgroundColor = [UIColor appColorItemBackground];
    [self.mainView addSubview:self.searchHotTagsView];
    
    [self.searchHistoryView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.left);
        make.top.equalTo(self.mainView.top);
        make.right.equalTo(self.mainView.right);
        make.width.equalTo(self.mainView.width);
    }];
    
    [self.searchHotTitleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.left);
        make.top.equalTo(self.searchHistoryView.bottom).offset(10);
        make.right.equalTo(self.mainView.right);
        make.width.equalTo(self.mainView.width);
    }];
    
    [self.searchHotTagsView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.left);
        make.top.equalTo(self.searchHotTitleView.bottom);
        make.right.equalTo(self.mainView.right);
        make.width.equalTo(self.mainView.width);
    }];
    
//    [self addHistoryObj:@"ooj"]; 测试用
    NSArray* historyArray = [_userDefaults objectForKey:SEARCH_HISTORY_KEY];
    if(historyArray && historyArray.count > 0)
    {
        self.historyObjs = [NSMutableArray arrayWithArray:historyArray];
    }
    
    if(self.historyObjs && self.historyObjs.count > 0)
    {
        self.hasSearchHistory = YES;
        [self generateSearchHistoryView];
    }
    else
    {
        self.hasSearchHistory = NO;
    }
    
    [self generateSearchHotTitleView];
}

- (void) generateSearchHistoryView
{
    UILabel* historyViewTitle = UILabel.new;
    historyViewTitle.numberOfLines = 1;
    historyViewTitle.text = @"History";
    historyViewTitle.textColor = [UIColor appColorForeground];
    historyViewTitle.font = [UIFont systemFontOfSize:16.0f];
    [self.searchHistoryView addSubview:historyViewTitle];
    
    UIButton* historyClearBtn = UIButton.new;
    NSMutableAttributedString *clearTitle = [[NSMutableAttributedString alloc] initWithString:@"Clear"];
    NSRange clearTitleRange = {0,[clearTitle length]};
    [clearTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:clearTitleRange];
    [clearTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:clearTitleRange];
    [clearTitle addAttribute:NSForegroundColorAttributeName value:[UIColor appColorWeaknessForeground] range:clearTitleRange];
    [historyClearBtn setAttributedTitle:clearTitle forState:UIControlStateNormal];
    [historyClearBtn addTarget:self action:@selector(clearHistoryAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchHistoryView addSubview:historyClearBtn];
    
    BGDTagCollectionView* historyTagCollectionView = [[BGDTagCollectionView alloc] initWithFrame:CGRectMake(padding, padding, self.view.frame.size.width - 2 * padding, 0) withTagArray:self.historyObjs];
    [historyTagCollectionView setBackgroundColor:[UIColor clearColor]];
    historyTagCollectionView.tagActionDelegate = self;
    
    CGRect rect = CGRectMake(historyTagCollectionView.frame.origin.x, historyTagCollectionView.frame.origin.y, historyTagCollectionView.frame.size.width, historyTagCollectionView.collectionViewLayout.collectionViewContentSize.height);
    [historyTagCollectionView setFrame:rect];
    [self.searchHistoryView addSubview:historyTagCollectionView];
    
    [historyClearBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.searchHistoryView.right).offset(-padding);
        make.top.equalTo(self.searchHistoryView.top).offset(padding);
    }];
    
    [historyViewTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchHistoryView.left).offset(padding);
        make.top.equalTo(self.searchHistoryView.top).offset(padding);
        make.right.lessThanOrEqualTo(historyClearBtn.left).offset(-padding);
    }];
    
    [historyTagCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchHistoryView.left).offset(padding);
        make.right.equalTo(self.searchHistoryView.right).offset(-padding);
        make.top.equalTo(historyViewTitle.bottom).offset(padding);
        make.height.equalTo(rect.size.height);
    }];
    
    [self.searchHistoryView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.left);
        make.right.equalTo(self.mainView.right);
        make.top.equalTo(self.mainView.top);
        make.bottom.equalTo(historyTagCollectionView.bottom).offset(padding);
    }];
}

- (void) clearHistoryAction
{
    [self clearHistoryObjs];
    
    [self.searchHistoryView setHidden:YES];
    
    //更新热门搜索位置
    [self.searchHotTitleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.left);
        make.right.equalTo(self.mainView.right);
        make.top.equalTo(self.mainView.top);
    }];
}

//添加一项搜索到历史记录
- (void) addHistoryObj:(NSString*) searchKey
{
    if(!self.historyObjs)
    {
        self.historyObjs = [[NSMutableArray alloc] init];
    }
    if([self.historyObjs containsObject:searchKey])
    {
        [self.historyObjs removeObject:searchKey];
    }
    
    [self.historyObjs insertObject:searchKey atIndex:0];
//    [self.historyObjs addObject:searchKey];
    [_userDefaults setObject:self.historyObjs forKey:SEARCH_HISTORY_KEY];
    [_userDefaults synchronize];//及时保存
}

//清空历史搜索记录
- (void) clearHistoryObjs
{
    if(self.historyObjs && self.historyObjs.count > 0)
    {
        [self.historyObjs removeAllObjects];
    }
    
    [_userDefaults setObject:nil forKey:SEARCH_HISTORY_KEY];
    [_userDefaults synchronize];//及时保存
}

- (void) generateSearchHotTitleView
{
    UILabel* hotViewTitle = UILabel.new;
    hotViewTitle.text = @"Hot tags";
    hotViewTitle.textColor = [UIColor appColorForeground];
    hotViewTitle.font = [UIFont systemFontOfSize:16.0f];
    [self.searchHotTitleView addSubview:hotViewTitle];
    
    self.hotTagLoadingView = UIActivityIndicatorView.new;
    [self.hotTagLoadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.hotTagLoadingView startAnimating];
    [self.searchHotTitleView addSubview:self.hotTagLoadingView];
    
    [hotViewTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchHotTitleView.left).offset(padding);
        make.top.equalTo(self.searchHotTitleView.top).offset(padding);
        make.bottom.equalTo(self.searchHotTitleView.bottom).offset(-padding);
    }];
    
    [self.hotTagLoadingView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hotViewTitle.right).offset(padding);
        make.top.equalTo(self.searchHotTitleView.top).offset(padding);
        make.bottom.equalTo(self.searchHotTitleView.bottom).offset(-padding);
    }];
    
    [self.searchHotTitleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.left);
        make.right.equalTo(self.mainView.right);
        make.top.equalTo(self.searchHistoryView.bottom).offset(self.hasSearchHistory ? padding : 0);
        make.bottom.equalTo(hotViewTitle.bottom).offset(padding);
        make.bottom.equalTo(self.hotTagLoadingView.bottom).offset(padding);
    }];
}

- (void) generateHotTagsView:(NSArray*) tags
{
    BGDTagCollectionView* hotTagCollectionView = [[BGDTagCollectionView alloc] initWithFrame:CGRectMake(padding, padding, self.view.frame.size.width - 2 * padding, 0) withTagArray:tags];
    NSLog(@"self.view %.0f", self.view.frame.size.width);
    [hotTagCollectionView setBackgroundColor:[UIColor clearColor]];
    hotTagCollectionView.tagActionDelegate = self;
    
    CGRect rect = CGRectMake(hotTagCollectionView.frame.origin.x, hotTagCollectionView.frame.origin.y, hotTagCollectionView.frame.size.width, hotTagCollectionView.collectionViewLayout.collectionViewContentSize.height);
    NSLog(@"x: %.0f y: %.0f width: %.0f height:%.0f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    [hotTagCollectionView setFrame:rect];
    [self.searchHotTagsView addSubview:hotTagCollectionView];

    [hotTagCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchHotTagsView.left).offset(padding);
        make.right.equalTo(self.searchHotTagsView.right).offset(-padding);
        make.top.equalTo(self.searchHotTagsView.top);
        make.height.equalTo(rect.size.height);
    }];
    
    [self.searchHotTagsView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.left);
        make.right.equalTo(self.mainView.right);
        make.top.equalTo(self.searchHotTitleView.bottom);
        make.bottom.equalTo(hotTagCollectionView.bottom).offset(padding);
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if(searchBar.text.length > 0)
    {
        [self addHistoryObj:searchBar.text];
        if(localVC == nil && globalVC == nil)
        {
            localVC = [[GoodsListViewController alloc] initWithSearchKey:searchBar.text withPostType:@"post"];
            globalVC = [[GoodsListViewController alloc] initWithSearchKey:searchBar.text withPostType:@"haitao"];
            
            SwipableViewController* mainSVC = [[SwipableViewController alloc] initWithTitle:@""
                                                                               andSubTitles:@[@"Local", @"Global"]
                                                                             andControllers:@[localVC, globalVC]];
            [self addChildViewController:mainSVC];
            [self.resultView addSubview:mainSVC.view];
            [self.mainView setHidden:YES];
            [self.resultView setHidden:NO];
        }
        else
        {
            localVC.parameterDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"post", PARAM_GOODS_SEARCH_POST_TYPE, searchBar.text, PARAM_GOODS_SEARCH_KEY, nil];
            globalVC.parameterDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"haitao", PARAM_GOODS_SEARCH_POST_TYPE, searchBar.text, PARAM_GOODS_SEARCH_KEY, nil];
            [localVC reloadData];
            [globalVC reloadData];
        }
    }
}

- (void) tagClicked:(NSString *)tagStr
{
    self.searchBar.text = tagStr;
    
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadHotTags];
    
    if(self.searchKey)
    {
        self.searchBar.text = self.searchKey;
        [self searchBarSearchButtonClicked:self.searchBar];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//加载热门标签
- (void) loadHotTags
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* url = [NSString stringWithFormat:@"%@%@", API_HOST, API_GOODS_SEARCH_HOT_TAGS];
        [[BGDNetworkManager sharedManager] requestWithMethod:GET WithURL:url WithParams:nil WithSuccessBlock:^(NSDictionary* dic){
            if(dic != nil)
            {
                NSArray* tags = dic[@"tags"];
                if(tags != nil && tags.count > 0)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.hotTagLoadingView stopAnimating];
                        [self.hotTagLoadingView setHidden:YES];
                        
                        [self generateHotTagsView:tags];
                    });
                }
            }
        } WithFailureBlock:^(NSError* error){
            [self.hotTagLoadingView stopAnimating];
            [self.hotTagLoadingView setHidden:YES];
        }];
    });
}

@end
