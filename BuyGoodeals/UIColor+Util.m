//
//  UIColor+Util.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/20.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "UIColor+Util.h"
#import "AppDelegate.h"

@implementation UIColor (Util)

#pragma mark - Hex

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                           blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

#pragma mark - Theme color

+ (UIColor *)appColorPrimary
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode) {
        return [UIColor colorWithHex:0xc0312e];
    }
    return [UIColor colorWithHex:0xf04847];
}

+ (UIColor *)appColorPrimaryDark
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode) {
        return [UIColor colorWithHex:0xa23636];
    }
    return [UIColor colorWithHex:0xc94749];
}

+ (UIColor *)appColorAccent
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode) {
        return [UIColor colorWithHex:0xffffff];
    }
    return [UIColor colorWithHex:0x000000];
}

+ (UIColor *)appBackground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0x1f1f1f];
    }
    return [UIColor colorWithHex:0xe9e9e9];
}

+ (UIColor *)appColorForeground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0xa8a8a8];
    }
    return [UIColor colorWithHex:0x000000];
}

+ (UIColor *)appColorForegroundDark
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0xffffff];
    }
    return [UIColor colorWithHex:0x000000];
}

+ (UIColor *)appColorHighlightForeground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0xc0312e];
    }
    return [UIColor colorWithHex:0xf04847];
}

+ (UIColor *)appColorWeaknessForeground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0x717171];
    }
    return [UIColor colorWithHex:0xababab];
}

+ (UIColor *)appTabBackground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0x222222];
    }
    return [UIColor colorWithHex:0xffffff];
}

+ (UIColor *)appTabTextColor
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0xcecdcd];
    }
    return [UIColor colorWithHex:0xcfcece];
}

+ (UIColor *)appTabSelectedTextColor
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0xc0312e];
    }
    return [UIColor colorWithHex:0xf04847];
}

+ (UIColor *)appTabIndicatorColor
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0xc0312e];
    }
    return [UIColor colorWithHex:0xf04847];
}

+ (UIColor *)appColorItemImageBackground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0xffffff];
    }
    return [UIColor colorWithHex:0xffffff alpha:0.0];//日间模式图片背景为透明
}

+ (UIColor *)appColorItemForeground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0xa8a8a8];
    }
    return [UIColor colorWithHex:0x000000];
}

+ (UIColor *)appColorItemHighlightForeground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0xc0312e];
    }
    return [UIColor colorWithHex:0xf04847];
}

+ (UIColor *)appColorItemWeaknessForeground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0x717171];
    }
    return [UIColor colorWithHex:0xababab];
}

+ (UIColor *)appColorItemBackground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0x222222];
    }
    return [UIColor colorWithHex:0xffffff];
}

+ (UIColor *)appColorItemDisabledBackground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0x222222 alpha:0.6];
    }
    return [UIColor colorWithHex:0xffffff alpha:0.6];
}

+ (UIColor *)appColorItemSelectedBackground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0x000000 alpha:0.375];
    }
    return [UIColor colorWithHex:0x000000 alpha:0.375];
}

+ (UIColor *)appColorItemCommentContentForeground
{
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).isNightMode){
        return [UIColor colorWithHex:0x676767];
    }
    return [UIColor colorWithHex:0x676767];
}

@end
