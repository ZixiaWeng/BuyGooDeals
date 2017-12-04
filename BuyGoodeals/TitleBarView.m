//
//  TitleBarView.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/20.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "TitleBarView.h"
#import "UIColor+Util.h"
#import <Foundation/Foundation.h>

@interface TitleBarView ()

@end

@implementation TitleBarView

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _currentIndex = 0;
        _titleButtons = [NSMutableArray new];
        
        CGFloat indicatorViewHeight = 1;
        CGFloat buttonWidth = frame.size.width / titles.count;
        CGFloat buttonHeight = frame.size.height - indicatorViewHeight;
        
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor appTabBackground];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor appTabTextColor] forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            
            button.frame = CGRectMake(buttonWidth * idx, 0, buttonWidth, buttonHeight);
            button.tag = idx;
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_titleButtons addObject:button];
            [self addSubview:button];
            [self sendSubviewToBack:button];
        }];
        
        UIView* indicatorBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight, frame.size.width, indicatorViewHeight)];
        [indicatorBackgroundView setBackgroundColor:[UIColor appTabTextColor]];
        [self addSubview:indicatorBackgroundView];
        
        self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight, buttonWidth, indicatorViewHeight)];
        [self.indicatorView setBackgroundColor:[UIColor appTabIndicatorColor]];
        [self addSubview:self.indicatorView];
        [self bringSubviewToFront:self.indicatorView];

        self.contentSize = CGSizeMake(frame.size.width, 25);
        self.showsHorizontalScrollIndicator = NO;
        UIButton *firstTitle = _titleButtons[0];
        [firstTitle setTitleColor:[UIColor appTabSelectedTextColor] forState:UIControlStateNormal];
        firstTitle.transform = CGAffineTransformMakeScale(1.15, 1.15);
    }
    
    return self;
}


- (void)onClick:(UIButton *)button
{
    if (_currentIndex != button.tag) {
        UIButton *preTitle = _titleButtons[_currentIndex];
        
        [preTitle setTitleColor:[UIColor appTabTextColor] forState:UIControlStateNormal];
        preTitle.transform = CGAffineTransformIdentity;
        
        [button setTitleColor:[UIColor appTabSelectedTextColor] forState:UIControlStateNormal];
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
//        CGFloat oldX = self.frame.size.width / _titleButtons.count * _currentIndex;
//        CGFloat newX = self.frame.size.width / _titleButtons.count * button.tag;
//        NSLog(@"transform: old %.0f new %.0f y %.0f", oldX, newX, self.indicatorView.frame.origin.y);
//        
//        [UIView transitionWithView:self.indicatorView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//            self.indicatorView.transform = CGAffineTransformMakeTranslation(newX, button.frame.origin.y+button.frame.size.height);
//        } completion:nil];
//        [self bringSubviewToFront:self.indicatorView];
        
        CGRect iFrame = self.indicatorView.frame;
        NSInteger stretch = _currentIndex - button.tag;//ABS 求绝对值有问题。。。。。。。。。。
        if(stretch < 0) stretch = -stretch;
        
        if(_currentIndex > button.tag)
        {
            iFrame.origin.x -= iFrame.size.width * stretch;
        }
        else
        {
            iFrame.origin.x += iFrame.size.width * stretch;
        }
        NSLog(@"Indicator: %.0f %.0f %.0f %.0f", iFrame.origin.x, iFrame.origin.y, iFrame.size.width, iFrame.size.height);
        [self.indicatorView setFrame:iFrame];
        
        _currentIndex = button.tag;
        _titleButtonClicked(button.tag);
    }
}

- (void)setTitleButtonsColor
{
    for (UIButton *button in self.subviews) {
        button.backgroundColor = [UIColor appTabBackground];
    }
}

@end
