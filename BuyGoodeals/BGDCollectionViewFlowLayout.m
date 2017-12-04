//
//  BGDCollectionViewFlowLayout.m
//  BuyGoodeals
//
//  Created by LabanL on 7/6/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import "BGDCollectionViewFlowLayout.h"

@implementation BGDCollectionViewFlowLayout

//解决Cell间间隔不一致的问题
- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        NSInteger maximumSpacing = 4;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}

@end
