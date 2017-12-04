//
//  TagCollectionView.m
//  BuyGoodeals
//
//  Created by LabanL on 7/5/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import "BGDTagCollectionView.h"
#import "BGDTagCell.h"

@interface BGDTagCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation BGDTagCollectionView

- (id) initWithFrame:(CGRect)frame withTagArray:(NSArray *)tagArray
{
    BGDCollectionViewFlowLayout *flowLayout =
    [[BGDCollectionViewFlowLayout alloc] init];
    // 设置UICollectionView中各单元格的大小
    flowLayout.itemSize = CGSizeMake(54, 26);
    // 设置该UICollectionView只支持水平滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 设置各分区上、左、下、右空白的大小。
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 2, 2);
    flowLayout.minimumInteritemSpacing = 2;
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if(!self) return nil;
    
    if(tagArray == nil || tagArray.count <= 0)
    {
        self.tagArray = [[NSMutableArray alloc] init];
    }
    else
    {
        self.tagArray = [[NSMutableArray alloc] initWithArray:tagArray];
    }
    
    // 为UICollectionView设置dataSource和delegate
    self.dataSource = self;
    self.delegate = self;
    
    [self registerClass:[BGDTagCell class] forCellWithReuseIdentifier:@"tagCell"];
    
    return self;
}

- (void) updateTags:(NSArray*) tagArray isAdded:(BOOL) isAdded
{
    if(!isAdded)
    {
        [self.tagArray removeAllObjects];
    }
    [self.tagArray addObjectsFromArray:tagArray];
    
    [self reloadData];
}

// 该方法返回值决定各单元格的控件。
- (UICollectionViewCell *)collectionView:(UICollectionView *)
collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 为单元格定义一个静态字符串作为标示符
    static NSString* cellId = @"tagCell";
    // 从可重用单元格的队列中取出一个单元格
    BGDTagCell* cell = [BGDTagCell returnReuseCellFormCollectionView:collectionView indexPath:indexPath identifier:cellId];
    
    NSString* tag = self.tagArray[indexPath.row];
    float width = [NSString stringWithFormat:@"%@", self.tagArray[indexPath.row]].length * 12;
    [cell setTagStrData:tag];
    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, width, cell.frame.size.height)];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = [NSString stringWithFormat:@"%@", self.tagArray[indexPath.row]].length * 12 + 2;
    return CGSizeMake(width, 26);
}

// 该方法返回值决定UICollectionView包含多少个单元格
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.tagArray.count;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* clickedTagStr = self.tagArray[indexPath.row];
    if([self.tagActionDelegate respondsToSelector:@selector(tagClicked:)])
    {
        [self.tagActionDelegate tagClicked:clickedTagStr];
    }
}
@end
