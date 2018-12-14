//
//  AddAddressInfoVC.m
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "AddAddressInfoVC.h"
#import "AddInputView.h"

@interface AddAddressInfoVC ()<TopViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) AddInputView *nameTextField;
@property (nonatomic,strong) AddInputView *phoneTextField;
@property (nonatomic,strong) AddInputView *addressTextField;

@property (nonatomic,strong) UIButton *defaulButton;
@property (nonatomic,strong) UIButton *unDefaultButton;

@property (nonatomic,strong) UILabel *tipsLabel;
@property (nonatomic,strong) UIButton *saveButton;

@end

@implementation AddAddressInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.titileTx = @"添加地址";
    self.topView.delegate = self;
    [self.topView setTopView];
    //

    [self initUI];
    
    [self requstUserData];
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
                self.nameTextField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"name"]];
                self.phoneTextField.textInputField.text = [NSString stringWithFormat:@"%@",userDict[@"phone"]];
                self.nameTextField.disableInput = YES;
                self.phoneTextField.disableInput = YES;
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];

   
}

- (void)initUI
{
    self.nameTextField = [[AddInputView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topView.frame) +  KKFitScreen(80), SCREEN_WIDTH - KKFitScreen(80), KKFitScreen(60)) titleName:@"姓名:"];
    if ([UNAME length] > 0) {
        self.nameTextField.textInputField.text = UNAME;
        self.nameTextField.disableInput = YES;
    }else{
        self.nameTextField.disableInput = NO;
        self.nameTextField.textInputField.placeholder = @"请输入姓名";
    }
    [self.view addSubview:self.nameTextField];
    
    self.phoneTextField = [[AddInputView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.nameTextField.frame) +  KKFitScreen(40), CGRectGetWidth(self.nameTextField.frame), CGRectGetHeight(self.nameTextField.frame)) titleName:@"联系电话:"];
    self.phoneTextField.textInputField.placeholder = @"请输入联系电话";
    self.phoneTextField.textInputField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.textInputField.delegate = self;
    [self.view addSubview:self.phoneTextField];

    self.addressTextField = [[AddInputView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.phoneTextField.frame) +  KKFitScreen(40), CGRectGetWidth(self.nameTextField.frame), CGRectGetHeight(self.nameTextField.frame)) titleName:@"收货地址:"];
    self.addressTextField.textInputField.placeholder = @"请输入收货地址";
    self.addressTextField.textInputField.delegate = self;

    [self.view addSubview:self.addressTextField];
    
    
    CGFloat width = KKFitScreen(100);
    CGFloat height = KKFitScreen(60);

    self.tipsLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressTextField.frame) + KKFitScreen(40), CGRectGetWidth(self.addressTextField.titleLabel.frame), height) backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self.view labelText:@"设为默认地址:"];
    self.tipsLabel.textAlignment = NSTextAlignmentRight;

    self.defaulButton = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.tipsLabel.frame) + 20, CGRectGetMinY(self.tipsLabel.frame), width, height) backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] clickAction:@selector(clidktype:) clickTarget:self addToView:self.view buttonText:@"是"];
    self.defaulButton.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(26)];
    self.defaulButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.defaulButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.defaulButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self.defaulButton setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [self.defaulButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    self.defaulButton.selected = YES;

    self.unDefaultButton = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.defaulButton.frame), CGRectGetMinY(self.defaulButton.frame), width, height) backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] clickAction:@selector(clidktype:) clickTarget:self addToView:self.view buttonText:@"否"];
    self.unDefaultButton.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(26)];
    [self.unDefaultButton setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    self.unDefaultButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.unDefaultButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self.unDefaultButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.unDefaultButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    
    //
  
    //
    self.saveButton = [UIButton buttonWithFrame:CGRectMake(KKFitScreen(60), CGRectGetMaxY(self.tipsLabel.frame) + KKFitScreen(40), SCREEN_WIDTH - 2 * KKFitScreen(60), KKFitScreen(70)) backGroundColor:COLOR_STATUS_NAV_BAR_BACK cornerRadius:5.0 textColor:[UIColor whiteColor] clickAction:@selector(saveAddrress) clickTarget:self addToView:self.view buttonText:@"提交保存"];
    
}


- (void)clidktype:(UIButton *)btn
{
    if (btn == self.defaulButton) {
        self.defaulButton.selected = YES;
        self.unDefaultButton.selected = NO;
    }else if (btn == self.unDefaultButton){
        self.unDefaultButton.selected = YES;
        self.defaulButton.selected = NO;
    }
}

- (void)saveAddrress
{
    [self requstUserSaveData];
}

- (void)requstUserSaveData
{
    NSString *address = [self.addressTextField.textInputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *type = self.defaulButton.selected ? @"1" :@"0";
    if (![address length]) {
        [ToolControl showHudWithResult:NO andTip:@"地址不能为空！"];
        return;
    }
    
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5],@"dizhi":address,@"type":type};
    [SVProgressHUD showWithStatus:@"添加中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestDizhiadd" params:paramDict success:^(NSDictionary *dict) {
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
            
            [ToolControl showHudWithResult:NO andTip:@"添加成功！"];
            if (self.saveSuccessBlock) {
                self.saveSuccessBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self actionLeft];
            });

            
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
}

#pragma mark - 

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}


- (void)didSaveAddress:(DidSuccessSaveAddress)saveBlock
{
    _saveSuccessBlock = saveBlock;
}

#pragma mark -
- (void)actionLeft
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
