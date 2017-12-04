//
//  TestViewController.m
//  BuyGoodeals
//
//  Created by wfk on 16/6/23.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (weak, nonatomic) IBOutlet UIImageView* goodsImageView;

@end

@implementation TestViewController

- (id) init
{
    if([super init])
    {
        //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Test" bundle:[NSBundle mainBundle]];
        //由storyboard根据myView的storyBoardID来获取我们要切换的视图
        UITableViewController *myView = [story instantiateViewControllerWithIdentifier:@"testView"];
        self = myView;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 36)];
//    label.text = @"Hello world. Coding.";
//    [self.view addSubview:label];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
