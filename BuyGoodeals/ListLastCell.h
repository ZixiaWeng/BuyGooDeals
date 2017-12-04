//
//  ListLastCell.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/22.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ListLastCellStatus)
{
    LastCellStatusNotVisible,
    LastCellStatusMore,
    LastCellStatusLoading,
    LastCellStatusError,
    LastCellStatusFinished,
    LastCellStatusEmpty,
};

@interface ListLastCell : UIView

@property (nonatomic, assign) ListLastCellStatus status;
@property (readonly, nonatomic, assign) BOOL shouldResponseToTouch;
@property (nonatomic, copy) NSString *emptyMessage;

@property (nonatomic, strong) UILabel *textLabel;
@end
