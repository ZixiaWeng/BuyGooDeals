//
//  AFHTTPSessionManager+Util.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/22.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "AFHTTPSessionManager+Util.h"


@implementation AFHTTPSessionManager (Util)

+ (instancetype)BGDManager
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"]; //同下
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:[self generateUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    return manager;
}

+ (NSString*)generateUserAgent
{
    //Android---BuyGoodeals/%s (DeviceId:%s;Manufacturer:%s;PhoneBrand:%s;PhoneModel:%s;AndroidVer:%s;NetworkType:%s)
    NSString* appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString* UA = [NSString stringWithFormat:@"BuyGoodeals/%@ (DeviceId:%@;Manufacturer:Apple;PhoneBrand:Apple;PhoneModel:%@;iOSVer:%@;NetworkType:%@)",
            appVersion, IDFV, phoneModel, phoneVersion, [self getNetconnType]];
    
    //NSLog(@"%@", UA);
    
    return UA;
}

+ (NSString *)getNetconnType
{
    NSString *netconnType = @"";
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            netconnType = @"NO NETWORK";
        }
            break;
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"WIFI";
        }
            break;
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                netconnType = @"4G";
            }
        }
            break;
        default:
            break;
    }
    
    return netconnType;
}

@end
