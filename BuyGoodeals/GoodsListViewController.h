//
//  GoodsListViewController.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/23.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseListViewController.h"

@interface GoodsListViewController : BaseListViewController

- (instancetype) initWithPostType:(NSString*)postType;
- (instancetype) initWithPostTag:(NSString*)postTag;
- (instancetype) initWithSearchKey:(NSString*)searchKey withPostType:(NSString*)postType;

- (void) reloadData;

@end
