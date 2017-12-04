//
//  Utils.m
//  BuyGoodeals
//  Created by LabanL on 16/6/20.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
    //[HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    
    return HUD;
}

//将日期字符串转换为相对时间表示，超过7天则显示短时间字符串
+ (NSString*) getRelativeTimeStr:(NSString *)timeStr
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"]];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* sourceDate = [format dateFromString:timeStr];
    NSTimeInterval interval = [sourceDate timeIntervalSinceNow];
    if(interval > 0) {
        [format setDateFormat:@"MM-dd HH:mm"];
        return [format stringFromDate:sourceDate];
    }
    double timeInterval = fabs(interval);
    if(timeInterval < 60)
    {
        return [NSString stringWithFormat:@"%.0f%@", timeInterval, @"s ago"];
    }
    else if(timeInterval < 3600)
    {
        return [NSString stringWithFormat:@"%.0f%@", timeInterval / 60, @"m ago"];
    }
    else if(timeInterval < 86400)
    {
        return [NSString stringWithFormat:@"%.0f%@", timeInterval / 3600, @"h ago"];
    }
    else if(timeInterval < 604800)
    {
        return [NSString stringWithFormat:@"%.0f%@", timeInterval / 86400, @"d ago"];
    }
    else
    {
        [format setDateFormat:@"MM-dd HH:mm"];
        return [format stringFromDate:sourceDate];
    }
}

//相对时间小余一天只返回时间字符串，否则返回日期加时间
+ (NSString*) getShortTimeStr:(NSString *)timeStr
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"]];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* sourceDate = [format dateFromString:timeStr];
    NSTimeInterval interval = [sourceDate timeIntervalSinceNow];
    if(interval > 0) {
        [format setDateFormat:@"MM-dd HH:mm"];
        return [format stringFromDate:sourceDate];
    }
    double timeInterval = fabs(interval);
    if(timeInterval < 86400)
    {
        [format setDateFormat:@"HH:mm"];
        return [format stringFromDate:sourceDate];
    }
    else
    {
        [format setDateFormat:@"MM-dd HH:mm"];
        return [format stringFromDate:sourceDate];
    }
}

@end
