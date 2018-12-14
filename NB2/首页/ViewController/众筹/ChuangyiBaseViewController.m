//
//  ChuangyiBaseViewController.m
//  NB2
//
//  Created by Jayzy on 2017/9/3.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ChuangyiBaseViewController.h"

@interface ChuangyiBaseViewController ()<TopViewDelegate>

@end

@implementation ChuangyiBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_LIGHTGRAY_BACK;
    [self navConfig];
}

- (void)navConfig
{
    self.topView = [[TopView alloc]init];
    self.topView.imgLeft=@"back_btn_n";
    self.topView.delegate=self;
    [self.view addSubview:self.topView];
    [self.topView setTopView];
}

-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionRight
{
   
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
