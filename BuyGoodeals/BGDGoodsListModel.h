//
//  BGDGoodsListModel.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/21.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGDListPageInfo.h"

@interface BGDGoodsListModel : NSObject

@property (retain, nonatomic) NSArray *items;
@property (retain, nonatomic) BGDListPageInfo *page;

@end
