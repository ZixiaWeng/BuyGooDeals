//
//  GoodsDetailsCommentViewController.m
//  BuyGoodeals
//
//  Created by LabanL on 7/1/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import "GoodsDetailsCommentViewController.h"
#import "Utils.h"
#import "GoodsDetailsCommentTableViewCell.h"
#import "BGDNetworkManager.h"
#import "BGDAPI.h"
#import "ListLastCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "AppDelegate.h"

#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

static NSString* const goodsCommentReuseIdentifier = @"BGDGoodsCommentTableViewCell";

@interface GoodsDetailsCommentViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, GoodsDetailsCommentActionDelegate>

@property (strong, nonatomic) NSString* goodsDetailsId;

@property (retain, nonatomic) UITableView* tableView;
@property (retain, nonatomic) UIView* actionBarView;
@property (retain, nonatomic) UITextView* replyInputView;
@property (retain, nonatomic) UILabel* replayInputPlaceHolder;
@property (retain, nonatomic) UIButton* replyBtn;

@property (strong, nonatomic) NSMutableArray* commentItems;

@property (nonatomic, strong) ListLastCell* lastCell;
@property (strong, nonatomic) NSString* indexPageUrl;
@property (strong, nonatomic) NSString* nextPageURL;
@property (strong, nonatomic) NSDictionary* parameterDic;

@property (nonatomic, assign) BOOL shouldFetchDataAfterLoaded;
@property (nonatomic, assign) BOOL needRefreshAnimation;
@property (nonatomic, assign) BOOL needCache;

@property (nonatomic, assign) BOOL needAutoRefresh;
@property (nonatomic, copy) NSString* kLastRefreshTime;
@property (nonatomic, assign) NSTimeInterval refreshInterval;
@property (nonatomic, strong) NSUserDefaults* userDefaults;
@property (nonatomic, strong) NSDate* lastRefreshTime;

@end

@implementation GoodsDetailsCommentViewController

- (instancetype) initWithGoodsDetailsId:(NSString *)goodsDetailsId
{
    if(self = [super init])
    {
        self.goodsDetailsId = goodsDetailsId;
        self.commentItems = [[NSMutableArray alloc] init];
        self.needRefreshAnimation = YES;
        self.shouldFetchDataAfterLoaded = YES;
        self.indexPageUrl = [NSString stringWithFormat:@"%@%@", API_HOST, API_GOODS_COMMENT_LIST];
        self.parameterDic = [NSDictionary dictionaryWithObjectsAndKeys:self.goodsDetailsId, PARAM_GOODS_COMMENT_LIST_POST_ID, nil];
    }
    
    return self;
}

- (void) loadView
{
    self.title = @"All comments";
//    self.navigationController.title = @"All comments";
    UIView* contentView = UIView.new;
    self.view = contentView;
    
    self.tableView = UITableView.new;
    [contentView addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor appBackground];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[GoodsDetailsCommentTableViewCell class] forCellReuseIdentifier:goodsCommentReuseIdentifier];
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorColor = [UIColor appBackground];
    
    self.lastCell = [[ListLastCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
    [self.lastCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMore)]];
    self.lastCell.textLabel.textColor = [UIColor appColorWeaknessForeground];
    self.tableView.tableFooterView = self.lastCell;
    
    self.tableView.mj_header = ({
        MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    self.actionBarView = UIView.new;
    [self.actionBarView setBackgroundColor:[UIColor colorWithHex:0xEEEEEE]];
    [contentView addSubview:self.actionBarView];
    
    [self.actionBarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.left);
        make.right.equalTo(contentView.right);
        make.bottom.equalTo(contentView.bottom);
        make.height.equalTo(@44);
        make.width.equalTo(contentView.width);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.left);
        make.top.equalTo(contentView.top);
        make.right.equalTo(contentView.right);
        make.bottom.equalTo(self.actionBarView.top);
        make.width.equalTo(contentView.width);
    }];
    
    [self generateActionBarView];
}

- (void) generateActionBarView
{
    self.replyBtn = UIButton.new;
    [self.replyBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [self.replyBtn setImage:[UIImage imageNamed:@"comment_send"] forState:UIControlStateNormal];
    [self.replyBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.actionBarView addSubview:self.replyBtn];
    [self.replyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionBarView.top);
        make.right.equalTo(self.actionBarView.right);
        make.bottom.equalTo(self.actionBarView.bottom);
        make.height.equalTo(self.actionBarView.height);
        make.width.equalTo(@60);
    }];
    
    self.replyInputView = UITextView.new;
    self.replyInputView.delegate = self;
    self.replyInputView.font = [UIFont systemFontOfSize:14.0f];
    [self.actionBarView addSubview:self.replyInputView];
    
    self.replayInputPlaceHolder = UILabel.new;
    self.replayInputPlaceHolder.text = @"Make your comments";
    self.replayInputPlaceHolder.font = [UIFont systemFontOfSize:14.0f];
    self.replayInputPlaceHolder.textColor = [UIColor appColorWeaknessForeground];
    [self.actionBarView addSubview:self.replayInputPlaceHolder];
    
    [self.replyInputView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionBarView.top).offset(5);
        make.left.equalTo(self.actionBarView.left).offset(10);
        make.bottom.equalTo(self.actionBarView.bottom).offset(-5);
        make.right.equalTo(self.replyBtn.left).offset(-5);
    }];
    
    [self.replayInputPlaceHolder makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionBarView.top).offset(5);
        make.left.equalTo(self.actionBarView.left).offset(15);
        make.bottom.equalTo(self.actionBarView.bottom).offset(-5);
        make.right.equalTo(self.replyBtn.left).offset(-5);
    }];
}

- (void) sendComment
{
    [self.replyInputView resignFirstResponder];
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > 0)
    {
        self.replayInputPlaceHolder.hidden = YES;
    }
    else
    {
        self.replayInputPlaceHolder.hidden = NO;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    BOOL isUserLogined = ((AppDelegate*)[UIApplication sharedApplication].delegate).isUserLogined;
    
    return isUserLogined;
}

- (void)keyboardWillShown:(NSNotification *)noti
{
    NSDictionary *info = [noti userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWillShown keyBoard:%f", keyboardSize.height);

    [self resizeViewHeight:keyboardSize.height isUp:YES];
}

- (void) keyboardWillHidden:(NSNotification*) noti
{
    NSDictionary *info = [noti userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWillHidden keyBoard:%f", keyboardSize.height);
    
    [self resizeViewHeight:keyboardSize.height isUp:NO];
}

- (void) resizeViewHeight:(float)keyboardHeight isUp:(BOOL)isUp
{
    CGRect frame = self.view.frame;
    if(isUp)frame.size = CGSizeMake(frame.size.width, frame.size.height - keyboardHeight);
    else frame.size = CGSizeMake(frame.size.width, frame.size.height + keyboardHeight);
    
    [UIView beginAnimations:@"Curl" context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

- (void) viewDidLoad
{
    [self registerNotifications];
    
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
    
    [self refresh];
    
    if(!_shouldFetchDataAfterLoaded) {return;}
    if(_needRefreshAnimation)
    {
        [self.tableView.mj_header beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y) animated:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Count: %lu", (unsigned long)self.commentItems.count);
    return self.commentItems.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailsCommentTableViewCell* cell = [GoodsDetailsCommentTableViewCell returnReuseCellFormTableView:tableView indexPath:indexPath identifier:goodsCommentReuseIdentifier];
    
    [cell setViewData:self.commentItems[indexPath.row]];
//    cell.viewModel = self.commentItems[indexPath.row];
    cell.commentActionDelegate = self;
    cell.contentView.backgroundColor = [UIColor appColorItemBackground];
    cell.backgroundColor = [UIColor appColorItemBackground];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor appBackground];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableView fd_heightForCellWithIdentifier:goodsCommentReuseIdentifier cacheByIndexPath:indexPath configuration:^(GoodsDetailsCommentTableViewCell *cell) {
//        cell.viewModel = self.commentItems[indexPath.row];
        [cell setViewData:self.commentItems[indexPath.row]];
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
    
    BGDGoodsCommentInfo* info = self.commentItems[indexPath.row];
    
    NSLog(@"%@-%@", info.block, info.author);
}

#pragma mark - Comment item action
- (void) goodsDetailsCommentReply:(NSString *)commentId
{
    NSLog(@"Comment id: %@", commentId);
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

- (void) refresh
{
    [self loadData:YES];
}

- (void) loadData:(BOOL)isRefresh
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BGDGoodsCommentInfo* info1 = [[BGDGoodsCommentInfo alloc] init];
        info1.comment_ID = @"89";
        info1.author = @"labanl";
        info1.author_email = @"1017lty@sina.com";
        info1.author_url = @"";
        info1.date = @"2016-07-01 11:48:38";
        info1.content = @"Yeah.";
        info1.user_id = @"19";
        info1.head = @"http://www.buygoodeals.com/wp-content/uploads/avatars/19/1462951168-bpfull.jpg";
        info1.block = @"2";
        info1.parent = [[BGDGoodsCommentInfo alloc] init];
        info1.parent.comment_ID = @"88";
        info1.parent.author = @"charles";
        info1.parent.author_email = @"yuanchichi@weifengke.com";
        info1.parent.author_url = @"";
        info1.parent.date = @"2016-07-01 11:47:26";
        info1.parent.content = @"It's so cool.";
        info1.parent.user_id = @"8";
        info1.parent.head = @"";
        
        BGDGoodsCommentInfo* info2 = [[BGDGoodsCommentInfo alloc] init];
        info2.comment_ID = @"88";
        info2.author = @"charles";
        info2.author_email = @"yuanchichi@weifengke.com";
        info2.author_url = @"";
        info2.date = @"2016-07-01 11:47:26";
        info2.content = @"It's so cool.";
        info2.user_id = @"8";
        info2.head = @"";
        info2.block = @"1";
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isRefresh)
            {
                [self.commentItems removeAllObjects];
            }
            [self.commentItems addObject:info1];
            [self.commentItems addObject:info2];
            
            self.lastCell.status = self.commentItems.count < 10 ? LastCellStatusFinished : LastCellStatusMore;
            
            if(self.tableView.mj_header.isRefreshing)
            {
                [self.tableView.mj_header endRefreshing];
            }
            [self.tableView reloadData];
        });
    });
    
    return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* url = isRefresh ? self.indexPageUrl  : self.nextPageURL;
        
        [[BGDNetworkManager sharedManager] requestWithMethod:GET WithURL:url WithParams:_parameterDic WithSuccessBlock:^(NSDictionary *dic) {
            self.nextPageURL = [NSString stringWithFormat:@"%@%@", API_HOST, dic[@"pages"][@"next"]];
            NSArray* items = dic[@"items"];
            if(items != nil)
            {
                NSArray* modelArray = [BGDGoodsCommentInfo mj_objectArrayWithKeyValuesArray:items];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(isRefresh)
                    {
                        [self.commentItems removeAllObjects];
                    }
                    [self.commentItems addObjectsFromArray:modelArray];
                });
            }
//            [self.commentItems addObjectsFromArray:items];
            
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

- (void) dealloc
{
    [self unregisterNotifications];
}

//注册监听
- (void) registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

//注销监听
- (void) unregisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
