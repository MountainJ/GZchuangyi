//
//  JihuomaInputVC.m
//  NB2
//
//  Created by Jayzy on 2017/9/10.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "JihuomaInputVC.h"
#import "AddInputView.h"
#import "JihuomaHistoryViewController.h"

@interface JihuomaInputVC ()

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) AddInputView *nameField;

@property (nonatomic,strong) AddInputView *numberField;
@property (nonatomic,strong) AddInputView *passwordField;

@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *duihuanButton;

@end

@implementation JihuomaInputVC
- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE, SCREEN_WIDTH, SCREEN_HEIGHT - (20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE))];
        _containerView.backgroundColor = COLOR_LIGHTGRAY_BACK;
        [self.view addSubview:_containerView];
    }
    return _containerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Dispose of any resources that can be recreated.
    self.topView.titileTx = @"激活码兑换";
    self.topView.buttonRB = @"兑换记录";
    [self.topView setTopView];
    
    [self initUI];
    
    [self requstUserData];
}



- (void)initUI
{
    self.nameField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"创益金币数量:"];
    [self.containerView addSubview:self.nameField];

    self.numberField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"兑换激活码数量:"];
    self.numberField.textInputField.placeholder = @"请输入兑换数量";
    [self.containerView addSubview:self.numberField];
    
    self.passwordField = [[AddInputView alloc] initWithFrame:CGRectZero titleName:@"二级密码:"];
    self.passwordField.textInputField.placeholder = @"请输入二级密码";
    self.passwordField.textInputField.secureTextEntry = YES;
    [self.containerView addSubview:self.passwordField];
    
    
    self.tipLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor redColor] textFont:[UIFont systemFontOfSize:KKFitScreen(24)] addToView:self.containerView labelText:@"4个创益金币兑换一个激活码"];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.numberOfLines = 0 ;
    
    self.duihuanButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:COLOR_STATUS_NAV_BAR_BACK cornerRadius:5.0f textColor:[UIColor whiteColor] clickAction:@selector(duihuan) clickTarget:self addToView:self.containerView buttonText:@"兑换"];
    
    
    
    [self frameConfig];
}



- (void)frameConfig
{
    WS(weakSelf)
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.containerView.mas_left);
        make.right.mas_equalTo(weakSelf.containerView.mas_right).offset(-KKFitScreen(80));
        make.height.mas_equalTo(KKFitScreen(60));
        make.top.mas_equalTo(weakSelf.containerView.mas_top).with.offset(KKFitScreen(80));
    }];

    [self.numberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameField);
        make.top.mas_equalTo(weakSelf.nameField.mas_bottom).offset(KKFitScreen(30));
        make.height.mas_equalTo(weakSelf.nameField.mas_height);
    }];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameField);
        make.top.mas_equalTo(weakSelf.numberField.mas_bottom).offset(KKFitScreen(30));
        make.height.mas_equalTo(weakSelf.nameField.mas_height);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.containerView.mas_left).offset(KKFitScreen(30));
        make.right.mas_equalTo(weakSelf.containerView.mas_right).offset(-KKFitScreen(30));
        make.top.mas_equalTo(weakSelf.passwordField.mas_bottom).offset(KKFitScreen(30));
        make.height.mas_equalTo(KKFitScreen(50));
    }];
    [self.duihuanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.containerView.mas_left).offset(KKFitScreen(60));
        make.right.mas_equalTo(weakSelf.containerView.mas_right).offset(-KKFitScreen(60));
        make.top.mas_equalTo(weakSelf.tipLabel.mas_bottom).offset(KKFitScreen(40));
        make.height.mas_equalTo(KKFitScreen(70));
    }];
}

- (void)requstUserData
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
                self.nameField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"jinbi"]];
                self.nameField.disableInput = YES;
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
}

- (void)duihuan
{
    [self userRequstDuihuan];
}

- (void)userRequstDuihuan
{
    NSString *numbers = [self.numberField.textInputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pwd = [self.passwordField.textInputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![numbers length]) {
        [ToolControl showHudWithResult:NO andTip:@"兑换数量不能为空！"];
        return;
    }
    if (![pwd length]) {
        [ToolControl showHudWithResult:NO andTip:@"二级密码不能为空！"];
        return;
    }
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5],@"num":numbers,@"erpwd":pwd};
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestDuihuanjhm" params:paramDict success:^(NSDictionary *dict) {
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
            //            if ([dict[@"result"] isKindOfClass:[NSArray class]] && [dict[@"result"] count]){
            //                NSDictionary *userDict = [dict[@"result"] firstObject];
            //            }
            [self actionRight];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
    
}

#pragma mark - 兑换记录

- (void)actionRight
{
    JihuomaHistoryViewController  *hisvc = [JihuomaHistoryViewController new];
    [self.navigationController pushViewController:hisvc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
