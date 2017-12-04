//
//  AFHTTPSessionManager+Util.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/22.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "Reachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface AFHTTPSessionManager (Util)

+ (instancetype)BGDManager;
+ (NSString *)getNetconnType;

@end
