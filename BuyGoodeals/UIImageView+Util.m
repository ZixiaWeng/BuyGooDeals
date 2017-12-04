//
//  UIImageView+Util.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/23.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "UIImageView+Util.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (Util)

- (void)loadPortrait:(NSURL *)portraitURL
{
    [self sd_setImageWithURL:portraitURL placeholderImage:[UIImage imageNamed:@"goods_default_image"] options:0];
}

- (void) loadPortrait:(NSURL *)portraitURL placeholderImage:(UIImage*)image
{
    [self sd_setImageWithURL:portraitURL placeholderImage:image options:0];
}

@end
