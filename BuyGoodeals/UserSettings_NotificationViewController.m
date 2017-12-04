//
//  UserSettings_NotificationViewController.m
//  BuyGoodeals
//
//  Created by Eric on 7/5/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import "UserSettings_NotificationViewController.h"
#import "LocalDataKey.h"

@interface UserSettings_NotificationViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *pushNotificationCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *voiceCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *vibrationCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *silentTimeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *silentTimeSessionCell;
@property (weak, nonatomic) IBOutlet UISwitch *pushNotifSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *voiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *vibrationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *silentTimeSwitch;

@property (weak, nonatomic) IBOutlet UILabel *silentTimeStart;
@property (weak, nonatomic) IBOutlet UILabel *silentTimeEnd;

@property(nonatomic, strong)   NSUserDefaults *userDefaults ;


@end

@implementation UserSettings_NotificationViewController

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  //设置本地储存
  _userDefaults = [NSUserDefaults standardUserDefaults];
  [self readNSUserDefaults];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  //取消点击效果
  _pushNotificationCell.selectionStyle = NO;
  _voiceCell.selectionStyle = NO;
  _vibrationCell.selectionStyle = NO;
  _silentTimeCell.selectionStyle = NO;
  
  [_pushNotifSwitch addTarget:self action:@selector(switchIsChangedForPN:) forControlEvents:UIControlEventValueChanged];
  [_voiceSwitch addTarget:self action:@selector(switchIsChangedForVoice:) forControlEvents:UIControlEventValueChanged];
  [_vibrationSwitch addTarget:self action:@selector(switchIsChangedForVbrt:) forControlEvents:UIControlEventValueChanged];
  [_silentTimeSwitch addTarget:self action:@selector(switchIsChangedForSilentTm:) forControlEvents:UIControlEventValueChanged];
//  if (_startTimePicker) _startTimePicker.hidden = !_startTimePicker.hidden;
}

-(void)readNSUserDefaults{
  if ([_userDefaults objectForKey:SILENT_START_TIME]) {
	_silentTimeStart.text = [_userDefaults objectForKey:SILENT_START_TIME];
  }
  if ([_userDefaults objectForKey:SILENT_END_TIME]) {
	_silentTimeEnd.text = [_userDefaults objectForKey:SILENT_END_TIME];
  }
  
  BOOL pNBool = [_userDefaults boolForKey:PUSH_NOTIFICATION_KEY];
  if (pNBool == YES) {
	_pushNotifSwitch.on = YES;
	_voiceSwitch.on = [_userDefaults boolForKey:VOICE_KEY];
	_vibrationSwitch.on = [_userDefaults boolForKey:VIBRATION_KEY];
	_silentTimeSwitch.on = [_userDefaults boolForKey:SILENT_TIME_KEY];
	_silentTimeSessionCell.userInteractionEnabled =[_userDefaults boolForKey:SILENT_TIME_SESSION_CELL_ENABLE];
	
  }
  else{
	_pushNotifSwitch.on = NO;
	_voiceSwitch.on = [_userDefaults boolForKey:VOICE_KEY];
	_vibrationSwitch.on = [_userDefaults boolForKey:VIBRATION_KEY];
	_silentTimeSwitch.on = [_userDefaults boolForKey:SILENT_TIME_KEY];
	_voiceSwitch.enabled = [_userDefaults boolForKey:VOICE_SWITCH_ENABLE];
	_vibrationSwitch.enabled = [_userDefaults boolForKey:VIBRATION_SWITCH_ENABLE];
	_silentTimeSwitch.enabled = [_userDefaults boolForKey:SILENT_SWITCH_ENABLE];
	_silentTimeSessionCell.userInteractionEnabled = NO;
	
  }

}

//添加pushNotifSwitch, voiceSwitch, vibrationSwitch, silentTimeSwitch响应事件
-(void)switchIsChangedForPN:(UISwitch *)swith
{
  
  if ([_pushNotifSwitch isOn]){
	[_userDefaults  setBool: YES forKey:PUSH_NOTIFICATION_KEY];
	[_userDefaults setBool:YES forKey:VOICE_SWITCH_ENABLE];
	_voiceSwitch.enabled = YES;
	[_userDefaults setBool:YES forKey:VIBRATION_SWITCH_ENABLE];
	_vibrationSwitch.enabled = YES;
	[_userDefaults setBool:YES forKey:SILENT_SWITCH_ENABLE];
	_silentTimeSwitch.enabled = YES;
	_silentTimeSessionCell.userInteractionEnabled = _silentTimeSwitch.on;
	NSLog(@"pushNotifSwitch is On!");
  }
  else{
	[_userDefaults  setBool: NO forKey:PUSH_NOTIFICATION_KEY];
	[_userDefaults setBool:NO forKey:VOICE_SWITCH_ENABLE];
	_voiceSwitch.enabled = NO;
	[_userDefaults setBool:NO forKey:VIBRATION_SWITCH_ENABLE];
	_vibrationSwitch.enabled = NO;
	[_userDefaults setBool:NO forKey:SILENT_SWITCH_ENABLE];
	_silentTimeSwitch.enabled = NO;
	_silentTimeSessionCell.userInteractionEnabled = NO;
	NSLog(@"pushNotifSwitch is Off!");
  }
  [_userDefaults synchronize];
}

-(void)switchIsChangedForVoice:(UISwitch *)swith
{
  
  if ([_voiceSwitch isOn]){
	[_userDefaults  setBool: YES forKey:VOICE_KEY];
	NSLog(@"VoiceSwitch is On!");
  }
  else{
	[_userDefaults  setBool: NO forKey:VOICE_KEY];
	NSLog(@"VoiceSwitch is Off!");
  }
  [_userDefaults synchronize];
}

-(void)switchIsChangedForVbrt:(UISwitch *)swith
{
  
  if ([_vibrationSwitch isOn]){
	[_userDefaults  setBool: YES forKey:VIBRATION_KEY];
	NSLog(@"VibrationSwitch is On!");
  }
  else{
	[_userDefaults  setBool: NO forKey:VIBRATION_KEY];
	NSLog(@"VibrationSwitch is Off!");
  }
  
  [_userDefaults synchronize];
}

-(void)switchIsChangedForSilentTm:(UISwitch *)swith
{
  
  if ([_silentTimeSwitch isOn]){
	[_userDefaults  setBool: YES forKey:SILENT_TIME_KEY];
	[_userDefaults  setBool: YES forKey:SILENT_TIME_SESSION_CELL_ENABLE];
	_silentTimeSessionCell.userInteractionEnabled = YES;

	NSLog(@"SilentTimeSwitch is On!");
  }
  else{
	[_userDefaults  setBool: NO forKey:SILENT_TIME_KEY];
	
	NSLog(@"SilentTimeSwitch is Off!");
	[_userDefaults  setBool: NO forKey:SILENT_TIME_SESSION_CELL_ENABLE];
	_silentTimeSessionCell.userInteractionEnabled = NO;
  }
  
  [_userDefaults synchronize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
  
  if (indexPath.section == 0 && indexPath.row == 4)
  {
	NSLog(@"hi there");
//	NSString *title = [NSString stringWithFormat:@"Make default?"];
//	
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//	
//	[alert show];
  }
}

// returns the number of 'columns' to display.


//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//  return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//  return 0;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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
