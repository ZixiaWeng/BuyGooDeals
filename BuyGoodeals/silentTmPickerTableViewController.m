//
//  silentTmPickerTableViewController.m
//  BuyGoodeals
//
//  Created by Eric on 7/6/16.
//  Copyright © 2016 BuyGoodeals. All rights reserved.
//

#import "silentTmPickerTableViewController.h"
#import "LocalDataKey.h"

@interface silentTmPickerTableViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *startTimePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *endTimePicker;
@property (nonatomic, strong) NSMutableArray *pickerDataA;
@property (nonatomic, strong) NSMutableArray *pickerDataB;
@property(nonatomic, strong)   NSUserDefaults *userDefaults ;

@property(nonatomic, strong) NSString *startHour;
@property(nonatomic, strong) NSString *startMin;
@property(nonatomic, strong) NSString *endHour;
@property(nonatomic, strong) NSString *endMin;


@end

@implementation silentTmPickerTableViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  _userDefaults = [NSUserDefaults standardUserDefaults];
  _startHour = [[_userDefaults objectForKey:SILENT_END_TIME] substringToIndex: 2];
  _endHour = [[_userDefaults objectForKey:SILENT_START_TIME] substringToIndex: 2];
  
  _pickerDataA = [[NSMutableArray alloc] init];
  _pickerDataB = [[NSMutableArray alloc] init];
  NSString *strValA = [[NSString alloc] init];
  NSString *strValB = [[NSString alloc] init];

  for (int k=0; k<24; k++) {
	if (k<10) {
	  strValA = [NSString stringWithFormat:@"%@%d", @"0", k];
	  [_pickerDataA addObject:strValA];
	}
	else{
	  [_pickerDataA addObject:[NSString stringWithFormat:@"%d",k]];
	}
  }
  for(int i=0; i<60; i++)
  {
	//create arrays with 0-60 mins

	if (i<10) {
	  strValB = [NSString stringWithFormat:@"%@%d", @"0", i];
	  [_pickerDataB addObject:strValB];
	}
	else{
	  strValB = [NSString stringWithFormat:@"%d", i];
	  [_pickerDataB addObject:strValB];
	}
	
  }
  NSString *silentStartTime = [_userDefaults objectForKey:SILENT_START_TIME];
  NSString *silentStartTimeHour = [silentStartTime substringToIndex: 2];
  NSString *silentStartTimeMin = [silentStartTime substringFromIndex: [silentStartTime length] - 2];
  NSString *silentEndTime = [_userDefaults objectForKey:SILENT_END_TIME];
  NSString *silentEndTimeHour = [silentEndTime substringToIndex: 2];
  NSString *silentEndTimeMin = [silentEndTime substringFromIndex: [silentEndTime length] - 2];
  [_startTimePicker reloadAllComponents];
  [_endTimePicker reloadAllComponents];
  
  [self.startTimePicker selectRow:[silentStartTimeHour intValue] inComponent:0 animated:YES];
  [self.startTimePicker selectRow:[silentStartTimeMin intValue] inComponent:1 animated:YES];
  
  [self.endTimePicker selectRow:[silentEndTimeHour intValue] inComponent:0 animated:YES];
  [self.endTimePicker selectRow:[silentEndTimeMin intValue] inComponent:1 animated:YES];
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  if (pickerView.tag == 1){
	return 2;
  }
  else{
	return 2;
  }
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  if (pickerView.tag == 1){
	if (component==0)
	{
	  return _pickerDataA.count;
	}
	else
	{
	  return _pickerDataB.count;
	}
  }
  else{
	if (component==0)
	{
	  return _pickerDataA.count;
	}
	else
	{
	  return _pickerDataB.count;
	}  }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

  if (pickerView.tag == 1){
	switch (component)
	{
	  case 0:
		return [_pickerDataA objectAtIndex:row];
		break;
	  case 1:
		return [_pickerDataB objectAtIndex:row];
		break;
	}
	return nil;
  }
  else{
	switch (component)
	{
	  case 0:
		return [_pickerDataA objectAtIndex:row];
		break;
	  case 1:
		return [_pickerDataB objectAtIndex:row];
		break;
	}
	return nil;
  }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
  //起始时间选择
  if (pickerView.tag == 1){
	NSString *startTimeStr = [_userDefaults objectForKey:SILENT_START_TIME];

	NSLog(@"tag 1 row is %ld", (long)row);
	
	NSString *a = [startTimeStr substringToIndex: 2];
	NSLog(@"tag 1 a is %@\n",a);
	NSString *b = [startTimeStr substringFromIndex: [startTimeStr length] - 2];
	NSLog(@"tag 1 b is %@\n",b);

	if (component == 0) {
	  a = [_pickerDataA objectAtIndex:row];
	  _startHour = a;
	  NSLog(@"tag 1 c0 a is %@\n starthour is %@",a, _startHour);
  
	  //如果开始时间大于结束时间，开始时间变为结束时间
	  _endHour = [[_userDefaults objectForKey:SILENT_END_TIME] substringToIndex: 2];
	  if ([a intValue] > [_endHour intValue]) {
		a = _endHour;
		[_startTimePicker selectRow:[a intValue] inComponent:0 animated:YES];
	  }
	  
	  NSString *c = [NSString stringWithFormat:@"%@:%@", a, b];
	  NSLog(@"tag 1 c0 c is %@\n",c);
	  [_userDefaults  setObject:c forKey:SILENT_START_TIME];

	}
	if (component == 1) {
	  b = [_pickerDataB objectAtIndex:row];
	  _startMin = b;
	  NSLog(@"tag 1 c1 b is %@\n",b);
	  
	  //如果小时时间相等，比较分钟
	  _endHour = [[_userDefaults objectForKey:SILENT_END_TIME] substringToIndex: 2];
	  _endMin = [[_userDefaults objectForKey:SILENT_END_TIME] substringFromIndex:[[_userDefaults objectForKey:SILENT_END_TIME] length] - 2];
	  if (([a intValue] == [_endHour intValue]) && ([b intValue] > [_endMin intValue])){
		b = _endMin;
		[_startTimePicker selectRow:[_endMin intValue] inComponent:1 animated:YES];
	  }
	  
	  NSString *c = [NSString stringWithFormat:@"%@:%@", a, b];
	  NSLog(@"tag 1 c1 c is %@\n",c);
	  [_userDefaults  setObject:c forKey:SILENT_START_TIME];

	}
	
	[_userDefaults synchronize];
  }
  
  //结束时间选择
  if (pickerView.tag == 2){
	NSString *startTimeStr = [_userDefaults objectForKey:SILENT_END_TIME];
	NSString *a =[startTimeStr substringToIndex: 2];
	NSLog(@"a is %@\n",a);
	NSString *b = [startTimeStr substringFromIndex: [startTimeStr length] - 2];
	NSLog(@"b is %@\n",b);
	
	if (component == 0) {

	  a = [_pickerDataA objectAtIndex:row];
	  _endHour = a;

	  NSLog(@"helooooo a is %@ starhour is %@", a, _startHour);
	  
	  //如果结束时间小于开始时间，结束时间变为开始时间
	  if ([a intValue] < [_startHour intValue]) {
		a = _startHour;
		[_endTimePicker selectRow:[_startHour intValue] inComponent:0 animated:YES];
	  }
	  NSLog(@"a is %@\n",a);
	  NSString *c = [NSString stringWithFormat:@"%@:%@", a, b];
	  NSLog(@"c is %@\n",c);
	  [_userDefaults  setObject:c forKey:SILENT_END_TIME];
	  
	}
	if (component == 1) {
	  b = [_pickerDataB objectAtIndex:row];
	  _endMin = b;
	  _startHour = [[_userDefaults objectForKey:SILENT_START_TIME] substringToIndex: 2];
	  _startMin = [[_userDefaults objectForKey:SILENT_START_TIME] substringFromIndex: [[_userDefaults objectForKey:SILENT_START_TIME] length] - 2];
	  NSLog(@"b is %@ starthour is %@ startMin is %@",b, _startHour, _startMin);
	  
	  //如果小时时间相等，比较分钟
	  if (([a intValue] == [_startHour intValue]) && ([b intValue] < [_startMin intValue])){
		[_endTimePicker selectRow:[_startMin intValue] inComponent:1 animated:YES];
		b = _startMin;
	  }
	  
	  NSString *c = [NSString stringWithFormat:@"%@:%@", a, b];
	  NSLog(@"c is %@\n",c);
	  [_userDefaults  setObject:c forKey:SILENT_END_TIME];
	}
	[_userDefaults synchronize];
  }
}


@end
