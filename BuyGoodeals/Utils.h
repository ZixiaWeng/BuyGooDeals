//
//  Utils.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/20.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIColor+Util.h"
#import "UIImageView+Util.h"
#import "UIButton+ImageAndLabel.h"
#import "UIImage+Util.h"
#import "LocalDataKey.h"

#import <MBProgressHUD.h>

@class MBProgressHUD;

@interface Utils : NSObject

+ (MBProgressHUD *)createHUD;

+ (NSString*) getRelativeTimeStr:(NSString*)timeStr;
+ (NSString*) getShortTimeStr:(NSString*)timeStr;
@end
