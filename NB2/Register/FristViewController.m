//
//  FristViewController.m
//  NB2
//
//  Created by zcc on 16/2/17.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "FristViewController.h"
#import "OneViewController.h"
#import "FristViewController.h"
#import "TabViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"


#define LINE_COLOR  [[UIColor lightGrayColor] colorWithAlphaComponent:0.5]

@interface FristViewController ()
{
    UITextField *nameTF;
    UITextField *keywordNoTF;
    NSString *string;
    NSString *ipStr;
}

@end

@implementation FristViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *barView=[[UIView alloc] initWithFrame:CGRectMake(0, JF_TOP_ACTIVE_SPACE, SCREEN_WIDTH, 20 + JF_TOP_ACTIVE_SPACE)];
    barView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:barView];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    string=[HttpTool deviceIPAdress];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self getIpRequest];
}
-(void)initUI
{
    UIImageView *bodyView=[[UIImageView alloc] initWithFrame:CGRectMake(0, APP_STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - APP_STATUS_BAR_HEIGHT)];
    bodyView.backgroundColor=[UIColor whiteColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [bodyView addGestureRecognizer:tap];
    bodyView.userInteractionEnabled=YES;
    [self.view addSubview:bodyView];
    
    CGFloat iconWidth = 100.;
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5 - iconWidth *0.5, SCREEN_HEIGHT*0.16, iconWidth, iconWidth)];
    imgview.image=[UIImage imageNamed:@"logo"];
    [bodyView addSubview:imgview];
    
    // 用户名输入
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, CGRectGetMaxY(imgview.frame)+SCREEN_HEIGHT/12.0,SCREEN_WIDTH*0.7, 40)];
    [nameTF setPlaceholder:@" 请输入账号"];
    [self changeLayerCornerLeftImg:nameTF leftImgName:@"user"];
    [bodyView addSubview:nameTF];
    // 密码输入
    keywordNoTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, CGRectGetMaxY(nameTF.frame)+20, SCREEN_WIDTH*0.7, 40)];
    [keywordNoTF setPlaceholder:@" 请输入密码"];
    keywordNoTF.secureTextEntry = YES;
    [self changeLayerCornerLeftImg:keywordNoTF leftImgName:@"Password"];
    [bodyView addSubview:keywordNoTF];
    
    
    CGFloat rigeWidth = KKFitScreen(160);
    UIButton *rsgister=[UIButton buttonWithType:UIButtonTypeCustom];
    rsgister.frame=CGRectMake(CGRectGetMaxX(keywordNoTF.frame)-rigeWidth,CGRectGetMaxY(keywordNoTF.frame) + KKFitScreen(10.) , rigeWidth, 40);
    [rsgister setTitle:@"快速注册" forState:UIControlStateNormal];
    [rsgister.titleLabel setFont:[UIFont systemFontOfSize:16.]];
    [rsgister setTitleColor:[UIColor colorWithRed:41./255 green:153.0/255 blue:251.0/255 alpha:1] forState:UIControlStateNormal];
    [rsgister addTarget:self action:@selector(clickRsgister) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:rsgister];
    
    
    
    UIButton *lognB = [UIButton buttonWithType:UIButtonTypeCustom];
    lognB.frame = CGRectMake(CGRectGetMinX(keywordNoTF.frame) ,CGRectGetMaxY(rsgister.frame)+KKFitScreen(30.),CGRectGetWidth(keywordNoTF.frame),40.);
    lognB.backgroundColor = [UIColor colorWithRed:38./255 green:150.0/255 blue:251.0/255 alpha:1];
    lognB.layer.masksToBounds=YES;
    lognB.layer.cornerRadius = 5.;
    lognB.showsTouchWhenHighlighted = YES;
    [lognB setTitle:@"登录" forState:UIControlStateNormal];
    [lognB.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [lognB addTarget:self action:@selector(logn) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:lognB];
    
}

- (void)changeLayerCornerLeftImg:(UITextField *)textField leftImgName:(NSString *)imgName
{
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
    textField.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button

    textField.textColor=[UIColor darkTextColor];
    [textField setFont:[UIFont systemFontOfSize:15]];

    textField.backgroundColor= [UIColor whiteColor];
    [textField setValue:LINE_COLOR forKeyPath:@"_placeholderLabel.textColor"];

    textField.layer.cornerRadius = 6.f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 1.f;
    textField.layer.borderColor =LINE_COLOR.CGColor;
    CGFloat margin = 10.;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40., 20.)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 0, backView.frame.size.width - 2*margin, backView.frame.size.height)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = [UIImage imageNamed:imgName];
    [backView addSubview:imgView];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = backView;
}


-(void)clickRsgister
{
    RegisterViewController *resgiter=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:resgiter animated:YES];

}


-(void)clickForget
{
    ForgetViewController *resgiter=[[ForgetViewController alloc] init];
    [self.navigationController pushViewController:resgiter animated:YES];
}
-(void)click
{
    [self.view endEditing:NO];
}
-(void)logn
{
    [self click];
    if ([nameTF.text isEqualToString:@""]) {
        
        [ToolControl showBlockHudWithResult:NO andTip:@"请输入用户名"];
        return;
    }
    if ([keywordNoTF.text isEqualToString:@""]) {
        
        [ToolControl showBlockHudWithResult:NO andTip:@"请输入密码"];
        return;
    }
    if (ipStr == nil || [ipStr isEqualToString:@""]) {
        if (string==nil||[string isEqualToString:@""]) {
            string=@"14.20.99.242";
        }
    }else
    {
        string = ipStr;
    }
    
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",nameTF.text],@"user",[NSString stringWithFormat:@"%@",keywordNoTF.text],@"pwd",string,@"ip",@"2",@"type",nil];
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];

    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestUserLogin" params:dicton success:^(NSDictionary *dict){
        
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"result"] forKey:@"result"];
                NSString *user=[[[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectAtIndex:0] objectForKey:@"user"];
                if (user==nil) {
                    user=[[[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectAtIndex:0] objectForKey:@"id"];
                }
                [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
                [[NSUserDefaults standardUserDefaults]  setObject:nameTF.text forKey:@"name"];
                TabViewController *tabview=[[TabViewController alloc] init];
                [self.navigationController pushViewController:tabview animated:YES];
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

- (void)getIpRequest
{
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestIp" params:nil success:^(NSDictionary *dict){
        
        @try
        {
            
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                NSArray *arr = [dict objectForKey:@"result"];
                NSDictionary *dic = [arr objectAtIndex:0];
                ipStr = [dic objectForKey:@"ip"];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        // [ToolControl hideHud];
        
    } failure:^(NSError *error) {
        
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
