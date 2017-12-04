//
//  SwipableViewController.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/20.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "SwipableViewController.h"
#import "Utils.h"
//#import "OSCAPI.h"
//#import "TweetsViewController.h"
//#import "PostsViewController.h"

@interface SwipableViewController ()  <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *controllers;

@end



@implementation SwipableViewController


- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers
{
    return [self initWithTitle:title andSubTitles:subTitles andControllers:controllers underTabbar:NO];
}

- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers underTabbar:(BOOL)underTabbar
{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //self.navigationController.navigationBar.translucent = NO;
        //self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        if (title) {self.title = title;}
        
        CGFloat titleBarHeight = 36;
        _titleBar = [[TitleBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, titleBarHeight) andTitles:subTitles];
        _titleBar.backgroundColor = [UIColor appTabBackground];
        [self.view addSubview:_titleBar];
        
        
        _viewPager = [[HorizonalTableViewController alloc] initWithViewControllers:controllers];
        
        CGFloat height = self.view.bounds.size.height - titleBarHeight - 64 - (underTabbar ? 49 : 0);
        _viewPager.view.frame = CGRectMake(0, titleBarHeight, self.view.bounds.size.width, height);
        
        [self addChildViewController:self.viewPager];
        [self.view addSubview:_viewPager.view];
        
        
        __weak TitleBarView *weakTitleBar = _titleBar;
        __weak HorizonalTableViewController *weakViewPager = _viewPager;
        
        _viewPager.changeIndex = ^(NSUInteger index) {
            weakTitleBar.currentIndex = index;
            for (UIButton *button in weakTitleBar.titleButtons) {
                if (button.tag != index) {
                    [button setTitleColor:[UIColor appTabTextColor] forState:UIControlStateNormal];
                    button.transform = CGAffineTransformIdentity;
                } else {
                    [button setTitleColor:[UIColor appTabSelectedTextColor] forState:UIControlStateNormal];
                    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
                }
            }
            CGRect iFrame = weakTitleBar.indicatorView.frame;
            iFrame.origin.x = iFrame.size.width * index;
            [weakTitleBar.indicatorView setFrame:iFrame];
            
            [weakViewPager scrollToViewAtIndex:index];
        };
        
        _viewPager.scrollView = ^(CGFloat offsetRatio, NSUInteger focusIndex, NSUInteger animationIndex) {
            UIButton *titleFrom = weakTitleBar.titleButtons[animationIndex];
            UIButton *titleTo = weakTitleBar.titleButtons[focusIndex];
//            UIView *indicatorView = weakTitleBar.indicatorView;
            
//            CGFloat redColorValue = (CGFloat)0xf0 / (CGFloat)0xFF;
//            CGFloat greenColorValue = (CGFloat)0x48 / (CGFloat)0xff;
//            CGFloat blueColorValue = (CGFloat)0x47 / (CGFloat)0xff;
            
            [UIView transitionWithView:titleFrom duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                [titleFrom setTitleColor:[UIColor colorWithRed:redColorValue*(1-offsetRatio) green:greenColorValue*(1-offsetRatio) blue:blueColorValue*(1-offsetRatio) alpha:1.0]
//                                forState:UIControlStateNormal];
                titleFrom.transform = CGAffineTransformMakeScale(1 + 0.2 * offsetRatio, 1 + 0.2 * offsetRatio);
            } completion:nil];
            
            
            [UIView transitionWithView:titleTo duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                [titleTo setTitleColor:[UIColor colorWithRed:redColorValue*offsetRatio green:greenColorValue*offsetRatio blue:blueColorValue*offsetRatio alpha:1.0]
//                              forState:UIControlStateNormal];
                titleTo.transform = CGAffineTransformMakeScale(1 + 0.2 * (1-offsetRatio), 1 + 0.2 * (1-offsetRatio));
            } completion:nil];
            
            
//            CGRect iFrame = indicatorView.frame;
//            CGFloat newX = iFrame.origin.x;
//            if(animationIndex > focusIndex)
//            {
//                newX -= iFrame.size.width * offsetRatio;
//            }
//            else
//            {
//                newX += iFrame.size.width * offsetRatio;
//            }
//            [UIView transitionWithView:indicatorView duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                indicatorView.transform = CGAffineTransformMakeTranslation(newX, iFrame.origin.y);
//            } completion:nil];
        };
        
        
        _titleBar.titleButtonClicked = ^(NSUInteger index) {
            [weakViewPager scrollToViewAtIndex:index];
        };
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appBackground];
}


- (void)scrollToViewAtIndex:(NSUInteger)index
{
    _viewPager.changeIndex(index);
}

@end
