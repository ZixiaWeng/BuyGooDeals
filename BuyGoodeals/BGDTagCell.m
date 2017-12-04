//
//  TagCell.m
//  BuyGoodeals
//
//  Created by LabanL on 6/29/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import "BGDTagCell.h"
#import "Utils.h"

@interface BGDTagCell ()

@property (nonatomic, strong) UILabel* tagLabel;

@end

@implementation BGDTagCell

+ (instancetype) returnReuseCellFormCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifierString
{
    BGDTagCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierString forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[BGDTagCell alloc] initWithFrame:CGRectMake(0, 0, 54, 26)];
    }
    
    return cell;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self) return nil;
    
    self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 50, 22)];
    [self.contentView addSubview:self.tagLabel];
    
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor appColorWeaknessForeground].CGColor;
    
    return self;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];

    [self.tagLabel setFrame:CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4)];
}

- (void) setTagStrData:(NSString *)tagStr
{
    self.tagStr = tagStr;
    
    [self.tagLabel setBackgroundColor:[UIColor clearColor]];
    [self.tagLabel setText:tagStr];
    [self.tagLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.tagLabel setTextColor:[UIColor appColorWeaknessForeground]];
    [self.tagLabel setContentMode:UIViewContentModeCenter];
    [self.tagLabel setTextAlignment:NSTextAlignmentCenter];
}

@end
