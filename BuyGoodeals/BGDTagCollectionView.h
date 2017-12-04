//
//  TagCollectionView.h
//  BuyGoodeals
//
//  Created by LabanL on 7/5/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGDCollectionViewFlowLayout.h"

@protocol BGDTagActionDelegate <NSObject>

- (void) tagClicked:(NSString*)tagStr;

@end

@interface BGDTagCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray* tagArray;
@property (nonatomic, weak) id<BGDTagActionDelegate> tagActionDelegate;

- (id) initWithFrame:(CGRect)frame withTagArray:(NSArray *)tagArray;
- (void) updateTags:(NSArray*) tagArray isAdded:(BOOL) isAdded;

@end
