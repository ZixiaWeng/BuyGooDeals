//
//  GoodsDetailsCommentTableViewCell.h
//  BuyGoodeals
//
//  Created by LabanL on 7/1/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "BGDGoodsCommentInfo.h"

@protocol GoodsDetailsCommentActionDelegate <NSObject>

- (void) goodsDetailsCommentReply:(NSString *) commentId;//回复当前评论
@optional
- (void) goodsDetailsCommentReport:(NSString *) commentId;//举报当前评论

@end

extern NSString* GoodsDetailsCommentTableViewCell_IdentifierString;

@interface GoodsDetailsCommentTableViewCell : UITableViewCell

+ (instancetype) returnReuseCellFormTableView:(UITableView*)tableView
                                    indexPath:(NSIndexPath*)indexPath
                                   identifier:(NSString*)identifierString;

@property (nonatomic, strong) BGDGoodsCommentInfo* viewModel;
- (void) setViewData:(BGDGoodsCommentInfo*) viewModel;

@property (nonatomic, weak) id<GoodsDetailsCommentActionDelegate> commentActionDelegate;

@end
