//
//  BGDGoodsTableViewCell.m
//  BuyGoodeals
//
//  Created by LabanL on 16/6/23.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "BGDGoodsTableViewCell.h"
#import "Utils.h"

NSString* BGDGoodsTableViewCell_IdentifierString = @"BGDGoodsTableViewCellReuseIdentifier";

@interface BGDGoodsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView* goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel* goodsDescLabel;
@property (weak, nonatomic) IBOutlet UILabel* goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel* goodsSourceLabel;
@property (weak, nonatomic) IBOutlet UILabel* goodsReleaseTimeLabel;

@end

@implementation BGDGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)returnReuseCellFormTableView:(UITableView *)tableView
                                   indexPath:(NSIndexPath *)indexPath
                                  identifier:(NSString *)identifierString
{
    BGDGoodsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierString forIndexPath:indexPath];
    
    return cell;
}

- (void) setViewModel:(BGDGoodsInfo *)viewModel
{
    _viewModel = viewModel;
    
    _goodsDescLabel.textColor = [UIColor appColorItemForeground];
    _goodsPriceLabel.textColor = [UIColor appColorItemHighlightForeground];
    _goodsSourceLabel.textColor = [UIColor appColorItemWeaknessForeground];
    _goodsReleaseTimeLabel.textColor = [UIColor appColorItemWeaknessForeground];
    
    [_goodsImageView loadPortrait:[NSURL URLWithString:viewModel.thumb]];
    _goodsDescLabel.text = viewModel.title;
    _goodsPriceLabel.text = viewModel.red_value;
    _goodsSourceLabel.text = viewModel.mall;
    _goodsReleaseTimeLabel.text = [Utils getShortTimeStr:viewModel.post_date];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    //TODO: 选中效果
}

@end
