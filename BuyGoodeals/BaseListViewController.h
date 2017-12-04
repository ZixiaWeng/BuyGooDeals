//
//  BaseListViewController.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/21.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

#import "Utils.h"
#import "ListLastCell.h"
#import "UIColor+Util.h"
#import "BGDAPI.h"
#import "BGDNetworkManager.h"

@protocol networkingJsonDataDelegate <NSObject>

//-(void)getJsonDateWithParametersDic:(NSDictionary*)paraDic isRefresh:(BOOL)isRefresh;
-(void)loadDataSuccess:(NSArray*)listData isRefresh:(BOOL)isRefresh;

@end


@interface BaseListViewController : UITableViewController

//@property (nonatomic, strong) AFHTTPSessionManager* manager;

@property (nonatomic, copy) NSString* (^generateURL)();
@property (nonatomic, strong) NSDictionary* parameterDic;
@property (nonatomic, copy) NSString* nextPageURL;
@property (nonatomic, copy) void (^tableWillReload)(NSUInteger responseObjectCount);
@property (nonatomic, copy) void (^didRefreshSucceed)();

@property (nonatomic, assign) BOOL shouldFetchDataAfterLoaded;
@property (nonatomic, assign) BOOL needRefreshAnimation;
@property (nonatomic, assign) BOOL needCache;
@property (nonatomic, strong) NSMutableArray* objects;
@property (nonatomic, strong) ListLastCell* lastCell;
@property (nonatomic, strong) UILabel* label;
//@property (nonatomic, assign) int allCount;
//@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL needAutoRefresh;
@property (nonatomic, copy) NSString* kLastRefreshTime;
@property (nonatomic, assign) NSTimeInterval refreshInterval;

@property (nonatomic, copy) void (^anotherNetworking)();

//@property (nonatomic, strong) NSString* reqeustPath;
@property (nonatomic, strong) id responseJsonObject;
@property (nonatomic, weak) id<networkingJsonDataDelegate> networkingDelegate;

- (void) loadMore;
- (void) refresh;

@end
