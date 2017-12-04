//
//  UIColor+Util.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/20.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;

//+ (UIColor *)colorPrimary;
//+ (UIColor *)colorPrimaryDark;
//+ (UIColor *)colorAccent;

+ (UIColor *)appColorPrimary;
+ (UIColor *)appColorPrimaryDark;
+ (UIColor *)appColorAccent;

+ (UIColor *)appBackground;
+ (UIColor *)appColorForeground;
+ (UIColor *)appColorForegroundDark;
+ (UIColor *)appColorHighlightForeground;
+ (UIColor *)appColorWeaknessForeground;

+ (UIColor *)appTabBackground;
+ (UIColor *)appTabTextColor;
+ (UIColor *)appTabSelectedTextColor;
+ (UIColor *)appTabIndicatorColor;

+ (UIColor *)appColorItemImageBackground;
//+ (UIColor *)appItemBackground;//drawable
+ (UIColor *)appColorItemForeground;
+ (UIColor *)appColorItemHighlightForeground;
+ (UIColor *)appColorItemWeaknessForeground;
+ (UIColor *)appColorItemBackground;
+ (UIColor *)appColorItemDisabledBackground;
+ (UIColor *)appColorItemSelectedBackground;
+ (UIColor *)appColorItemCommentContentForeground;

//+ (UIColor *)appLayoutBackground;//drawable
@end
