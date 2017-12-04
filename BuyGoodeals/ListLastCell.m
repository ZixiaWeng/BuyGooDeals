//
//  ListLastCell.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/22.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "ListLastCell.h"
#import "UIColor+Util.h"

@interface ListLastCell ()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation ListLastCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor appBackground];
        
        _status = LastCellStatusNotVisible;
        
        [self setLayout];
    }
    
    return self;
}

- (void)setLayout
{
    _textLabel.textColor = [UIColor appColorForeground];
    _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _textLabel.backgroundColor = [UIColor appBackground];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_textLabel];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin  | UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _indicator.color = [UIColor colorWithRed:54/255 green:54/255 blue:54/255 alpha:1.0];
    _indicator.center = self.center;
    [self addSubview:_indicator];
}


- (BOOL)shouldResponseToTouch
{
    return _status == LastCellStatusMore || _status == LastCellStatusError;
}

- (void)setStatus:(ListLastCellStatus)status
{
    if (status == LastCellStatusLoading) {
        [_indicator startAnimating];
        _indicator.hidden = NO;
    } else {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
    }
    
    _textLabel.text = @[
                        @"",
                        @"Click to load more",
                        @"",
                        @"Load error",
                        @"All loaded",
                        _emptyMessage ?: @"",
                        ][status];
    
    _status = status;
}

@end


