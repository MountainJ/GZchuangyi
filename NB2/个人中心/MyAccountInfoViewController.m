//
//  MyAccountInfoViewController.m
//  NB2
//
//  Created by Jayzy on 2017/9/10.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "MyAccountInfoViewController.h"
#import "AddInputView.h"

@interface MyAccountInfoViewController ()
//@property (nonatomic,strong) AddInputView *yucunField;
//@property (nonatomic,strong) AddInputView *mingriField;

@property (nonatomic,strong) AddInputView *fushuField;
@property (nonatomic,strong) AddInputView *benjinField;
@property (nonatomic,strong) AddInputView *hongliField;
@property (nonatomic,strong) AddInputView *zhonggouField;
@property (nonatomic,strong) AddInputView *licaiField;
@property (nonatomic,strong) AddInputView *tianshiField;
@property (nonatomic,strong) AddInputView *paidanField;
@property (nonatomic,strong) AddInputView *yuanshiField;
@property (nonatomic,strong) AddInputView *gouwujifenField;



@end

@implementation MyAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topView.titileTx = @"我的账户";
    [self.topView setTopView];
    [self initUI];
    [self requestMyAccountInfo];
}

- (void)initUI
{
    
    self.fushuField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"负数钱包:"];
    [self.view addSubview:self.fushuField];
    
    self.benjinField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"本金钱包:"];
    [self.view addSubview:self.benjinField];
    
    self.hongliField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"红利钱包:"];
    [self.view addSubview:self.hongliField];
    self.zhonggouField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"众购钱包:"];
    [self.view addSubview:self.zhonggouField];
    self.licaiField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"理财钱包:"];
    [self.view addSubview:self.licaiField];
    self.tianshiField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"天使资本:"];
    [self.view addSubview:self.tianshiField];
    
    self.paidanField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"排单股权:"];
    [self.view addSubview:self.paidanField];
    
    self.yuanshiField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"原始股权:"];
    [self.view addSubview:self.yuanshiField];
    
    self.gouwujifenField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"购物积分:"];
    [self.view addSubview:self.gouwujifenField];

    WS(weakSelf)
    [self.fushuField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-KKFitScreen(80));
        make.height.mas_equalTo(KKFitScreen(60));
        make.top.mas_equalTo(weakSelf.topView.mas_bottom).with.offset(KKFitScreen(80));
    }];
    
    [self.benjinField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.fushuField);
        make.top.mas_equalTo(weakSelf.fushuField.mas_bottom).offset(KKFitScreen(30));
        make.height.mas_equalTo(weakSelf.fushuField.mas_height);
    }];
    
    [self.hongliField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.fushuField);
    make.top.mas_equalTo(weakSelf.benjinField.mas_bottom).offset(KKFitScreen(30));
        make.height.mas_equalTo(weakSelf.fushuField.mas_height);
    }];
    [self.zhonggouField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.fushuField);
    make.top.mas_equalTo(weakSelf.hongliField.mas_bottom).offset(KKFitScreen(30));
        make.height.mas_equalTo(weakSelf.fushuField.mas_height);
    }];
    [self.licaiField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.fushuField);
        make.top.mas_equalTo(weakSelf.zhonggouField.mas_bottom).offset(KKFitScreen(30));
        make.height.mas_equalTo(weakSelf.fushuField.mas_height);
    }];
    [self.tianshiField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.fushuField);
    make.top.mas_equalTo(weakSelf.licaiField.mas_bottom).offset(KKFitScreen(30));
        make.height.mas_equalTo(weakSelf.fushuField.mas_height);
    }];
    
    [self.paidanField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.fushuField);
        make.top.mas_equalTo(weakSelf.tianshiField.mas_bottom).offset(KKFitScreen(30));
        make.height.mas_equalTo(weakSelf.fushuField.mas_height);
    }];
    
    [self.yuanshiField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.fushuField);
        make.top.mas_equalTo(weakSelf.paidanField.mas_bottom).offset(KKFitScreen(30));
        make.height.mas_equalTo(weakSelf.fushuField.mas_height);
    }];
    
    [self.gouwujifenField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.fushuField);
        make.top.mas_equalTo(self.yuanshiField.mas_bottom).offset(KKFitScreen(30));
        make.height.mas_equalTo(self.fushuField.mas_height);
    }];
    
    

}

- (void)requestMyAccountInfo
{
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5]};
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestUserinfo" params:paramDict success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            [ToolControl showHudWithResult:NO andTip:@"数据有误！"];
            return ;
        }
        if (![dict[RequestResponseCodeKey] isEqualToString:RequestResponseCodeValue]) {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            return ;
        }
        if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
        {
            if ([dict[@"result"] isKindOfClass:[NSArray class]] && [dict[@"result"] count]){
                NSDictionary *userDict = [dict[@"result"] firstObject];

                self.fushuField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"fushuqianbao"] ? : @""];
                self.benjinField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"benjin"] ? : @""];
                self.hongliField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"hongli"] ? : @""];
                self.zhonggouField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"zhonggou"] ? : @""];
                self.licaiField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"licai"] ? : @""];
                self.tianshiField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"qianbao"] ? :@""];
                self.paidanField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"paidanguquan"] ? : @""];
                self.yuanshiField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"yuanshiguquan"] ? : @""];
                self.gouwujifenField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"gouwujifen"] ? : @""];

                self.fushuField.disableInput = YES;
                self.benjinField.disableInput = YES;
                self.hongliField.disableInput = YES;
                self.zhonggouField.disableInput = YES;
                self.licaiField.disableInput = YES;
                self.tianshiField.disableInput = YES;
                self.paidanField.disableInput = YES;
                self.yuanshiField.disableInput = YES;
                self.gouwujifenField.disableInput = YES;
                
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];


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
