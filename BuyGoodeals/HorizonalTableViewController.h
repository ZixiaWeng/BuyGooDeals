//
//  HorizonalTableViewController.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/20.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizonalTableViewController : UITableViewController

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, copy) void (^changeIndex)(NSUInteger index);
@property (nonatomic, copy) void (^scrollView)(CGFloat offsetRatio, NSUInteger focusIndex, NSUInteger animationIndex);
@property (nonatomic, copy) void (^viewDidAppear)(NSInteger index);

@property (nonatomic, copy) void (^viewDidScroll)();

- (instancetype)initWithViewControllers:(NSArray *)controllers;

- (void)scrollToViewAtIndex:(NSUInteger)index;

@end
