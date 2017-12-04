//
//  UserSettingsTableViewController.m
//  BuyGoodeals
//
//  Created by Eric on 6/30/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import "UserSettingsTableViewController.h"
#import "ImageCenterButton.h"
#import "Utils.h"
#import "LocalDataKey.h"

@interface UserSettingsTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *userActionBarView;
@property (weak, nonatomic) IBOutlet UIView *bgdLoginFrame;
@property (weak, nonatomic) IBOutlet UITableViewCell *userActionBarCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *userImageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *logOutFrame;
@property (weak, nonatomic) IBOutlet UITableViewCell *settingsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *imageDisplayOrNotCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nightModeCell;
@property (weak, nonatomic) IBOutlet UISwitch *imageDisplayOrNotSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *nightModeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *imageDisplayLabel;

@property (retain, nonatomic) ImageCenterButton *userCommentButton;
@property (retain, nonatomic)  ImageCenterButton *userFavListButton;
@property (retain, nonatomic)  ImageCenterButton *userPostButton;
@property (retain, nonatomic)  ImageCenterButton *userMsgListButton;
@property(nonatomic, strong)   NSUserDefaults *userDefaults ;

@end

@implementation UserSettingsTableViewController



- (void)viewDidLoad {
  [super viewDidLoad];

    NSLog(@"Settings show.");
  //设置本地储存
  _userDefaults = [NSUserDefaults standardUserDefaults];
  [self readNSUserDefaults];
  
  //设置4个功能键平均宽度
  float cellWidth = ([[UIScreen mainScreen] bounds].size.width - 9) / 4;
  
  //隐藏logout button
  [_imageDisplayLabel setLineBreakMode:NSLineBreakByTruncatingTail];
  _logOutFrame.hidden = TRUE;
  
  //设置点击效果
  _userImageCell.selectionStyle = NO;
  _userActionBarCell.selectionStyle = NO;
  _settingsCell.selectionStyle = NO;
  _imageDisplayOrNotCell.selectionStyle = NO;
  _nightModeCell.selectionStyle = NO;
  
//  //给按钮设圆角
//  _logOutButton.layer.cornerRadius = 3;
//  _logOutButton.clipsToBounds = YES;
  
  //_userCommentButton
  _userCommentButton = ImageCenterButton.new;
  [_userCommentButton setImage:[UIImage imageNamed:@"user_comment_list"] forState:UIControlStateNormal];
  [_userCommentButton setTitle:@"Comment" forState:UIControlStateNormal];
  [_userCommentButton setTitleColor:[UIColor appColorItemForeground] forState:UIControlStateNormal];
  [_userCommentButton setFont:[UIFont systemFontOfSize:14.0f]];
  [_userCommentButton setBackgroundColor:[UIColor appColorItemBackground]];
  [_userActionBarView addSubview:_userCommentButton];
  
  
  
  //_userFavListButton
  _userFavListButton = ImageCenterButton.new;
  [_userFavListButton setImage:[UIImage imageNamed:@"user_favo_list"] forState:UIControlStateNormal];
  [_userFavListButton setTitle:@"Favourite" forState:UIControlStateNormal];
  [_userFavListButton setTitleColor:[UIColor appColorItemForeground] forState:UIControlStateNormal];
  [_userFavListButton setFont:[UIFont systemFontOfSize:14.0f]];
  [_userFavListButton setBackgroundColor:[UIColor appColorItemBackground]];
  [_userActionBarView addSubview:_userFavListButton];
  
  
  //_userPostButton
  _userPostButton = ImageCenterButton.new;
  [_userPostButton setImage:[UIImage imageNamed:@"user_post_list"] forState:UIControlStateNormal];
  [_userPostButton setTitle:@"Post" forState:UIControlStateNormal];
  [_userPostButton setTitleColor:[UIColor appColorItemForeground] forState:UIControlStateNormal];
  [_userPostButton setFont:[UIFont systemFontOfSize:14.0f]];
  [_userPostButton setBackgroundColor:[UIColor appColorItemBackground]];
  [_userActionBarView addSubview:_userPostButton];
  
  //_userMsgListButton
  _userMsgListButton = ImageCenterButton.new;
  [_userMsgListButton setImage:[UIImage imageNamed:@"user_msg_list"] forState:UIControlStateNormal];
  [_userMsgListButton setTitle:@"Message" forState:UIControlStateNormal];
  [_userMsgListButton setTitleColor:[UIColor appColorItemForeground] forState:UIControlStateNormal];
  [_userMsgListButton setFont:[UIFont systemFontOfSize:14.0f]];
  [_userMsgListButton setBackgroundColor:[UIColor appColorItemBackground]];
  [_userActionBarView addSubview:_userMsgListButton];
  
  //设置约束
  [_userCommentButton makeConstraints:^(MASConstraintMaker *make) {
	make.left.equalTo(_userActionBarView.left);
	make.top.equalTo(_userActionBarView.top);
	make.height.equalTo(_userActionBarView.height);
	make.width.equalTo(cellWidth);
  }];
  
  [_userFavListButton makeConstraints:^(MASConstraintMaker *make) {
	make.left.equalTo(_userCommentButton.right).offset(3);
	make.top.equalTo(_userActionBarView.top);
	make.height.equalTo(_userActionBarView.height);
	make.width.equalTo(cellWidth);
  }];

  [_userPostButton makeConstraints:^(MASConstraintMaker *make) {
	make.left.equalTo(_userFavListButton.right).offset(3);
	make.top.equalTo(_userActionBarView.top);
	make.height.equalTo(_userActionBarView.height);
	make.width.equalTo(cellWidth);
  }];
  
  [_userMsgListButton makeConstraints:^(MASConstraintMaker *make) {
	make.left.equalTo(_userPostButton.right).offset(3);
	make.top.equalTo(_userActionBarView.top);
	make.height.equalTo(_userActionBarView.height);
	make.width.equalTo(cellWidth);
  }];
  
  //处理用流量看图片的开关
  [_imageDisplayOrNotSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
  [_nightModeSwitch addTarget:self action:@selector(switchIsChangedForNightMode:) forControlEvents:UIControlEventValueChanged];
  //  _userCommentButton.backgroundColor = [UIColor whiteColor];
//  _userFavListButton.backgroundColor = [UIColor whiteColor];
//  _userPostButton.backgroundColor = [UIColor whiteColor];
//  _userMsgListButton.backgroundColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//  [self configView];
}

-(void)readNSUserDefaults
{
  BOOL imageDisplaySwitchBool = [_userDefaults boolForKey:IMAGES_DISPLAY_KEY];
  if (imageDisplaySwitchBool == YES) {
	_imageDisplayOrNotSwitch.on = YES;
  }
  else
	_imageDisplayOrNotSwitch.on = NO;
  
  BOOL nightModeSwitchBool = [_userDefaults boolForKey:NIGHT_MODE_KEY];
  if (nightModeSwitchBool == YES) {
	_nightModeSwitch.on = YES;
  }
  else
	_nightModeSwitch.on = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//help Method for imageDisplayOrNotSwitch and nightModeSwitch
-(void)switchIsChanged:(UISwitch *)swith
{

  if ([_imageDisplayOrNotSwitch isOn]){
	[_userDefaults  setBool: YES forKey:IMAGES_DISPLAY_KEY];
	NSLog(@"ImageDisplayeSwtich is On!");
  }
  else{
	[_userDefaults  setBool: NO forKey:IMAGES_DISPLAY_KEY];
	NSLog(@"ImageDisplayeSwtich is Off!");
  }
  
  [_userDefaults synchronize];
  
}

-(void)switchIsChangedForNightMode:(UISwitch *)swith
{
  if ([_nightModeSwitch isOn]){
	[_userDefaults  setBool: YES forKey: NIGHT_MODE_KEY];
	NSLog(@"NIGHT_MODE_KEY is On!");
  }
  else{
	[_userDefaults  setBool: NO forKey: NIGHT_MODE_KEY];
	NSLog(@"NIGHT_MODE_KEY is Off!");
  }
  
  [_userDefaults synchronize];
}

#pragma mark - Table view data source

-(void)viewDidLayoutSubviews
{
  if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
	[self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
  }
  
  if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
	[self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
  }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
	[cell setSeparatorInset:UIEdgeInsetsZero];
  }
  
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
	[cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.section ==2 && indexPath.row == 2)
  {
//	[tableView.]
	NSLog(@"hi there");
  }
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  // rows in section 0 should not be selectable
//  if ( indexPath.section == 2 ) return nil;
//  
//  // first 3 rows in any section should not be selectable
//  if ( indexPath.row == 0 ) return nil;
//  
//  // By default, allow row to be selected
//  return indexPath;
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
