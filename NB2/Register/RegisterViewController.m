//
//  RegisterViewController.m
//  NB2
//
//  Created by zcc on 16/3/3.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "RegisterViewController.h"
#import "ResgitViewController.h"

#define LINE_COLOR  [[UIColor lightGrayColor] colorWithAlphaComponent:0.5]


@implementation RegisterViewController
{
    UITextField *nameTF;
    UITextField *keywordNoTF;
    NSString *code;
    TopView *topView;
    UIButton *lognA;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initTopView];
    [self initUI];
    // Do any additional setup after loading the view.
}-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"注册";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
}
-(void)initUI
{
    UIImageView *bodyView=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topView.frame))];
    bodyView.backgroundColor=[UIColor whiteColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [bodyView addGestureRecognizer:tap];
    bodyView.userInteractionEnabled=YES;
    [self.view addSubview:bodyView];
    
    CGFloat iconWidth = 100.;
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5 - iconWidth * 0.5, SCREEN_HEIGHT*0.05, iconWidth, iconWidth)];
    imgview.image=[UIImage imageNamed:@"logo"];
    [bodyView addSubview:imgview];
    
    // 用户名输入
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, CGRectGetMaxY(imgview.frame)+50,SCREEN_WIDTH*0.7, 40)];
    [nameTF setPlaceholder:@" 请输入手机号"];
    [self changeLayerCornerLeftImg:nameTF ];
    [bodyView addSubview:nameTF];
    
    // 验证码输入
    keywordNoTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, CGRectGetMaxY(nameTF.frame)+20, SCREEN_WIDTH*0.35, 40)];
    [keywordNoTF setPlaceholder:@" 请输入验证码"];
  
    [self changeLayerCornerLeftImg:keywordNoTF];
    [bodyView addSubview:keywordNoTF];
    
    lognA = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.55 ,CGRectGetMaxY(nameTF.frame)+20,SCREEN_WIDTH*0.3,40)];
    //    [lognB setBackgroundImage:[UIImage imageNamed:@"btn_big_n"] forState:UIControlStateNormal];
    lognA.backgroundColor = [UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
    lognA.layer.masksToBounds=YES;
    lognA.layer.cornerRadius=5;
    lognA.showsTouchWhenHighlighted = YES;
    [lognA setTitle:@"发送验证码" forState:UIControlStateNormal];
    [lognA.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [lognA addTarget:self action:@selector(yanzheng) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:lognA];
    
    UIButton *lognB = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.15 ,CGRectGetMaxY(keywordNoTF.frame)+20,SCREEN_WIDTH*0.7,40)];
    lognB.backgroundColor = [UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
    lognB.layer.masksToBounds=YES;
    lognB.layer.cornerRadius=5;
    lognB.showsTouchWhenHighlighted = YES;
    [lognB setTitle:@"提交注册" forState:UIControlStateNormal];
    [lognB.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [lognB addTarget:self action:@selector(registUser) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:lognB];
    
}


- (void)changeLayerCornerLeftImg:(UITextField *)textField
{
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
    textField.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
    
    textField.textColor=[UIColor darkTextColor];
    [textField setFont:[UIFont systemFontOfSize:15]];
    
    textField.backgroundColor= [UIColor whiteColor];
    [textField setValue:LINE_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    
    textField.layer.cornerRadius = 5.f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 1.f;
    textField.layer.borderColor =LINE_COLOR.CGColor;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.frame = CGRectMake(0, 0, 10., 30.);
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = imgView;
}



-(void)sendCode
{
    if ([nameTF.text length]!=11||[[nameTF.text substringWithRange:NSMakeRange(0, 1)] integerValue]!=1)
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入正确手机号"];
        return;
    }
    //[NSTimer scheduledTimerWithTimeInterval:60 target: self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",nameTF.text],@"phone",nil];
    [SVProgressHUD showWithStatus:@"发送中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestPhoneCode" params:dicton success:^(NSDictionary *dict){
        [SVProgressHUD dismiss];
        @try
        {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
               // [lognA setEnabled:NO];
                code=[[[dict objectForKey:@"result"] objectAtIndex:0] objectForKey:@"code"];
                [ToolControl showHudWithResult:NO andTip:@"注意查收短信"];
                
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        // [ToolControl hideHud];
        
    } failure:^(NSError *error) {
        [ToolControl hideHud];
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];


}
-(void)yanzheng
{
    if ([nameTF.text length]!=11||[[nameTF.text substringWithRange:NSMakeRange(0, 1)] integerValue]!=1)
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入正确手机号"];
        return;
    }
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestCheckuserinfo" params:@{@"title":nameTF.text,@"type":@"1"} success:^(NSDictionary *dict){
        @try
        {
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                [self sendCode];
            }else
            {
                [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            }
        }
        @catch (NSException *exception) {
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        }
        
    } failure:^(NSError *error) {
        return ;
        [ToolControl hideHud];
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
    
}

-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)registUser
{
    if ([nameTF.text length]!=11||[[nameTF.text substringWithRange:NSMakeRange(0, 1)] integerValue]!=1)
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入正确手机号"];
        return;
    }if (keywordNoTF.text.length==0) {
        [ToolControl showHudWithResult:NO andTip:@"请输入验证码"];
        return;
    }if (![code isEqualToString:keywordNoTF.text]) {
        [ToolControl showHudWithResult:NO andTip:@"验证码错误"];
        return;
    }
    
    ResgitViewController *resgit=[[ResgitViewController alloc] init];
    [self.navigationController pushViewController:resgit animated:YES];
     //跳转到注册界面
    
}
-(void)click
{
    [self.view endEditing:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
