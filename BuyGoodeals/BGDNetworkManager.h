//
//  BGDNetworkManager.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/22.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

typedef void (^requestSuccessBlock)(NSDictionary* dic);

typedef void (^requestFailureBlock)(NSError* error);

typedef enum
{
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;

@interface BGDNetworkManager : AFHTTPSessionManager

+ (instancetype) sharedManager;
- (void) requestWithMethod:(HTTPMethod)method
                  WithURL:(NSString*)path
                WithParams:(NSDictionary*)params
          WithSuccessBlock:(requestSuccessBlock)success
          WithFailureBlock:(requestFailureBlock)failure;
+ (NSString *)getNetconnType;

@end
