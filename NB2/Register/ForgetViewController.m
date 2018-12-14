//
//  ForgetViewController.m
//  NB2
//
//  Created by zcc on 16/3/4.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "ForgetViewController.h"

@implementation ForgetViewController
{
    UITextField *nameTF;
    UITextField *keywordNoTF;
    UITextField *newWordNoTF;
    UITextField *newsWordNoTF;
    NSString *code;
    TopView *topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIView *barView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    barView.backgroundColor=[UIColor blackColor];
//    [self.view addSubview:barView];
    [self initTopView];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"忘记密码";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
}
-(void)initUI
{
    UIImageView *bodyView=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topView.frame))];
    bodyView.backgroundColor=[UIColor whiteColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [bodyView addGestureRecognizer:tap];
    bodyView.userInteractionEnabled=YES;
    [self.view addSubview:bodyView];
    
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.4, SCREEN_HEIGHT*0.06, 80, 90)];
    imgview.image=[UIImage imageNamed:@"app_brand_icon"];
    [bodyView addSubview:imgview];
   
    // 用户名输入
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, CGRectGetMaxY(imgview.frame)+50,SCREEN_WIDTH*0.7, 40)];
    [nameTF setPlaceholder:@" 请输入手机号"];
    [nameTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    //    [nameTF addTarget:self action:@selector(returnResignKeyBoard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
    nameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
    nameTF.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    //nameTF.delegate = self;
    nameTF.textColor=[UIColor whiteColor];
    nameTF.layer.masksToBounds=YES;
    nameTF.layer.cornerRadius=3;
    nameTF.backgroundColor=[UIColor grayColor];
    [nameTF setFont:[UIFont systemFontOfSize:15]];
    [bodyView addSubview:nameTF];
    
    // 密码输入
    keywordNoTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, CGRectGetMaxY(nameTF.frame)+15, SCREEN_WIDTH*0.35, 40)];
    [keywordNoTF setPlaceholder:@" 请输入验证码"];
    keywordNoTF.secureTextEntry = YES;
    keywordNoTF.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
    [keywordNoTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    keywordNoTF.layer.masksToBounds=YES;
    keywordNoTF.layer.cornerRadius=3;
    keywordNoTF.textColor=[UIColor whiteColor];
    keywordNoTF.backgroundColor=[UIColor grayColor];
    
    keywordNoTF.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
    keywordNoTF.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    //keywordNoTF.delegate = self;
    [keywordNoTF setFont:[UIFont systemFontOfSize:15]];
    [bodyView addSubview:keywordNoTF];
    
    UIButton *lognA = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.55 ,CGRectGetMaxY(nameTF.frame)+15,SCREEN_WIDTH*0.3,40)];
    //    [lognB setBackgroundImage:[UIImage imageNamed:@"btn_big_n"] forState:UIControlStateNormal];
    lognA.backgroundColor = [UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
    lognA.layer.masksToBounds=YES;
    lognA.layer.cornerRadius=3;
    lognA.showsTouchWhenHighlighted = YES;
    [lognA setTitle:@"发送验证码" forState:UIControlStateNormal];
    [lognA.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [lognA addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:lognA];
    
    // 密码输入
    newWordNoTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, CGRectGetMaxY(lognA.frame)+15, SCREEN_WIDTH*0.7, 40)];
    [newWordNoTF setPlaceholder:@" 请输入新密码"];
    newWordNoTF.secureTextEntry = YES;
    newWordNoTF.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
    [newWordNoTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    newWordNoTF.layer.masksToBounds=YES;
    newWordNoTF.layer.cornerRadius=3;
    newWordNoTF.textColor=[UIColor whiteColor];
    newWordNoTF.backgroundColor=[UIColor orangeColor];
    newWordNoTF.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
    newWordNoTF.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    //keywordNoTF.delegate = self;
    [newWordNoTF setFont:[UIFont systemFontOfSize:15]];
    [bodyView addSubview:newWordNoTF];
    
    // 密码输入
    newsWordNoTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, CGRectGetMaxY(newWordNoTF.frame)+15, SCREEN_WIDTH*0.7, 40)];
    [newsWordNoTF setPlaceholder:@" 再次输入新密码"];
    newsWordNoTF.secureTextEntry = YES;
    newsWordNoTF.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
    [newsWordNoTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    newsWordNoTF.layer.masksToBounds=YES;
    newsWordNoTF.layer.cornerRadius=3;
    newsWordNoTF.textColor=[UIColor whiteColor];
    newsWordNoTF.backgroundColor=[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
    newsWordNoTF.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
    newsWordNoTF.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    //keywordNoTF.delegate = self;
    [newsWordNoTF setFont:[UIFont systemFontOfSize:15]];
    [bodyView addSubview:newsWordNoTF];
    
    UIButton *lognB = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.15 ,CGRectGetMaxY(newsWordNoTF.frame)+15,SCREEN_WIDTH*0.7,40)];
    //    [lognB setBackgroundImage:[UIImage imageNamed:@"btn_big_n"] forState:UIControlStateNormal];
    lognB.backgroundColor = [UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
    lognB.layer.masksToBounds=YES;
    lognB.layer.cornerRadius=3;
    lognB.showsTouchWhenHighlighted = YES;
    [lognB setTitle:@"提交确定" forState:UIControlStateNormal];
    [lognB.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [lognB addTarget:self action:@selector(clicksubitm) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:lognB];
    
    
}
-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)click
{
    [self.view endEditing:NO];
    if ([nameTF.text length]!=11||[[nameTF.text substringWithRange:NSMakeRange(0, 1)] integerValue]!=1)
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入正确手机号"];
        return;
    }
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",nameTF.text],@"phone",nil];
    [SVProgressHUD showWithStatus:@"发送中..." maskType:SVProgressHUDMaskTypeBlack];
    
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestPhoneCode" params:dicton success:^(NSDictionary *dict){
        [SVProgressHUD dismiss];
        @try
        {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                code=[[[dict objectForKey:@"result"] objectAtIndex:0] objectForKey:@"code"];
                [ToolControl showHudWithResult:NO andTip:@"注意查收短信"];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        [ToolControl hideHud];
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
}
-(void)clicksubitm
{
    if ([nameTF.text length]!=11||[[nameTF.text substringWithRange:NSMakeRange(0, 1)] integerValue]!=1)
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入正确手机号"];
        return;
    }if (keywordNoTF.text.length==0) {
        [ToolControl showHudWithResult:NO andTip:@"请输入验证码"];
        return;
    }
    if(newWordNoTF.text.length==0) {
        [ToolControl showHudWithResult:NO andTip:@"请输入新密码"];
        return;
    }
    if (newsWordNoTF.text.length==0)
    {
        [ToolControl showHudWithResult:NO andTip:@"请再次输入新密码"];
        return;
    }
    if (![newsWordNoTF.text isEqualToString:newWordNoTF.text])
    {
        [ToolControl showHudWithResult:NO andTip:@"新密码不一致"];
        return;
    }
    if (![code isEqualToString:keywordNoTF.text])
    {
        [ToolControl showHudWithResult:NO andTip:@"验证码错误"];
        return;
    }
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",nameTF.text],@"phone",[NSString stringWithFormat:@"%@",newWordNoTF.text],@"pwd",[NSString stringWithFormat:@"%@",newsWordNoTF.text],@"pwd1",nil];
   [SVProgressHUD showWithStatus:@"提交中..." maskType:SVProgressHUDMaskTypeBlack];

    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestResetpwd" params:dicton success:^(NSDictionary *dict){
        [SVProgressHUD dismiss];
        @try
        {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                [ToolControl showHudWithResult:NO andTip:@"操作成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        @catch (NSException *exception) {
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        }
        
        
    } failure:^(NSError *error) {
        [ToolControl hideHud];
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
