//
//  UIButton+ImageAndLabel.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/29.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "UIButton+ImageAndLabel.h"
//#import "Utils.h"

@implementation UIButton (UIButtonImageAndLabel)

- (void) setImageVertical:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType
{
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:16.0f]];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0, 0.0, 0.0, -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0, -image.size.width, 0.0, 0.0)];
    [self setTitle:title forState:stateType];
}

- (void) setImageHorizontal:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType
{
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:16.0f]];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0, 0.0, 0.0, 0.0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0, 0.0, 0.0, 0.0)];
    [self setTitle:title forState:stateType];
}

+ (UIButton *)creatBtnWithTitle:(NSString *)title andImageName:(NSString *)image
{
    UIImage *buttonImage = [UIImage imageNamed:image];
    CGFloat buttonImageViewWidth = CGImageGetWidth(buttonImage.CGImage);
    CGFloat buttonImageViewHeight = CGImageGetHeight(buttonImage.CGImage);
    
    NSString *buttonTitle = title;
    
    UIFont *buttonTitleFont = [UIFont systemFontOfSize:18.0f];
    
    CGSize buttonTitleLabelSize = [buttonTitle sizeWithAttributes:@{NSFontAttributeName:buttonTitleFont}];
    // button宽度,至少为imageView宽度与titleLabel宽度之和
    CGFloat buttonWidth = buttonImageViewWidth + buttonTitleLabelSize.width;
    // button高度,至少为imageView高度与titleLabel高度之和
    CGFloat buttonHeight = buttonImageViewHeight + buttonTitleLabelSize.height;
    
    UIButton *tempBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    [tempBtn setBounds:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    [tempBtn.titleLabel setFont:buttonTitleFont];
    [tempBtn setImage:buttonImage forState:UIControlStateNormal];
    [tempBtn.imageView setBackgroundColor:[UIColor clearColor]];
    tempBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [tempBtn setTitle:buttonTitle forState:UIControlStateNormal];
    [tempBtn.titleLabel setBackgroundColor:[UIColor clearColor]];
    
    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(tempBtn.bounds), CGRectGetMidY(tempBtn.bounds));
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x - tempBtn.bounds.size.width/2+tempBtn.imageView.bounds.size.width/2, buttonBoundsCenter.y);
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x+tempBtn.bounds.size.width/2 - tempBtn.titleLabel.bounds.size.width/2, buttonBoundsCenter.y);
    // 取得imageView最初的center
    CGPoint startImageViewCenter = tempBtn.imageView.center;
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = tempBtn.titleLabel.center;
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    tempBtn.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    tempBtn.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
    
    NSLog(@"Button Size:%0.f %0.f", tempBtn.bounds.size.width, tempBtn.bounds.size.height);
    
    return tempBtn;
}

@end
