//
//  GoodsListViewController.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/23.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "GoodsListViewController.h"
#import "BGDGoodsTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "BGDGoodsInfo.h"
#import "GoodsDetailsViewController.h"

static NSString* const goodsReuseIdentifier = @"BGDGoodsTableViewCell";

@interface GoodsListViewController () <UITableViewDelegate, UITableViewDataSource, networkingJsonDataDelegate>

@property (nonatomic, strong) NSString* postTag;
@property (nonatomic, strong) NSString* postType;
@property (nonatomic, strong) NSMutableArray* goods;

@end

@implementation GoodsListViewController

- (id) init
{
    self = [super init];
    if(!self) return nil;
    
    __weak GoodsListViewController* weakSelf = self;
    self.tableWillReload = ^(NSUInteger responseObjectCount){
        responseObjectCount < 10 ? (weakSelf.lastCell.status = LastCellStatusFinished) : (weakSelf.lastCell.status = LastCellStatusMore);
    };
    
    self.networkingDelegate = self;
    self.needAutoRefresh = YES;
    self.refreshInterval = 21600;
    
    _goods = [[NSMutableArray alloc] init];
    
    return self;
}

- (instancetype) initWithPostType:(NSString *)postType
{
    self = [self init];
    if(self)
    {
        self.postType = postType;
        self.generateURL = ^NSString* () {
            return [NSString stringWithFormat:@"%@%@",API_HOST, API_GOODS_LIST];
        };
        self.parameterDic = [[NSDictionary alloc] initWithObjectsAndKeys:postType, PARAM_GOODS_LIST_POST_TYPE, nil];
        self.kLastRefreshTime = [NSString stringWithFormat:@"%@%@", postType, @"RefreshInterval"];
    }
    
    return self;
}

- (instancetype) initWithPostTag:(NSString*)postTag
{
    self = [self init];
    if(self)
    {
        self.postTag = postTag;
        self.generateURL = ^NSString* () {
            return [NSString stringWithFormat:@"%@%@",API_HOST, API_GOODS_LIST];
        };
        self.parameterDic = [[NSDictionary alloc] initWithObjectsAndKeys:postTag, PARAM_GOODS_LIST_TAG, nil];

        self.kLastRefreshTime = [NSString stringWithFormat:@"%@%@", postTag, @"RefreshInterval"];
    }
    
    return self;
}

- (instancetype) initWithSearchKey:(NSString *)searchKey withPostType:(NSString *)postType
{
    self = [self init];
    if(!self) return nil;
    
    self.postType = postType;
    self.generateURL = ^NSString* (){
        return [NSString stringWithFormat:@"%@%@", API_HOST, API_GOODS_SEARCH];
    };
    self.parameterDic = [[NSDictionary alloc] initWithObjectsAndKeys:postType, PARAM_GOODS_SEARCH_POST_TYPE, searchKey, PARAM_GOODS_SEARCH_KEY, nil];
    self.kLastRefreshTime = [NSString stringWithFormat:@"%@%@%@", postType, searchKey, @"RefreshInterval"];
    self.needAutoRefresh = YES;
    
    return self;
}

- (void) reloadData
{
    [super refresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void) layoutUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"BGDGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:goodsReuseIdentifier];
    self.tableView.estimatedRowHeight = 132;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.rowHeight = 132;
}

- (void) dawnAndNightMode
{
    self.tableView.backgroundColor = [UIColor appBackground];
    self.tableView.separatorColor = [UIColor appBackground];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void) loadDataSuccess:(NSArray*)listData isRefresh:(BOOL)isRefresh
{
    if(listData)
    {
        NSArray* modelArray = [BGDGoodsInfo mj_objectArrayWithKeyValuesArray:listData];
        if(isRefresh)
        {
            [self.goods removeAllObjects];
        }
        [self.goods addObjectsFromArray:modelArray];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _goods.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BGDGoodsTableViewCell* cell = [BGDGoodsTableViewCell returnReuseCellFormTableView:tableView indexPath:indexPath identifier:goodsReuseIdentifier];
    
    cell.viewModel = _goods[indexPath.row];
    
    cell.contentView.backgroundColor = [UIColor appColorItemBackground];
    cell.backgroundColor = [UIColor appColorItemBackground];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor appBackground];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:goodsReuseIdentifier configuration:^(BGDGoodsTableViewCell* cell){
        cell.viewModel = _goods[indexPath.row];
    }];
}

//让分割线顶格
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BGDGoodsInfo* info = _goods[indexPath.row];
    
    GoodsDetailsViewController* detailsVC = [[GoodsDetailsViewController alloc] initWithDetailsId:[NSString stringWithFormat:@"%@", info.id]];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
