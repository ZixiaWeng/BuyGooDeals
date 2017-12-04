//
//  BGDGoodsTableViewCell.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/23.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGDGoodsInfo.h"

extern NSString* BGDGoodsTableViewCell_IdentifierString;

@interface BGDGoodsTableViewCell : UITableViewCell

+ (instancetype) returnReuseCellFormTableView:(UITableView*)tableView
                                    indexPath:(NSIndexPath*)indexPath
                                   identifier:(NSString*)identifierString;

@property (nonatomic, strong) BGDGoodsInfo* viewModel;

@end
