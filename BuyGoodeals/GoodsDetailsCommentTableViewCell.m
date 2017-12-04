//
//  GoodsDetailsCommentTableViewCell.m
//  BuyGoodeals
//
//  Created by LabanL on 7/1/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import "GoodsDetailsCommentTableViewCell.h"
#import "Utils.h"

NSString* GoodsDetailsCommentTableViewCell_IdentifierString = @"BGDGoodsDetailsCommentTableViewCellReuseIdentifier";

@interface GoodsDetailsCommentTableViewCell ()

@property (strong, nonatomic) UIView* subContentView;
@property (strong, nonatomic) UIImageView* userLogo;
@property (strong, nonatomic) UILabel* userBlock;
@property (strong, nonatomic) UILabel* userName;
@property (strong, nonatomic) UILabel* commentPostDate;
@property (strong, nonatomic) UILabel* commentParentContent;
@property (strong, nonatomic) UILabel* commentContent;
@property (strong, nonatomic) UIButton* commentReply;

@end

@implementation GoodsDetailsCommentTableViewCell

+ (instancetype)returnReuseCellFormTableView:(UITableView *)tableView
                                   indexPath:(NSIndexPath *)indexPath
                                  identifier:(NSString *)identifierString
{
    GoodsDetailsCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierString forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[GoodsDetailsCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
    }
    
    return cell;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.subContentView = UIView.new;
        [self.contentView addSubview:self.subContentView];
        
        self.userLogo = UIImageView.new;
        self.userLogo.layer.cornerRadius = 26;
        [self.subContentView addSubview:self.userLogo];
        
        self.userBlock = UILabel.new;
        [self.subContentView addSubview:self.userBlock];
        
        self.userName = UILabel.new;
        [self.subContentView addSubview:self.userName];
        
        self.commentPostDate = UILabel.new;
        [self.subContentView addSubview:self.commentPostDate];
        
        self.commentParentContent = UILabel.new;
        [self.subContentView addSubview:self.commentParentContent];
        
        self.commentContent = UILabel.new;
        [self.subContentView addSubview:self.commentContent];
        
        self.commentReply = UIButton.new;
        [self.subContentView addSubview:self.commentReply];
    }
    
    return self;
}

- (void) setViewData:(BGDGoodsCommentInfo *)viewModel
{
    self.viewModel = viewModel;
    
    [self.userLogo loadPortrait:[NSURL URLWithString:self.viewModel.head] placeholderImage:[UIImage imageNamed:@"comment_user_default"]];
    
    self.userBlock.text = [NSString stringWithFormat:@"#%@", self.viewModel.block];
    [self.userBlock setFont:[UIFont systemFontOfSize:12.0f]];
    [self.userBlock setTextColor:[UIColor appColorItemWeaknessForeground]];
    [self.userBlock setTextAlignment:NSTextAlignmentCenter];
    
    self.userName.text = self.viewModel.author;
    [self.userName setFont:[UIFont systemFontOfSize:14.0f]];
    [self.userName setTextColor:[UIColor appColorItemWeaknessForeground]];
    
    self.commentPostDate.text = [Utils getShortTimeStr:self.viewModel.date];
    [self.commentPostDate setFont:[UIFont systemFontOfSize:12.0f]];
    [self.commentPostDate setTextColor:[UIColor appColorItemWeaknessForeground]];
    [self.commentPostDate setTextAlignment:NSTextAlignmentRight];
    
    if(self.viewModel.parent != nil)
    {
        [self.commentParentContent setHidden:NO];
        self.commentParentContent.text = [NSString stringWithFormat:@"%@: %@", self.viewModel.parent.author, self.viewModel.parent.content];
        [self.commentParentContent setTextColor:[UIColor appColorItemCommentContentForeground]];
        [self.commentParentContent setFont:[UIFont systemFontOfSize:14.0f]];
        [self.commentParentContent setBackgroundColor:[UIColor colorWithHex:0xF6F5F6]];//board color:9f9f9f
    }
    else
    {
        [self.commentParentContent setHidden:YES];
    }
    
    self.commentContent.text = self.viewModel.content;
    [self.commentContent setFont:[UIFont systemFontOfSize:14.0f]];
    [self.commentContent setTextColor:[UIColor appColorItemCommentContentForeground]];
    
    [self.commentReply setImage:[UIImage imageNamed:@"comment_reply"] forState:UIControlStateNormal];
    [self.commentReply setContentMode:UIViewContentModeScaleAspectFit];
    [self.commentReply addTarget:self action:@selector(commentReplyAction) forControlEvents:UIControlEventTouchUpInside];
    
    int padding = 10;
    
    [self.userLogo makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subContentView.left);
        make.top.equalTo(self.subContentView.top);
        make.width.equalTo(@52);
        make.height.equalTo(@52);
    }];
    
    [self.userBlock makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subContentView.left);
        make.top.equalTo(self.userLogo.bottom).offset(padding);
        make.bottom.lessThanOrEqualTo(self.subContentView.bottom);
        make.width.equalTo(self.userLogo.width);
    }];
    
    [self.commentPostDate makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self.userName.right);
        make.top.equalTo(self.subContentView.top).offset(padding);
        make.right.equalTo(self.subContentView.right);
    }];
    
    [self.userName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userLogo.right).offset(padding);
        make.top.equalTo(self.subContentView.top).offset(padding);
        make.right.lessThanOrEqualTo(self.commentPostDate.left).offset(-padding);
    }];
    
    [self.commentParentContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.bottom).offset(padding);
        make.left.equalTo(self.userLogo.right).offset(padding);
        make.right.equalTo(self.subContentView.right);
    }];
    
    [self.commentContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userLogo.right).offset(padding);
        make.top.equalTo(self.commentParentContent.bottom).offset(padding);
        make.right.equalTo(self.subContentView.right);
    }];
    
    [self.commentReply makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentContent.bottom).offset(padding);
        make.right.equalTo(self.subContentView.right).offset(-padding);
        make.width.equalTo(@18);
        make.bottom.equalTo(self.subContentView.bottom);
    }];
    
    [self.subContentView makeConstraints:^(MASConstraintMaker *make) {
        //            make.edges.equalTo(self.contentView).offset(@10);
        make.left.equalTo(self.contentView.left).offset(padding);
        make.top.equalTo(self.contentView.top).offset(padding);
        make.right.equalTo(self.contentView.right).offset(-padding);
        make.bottom.equalTo(self.contentView.bottom).offset(-padding);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    //TODO: 选中效果
}

- (void) commentReplyAction
{
    if([self.commentActionDelegate respondsToSelector:@selector(goodsDetailsCommentReply:)])
    {
        [self.commentActionDelegate goodsDetailsCommentReply:self.viewModel.comment_ID];
    }
}

@end
