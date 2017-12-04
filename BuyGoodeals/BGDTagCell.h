//
//  TagCell.h
//  BuyGoodeals
//
//  Created by LabanL on 6/29/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGDTagCell : UICollectionViewCell

+ (instancetype) returnReuseCellFormCollectionView:(UICollectionView*)collectionView
                                         indexPath:(NSIndexPath*)indexPath
                                        identifier:(NSString*)identifierString;

- (void) setTagStrData:(NSString*)tagStr;

@property (nonatomic, strong) NSString* tagStr;

@end
