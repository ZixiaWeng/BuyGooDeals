//
//  BGDGoodsCommentInfo.h
//  BuyGoodeals
//
//  Created by LabanL on 7/1/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGDGoodsCommentInfo : NSObject

@property (retain,nonatomic) NSString *author;
@property (retain,nonatomic) NSString *content;
@property (retain,nonatomic) NSString *author_email;
@property (retain,nonatomic) NSString *comment_ID;
@property (retain,nonatomic) NSString *block;
@property (retain,nonatomic) BGDGoodsCommentInfo *parent;
@property (retain,nonatomic) NSString *date;
@property (retain,nonatomic) NSString *head;
@property (retain,nonatomic) NSString *user_id;
@property (retain,nonatomic) NSString *author_url;

@end
