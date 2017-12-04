//
//  UIButton+ImageAndLabel.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/29.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (UIButtonImageAndLabel)

- (void) setImageVertical:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;
- (void) setImageHorizontal:(UIImage*)image withTitle:(NSString*)title forState:(UIControlState)stateType;
+ (UIButton *)creatBtnWithTitle:(NSString *)title andImageName:(NSString *)image;

@end
