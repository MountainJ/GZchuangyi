//
//  ServeControlViewController.m
//  NB2
//
//  Created by zcc on 16/2/20.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "ServeControlViewController.h"

@interface ServeControlViewController ()
{
    TopView *topView;
    UIImageView *bodyView;
}
@end

@implementation ServeControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTopView];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"申请服务中心";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
}
-(void)initUI
{
    //主view
    bodyView=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topView.frame))];
    bodyView.backgroundColor=[UIColor whiteColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
    [bodyView addGestureRecognizer:tap];
    bodyView.userInteractionEnabled=YES;
    [self.view addSubview:bodyView];
    NSArray *arraytitle=[[NSArray alloc] initWithObjects:@"会员账号:",@"姓名:",@"联系电话:", nil];
    NSArray *arraytext=[[NSArray alloc] initWithObjects:@"例如：N83607",@"例如：张三",@"例如：189****2356", nil];
    for (int i=0; i<3; i++)
    {
        UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 40*(i+1)+15, SCREEN_WIDTH*0.28, 30)];
        labletitle.textAlignment=NSTextAlignmentRight;
        labletitle.textColor=[UIColor grayColor];
        labletitle.text=[arraytitle objectAtIndex:i];
        labletitle.font=[UIFont systemFontOfSize:15];
        [bodyView addSubview:labletitle];
        
        UITextField *text=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, 40*(i+1)+15, SCREEN_WIDTH*0.6, 30)];
        [text setPlaceholder:[arraytext objectAtIndex:i]];
        text.secureTextEntry = YES;
        text.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
        [text setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        text.layer.masksToBounds=YES;
        text.layer.cornerRadius=3;
        text.textColor=[UIColor grayColor];
        text.tag=300+i;
        text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
        
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
        text.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
        //keywordNoTF.delegate = self;
        [text setFont:[UIFont systemFontOfSize:15]];
        [bodyView addSubview:text];
    }
    
    UIButton *getbut=[UIButton buttonWithType:UIButtonTypeCustom];
    getbut.frame=CGRectMake(SCREEN_WIDTH*0.2, SCREEN_HEIGHT*0.35, SCREEN_WIDTH*0.6, 40);
    [getbut setBackgroundColor:[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1]];
    [getbut setTitle:@"提交申请" forState:UIControlStateNormal];
    [getbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getbut addTarget:self action:@selector(clicksumbit) forControlEvents:UIControlEventTouchUpInside];
    getbut.layer.masksToBounds=YES;
    getbut.layer.cornerRadius=3;
    [bodyView addSubview:getbut];
}
-(void)clicksumbit
{
    UITextField *textfied=[bodyView viewWithTag:300];
    UITextField *textfied1=[bodyView viewWithTag:301];
    UITextField *textfied2=[bodyView viewWithTag:302];
    if (textfied.text.length==0) {
        [ToolControl showHudWithResult:NO andTip:@"请输入您的账号"];
        return;
    }
    if (textfied1.text.length==0) {
        [ToolControl showHudWithResult:NO andTip:@"请输入您的姓名"];
        return;
    }
    if (textfied2.text.length==0) {
       [ToolControl showHudWithResult:NO andTip:@"请输入您的账手机号"];
        return;
    }
    if (textfied2.text.length!=11||[[textfied2.text substringWithRange:NSMakeRange(0, 1)] integerValue]!=1 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号" duration:1.5];
        return;
    }

    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",nil];
    
    [SVProgressHUD showWithStatus:@"申请中" maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestShenqingfuwu" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            NSLog(@"%@",dict);
        }
        @catch (NSException *exception)
        {
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
    

}
-(void)clickTap
{
    [self.view endEditing:NO];
}
-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
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
