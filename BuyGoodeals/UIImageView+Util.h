//
//  UIImageView+Util.h
//  BuyGoodeals
//
//  Created by Labanl on 16/6/23.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Util)

- (void)loadPortrait:(NSURL *)portraitURL;
- (void)loadPortrait:(NSURL*)portraitURL placeholderImage:(UIImage*)image;

@end
