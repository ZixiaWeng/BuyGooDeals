//
//  BaseListViewController.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/21.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "BaseListViewController.h"

#import <MBProgressHUD.h>

@interface BaseListViewController ()

@property (nonatomic, strong) NSUserDefaults* userDefaults;
@property (nonatomic, strong) NSDate* lastRefreshTime;

@end

@implementation BaseListViewController

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _objects = [[NSMutableArray alloc] init];
        _nextPageURL = nil;
        _needRefreshAnimation = YES;
        _shouldFetchDataAfterLoaded = YES;
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dawnAndNightMode:) name:@"dawnAndNight" object:nil];
    
    self.tableView.backgroundColor = [UIColor appBackground];
    
    _lastCell = [[ListLastCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
    [_lastCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMore)]];
    self.tableView.tableFooterView = _lastCell;
    
    self.tableView.mj_header = ({
        MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    _label = [[UILabel alloc] init];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.font = [UIFont boldSystemFontOfSize:14];
    _lastCell.textLabel.textColor = [UIColor appColorWeaknessForeground];
    
    if(_needAutoRefresh)
    {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _lastRefreshTime = [_userDefaults objectForKey:_kLastRefreshTime];
        
        if(!_lastRefreshTime)
        {
            _lastRefreshTime = [NSDate date];
            [_userDefaults setObject:_lastRefreshTime forKey:_kLastRefreshTime];
        }
    }
    
//    if([_networkingDelegate respondsToSelector:@selector(getJsonDateWithParametersDic:isRefresh:)])
//    {
//        [_networkingDelegate getJsonDateWithParametersDic:_parameterDic isRefresh:YES];
//    }
    [self refresh];
    
    if(!_shouldFetchDataAfterLoaded) {return;}
    if(_needRefreshAnimation)
    {
        [self.tableView.mj_header beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - self.refreshControl.frame.size.height) animated:YES];
    }
    
    if(_needCache)
    {
        //TODO: 改变Http Manager的缓存策略
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_needAutoRefresh)
    {
        NSDate* currentTime = [NSDate date];
        if([currentTime timeIntervalSinceDate:_lastRefreshTime] > _refreshInterval)
        {
            _lastRefreshTime = currentTime;
            
            [self refresh];
        }
    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dawnAndNight" object:nil];
}

- (void) dawnAndNightMode:(NSNotificationCenter*) center;
{
    _lastCell.textLabel.backgroundColor = [UIColor appBackground];
    _lastCell.textLabel.textColor = [UIColor appColorWeaknessForeground];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.separatorColor = [UIColor appBackground];
    
    return _objects.count;
}

#pragma mark - 加载更多
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height - 150))
    {
        [self loadMore];
    }
}

- (void) loadMore
{
    if(!_lastCell.shouldResponseToTouch){return;}
    
    if(_nextPageURL == nil || [_nextPageURL isEqualToString:API_HOST]) {return;}
    
    _lastCell.status = LastCellStatusLoading;
    
    [self loadData:NO];
}

#pragma mark - 刷新
- (void) refresh
{
    [self loadData:YES];
    
    //非主网络请求
    if(self.anotherNetworking)
    {
        self.anotherNetworking();
    }
}

- (void) loadData:(BOOL)isRefresh
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* url = isRefresh ? _generateURL() : _nextPageURL;
        
        [[BGDNetworkManager sharedManager] requestWithMethod:GET WithURL:url WithParams:_parameterDic WithSuccessBlock:^(NSDictionary *dic) {
            self.nextPageURL = [NSString stringWithFormat:@"%@%@", API_HOST, dic[@"page"][@"next"]];
            NSArray* items = dic[@"items"];
            [_objects addObjectsFromArray:items];
            if([_networkingDelegate respondsToSelector:@selector(loadDataSuccess:isRefresh:)])
            {
                [_networkingDelegate loadDataSuccess:items isRefresh:isRefresh];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lastCell.status = items.count < 10 ? LastCellStatusFinished : LastCellStatusMore;
                
                if(self.tableView.mj_header.isRefreshing)
                {
                    [self.tableView.mj_header endRefreshing];
                }
                [self.tableView reloadData];
            });
            
        } WithFailureBlock:^(NSError *error) {
            NSLog(@"Error:%@", error);
            
            MBProgressHUD* HUD = [Utils createHUD];
            HUD.mode = MBProgressHUDModeText;
            HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
            
            [HUD hide:YES afterDelay:1];
            
            _lastCell.status = LastCellStatusError;
            if(self.tableView.mj_header.isRefreshing){
                [self.tableView.mj_header endRefreshing];
            }
            [self.tableView reloadData];
        }];
    });
}

@end
