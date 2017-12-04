//
//  BGDNetworkManager.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/22.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "BGDNetworkManager.h"
#import "BGDAPI.h"

@implementation BGDNetworkManager

+ (instancetype) sharedManager
{
    static BGDNetworkManager* manager = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
//        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:API_HOST]];
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype) init
{
    return [self initWithBaseURL:nil];
}

- (instancetype) initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if(self)
    {
        //self.requestSerializer.timeoutInterval = 30; //请求超时设定，不设定则使用默认
        self.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy; //默认缓存策略
        //NSURLRequestReloadIgnoringCacheData //忽略本地缓存，只加载网络数据
        //NSURLRequestReturnCacheDataElseLoad //先加载本地缓存，没有的情况下请求网络数据
        //NSURLRequestReturnCacheDataDontLoad //不加载本地缓存，直接请求网络数据
        
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"text/plain",@"text/json",@"text/javascript",nil];
        //self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [self.requestSerializer setValue:[BGDNetworkManager generateUserAgent] forHTTPHeaderField:@"User-Agent"];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    
    return self;
}

- (void) requestWithMethod:(HTTPMethod)method WithURL:(NSString *)url WithParams:(NSDictionary *)params WithSuccessBlock:(requestSuccessBlock)success WithFailureBlock:(requestFailureBlock)failure
{
    switch (method) {
        case GET:
        {
            [self GET:url parameters:params progress:nil success:^(NSURLSessionTask* task, NSDictionary* responseObject){
                NSLog(@"JSON:%@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask* opearation, NSError* error){
                NSLog(@"Error:%@", error);
                failure(error);
            }];
        }
            break;
        case POST:
        {
            [self POST:url parameters:params progress:nil success:^(NSURLSessionTask* task, NSDictionary* responseObject){
                NSLog(@"JSON:%@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask* opearation, NSError* error){
                NSLog(@"Error:%@", error);
                failure(error);
            }];
        }
            break;
        default:
            break;
    }
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
