//
//  NoAgreeViewController.m
//  NB2
//
//  Created by zcc on 16/4/27.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "NoAgreeViewController.h"

@interface NoAgreeViewController ()
{
    TopView *topView;
    long sign;
    UITextView *textfied;

}

@end

@implementation NoAgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sign=3;
    self.view.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    [self initTopView];
    [self initUI];
    //[self initData];
    
    // Do any additional setup after loading the view.
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"拒绝付款";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
}
-(void)initUI
{
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(topView.frame)+20, SCREEN_WIDTH*0.5,20 )];
    lable.text=@"拒绝理由：";
    lable.font=[UIFont systemFontOfSize:13];
    lable.textColor=[UIColor grayColor];
    [self.view addSubview:lable];
    
    RadioButton *rb1 = [[RadioButton alloc] initWithGroupId:@"first group" index:0];
    RadioButton *rb2 = [[RadioButton alloc] initWithGroupId:@"first group" index:1];

    
    rb1.frame = CGRectMake(10,CGRectGetMaxY(lable.frame)+5,22,22);
    rb2.frame = CGRectMake(10,CGRectGetMaxY(rb1.frame),22,22);

    
    [self.view addSubview:rb1];
    [self.view addSubview:rb2];
    
    UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(lable.frame)+5, 100, 20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font=[UIFont systemFontOfSize:13];
    label1.text = @"无理由拒绝协助";
    [self.view addSubview:label1];
    
    UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(label1.frame)+5, 100, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"其他原因";
    label2.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label2];
    
    textfied=[[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label2.frame)+10, SCREEN_WIDTH-30, 60)];
    textfied.layer.borderWidth=1;
    textfied.layer.borderColor=[UIColor grayColor].CGColor;
    textfied.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:textfied];
    
    UITextView *textview=[[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(textfied.frame)+5, SCREEN_WIDTH-30, 70)];
    textview.textColor=[UIColor redColor];
    textview.font=[UIFont systemFontOfSize:12];
    textview.editable=NO;
    textview.text=@"备注：\n当选择第一选项后，系统将自动封号，取消您的会员资格。\n当牛选择第二个选项时，请陈述具体原因，提交后台审核确认。\n拒绝协助一个月内只能使用一次，请慎重选择使用！";
    textview.scrollEnabled=NO;
    [self.view addSubview:textview];
    
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    but.backgroundColor=[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
    but.frame=CGRectMake(15, CGRectGetMaxY(textview.frame)+5, SCREEN_WIDTH-30, 30);
    [but setTitle:@"提交保存" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clicksubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    

}
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    NSLog(@"changed to %lu in %@",(unsigned long)index,groupId);
    sign=index;
}
-(void)clicksubmit
{
    if(sign==1)
    {
        if (textfied.text.length==0)
        {
            [SVProgressHUD showErrorWithStatus:@"请陈述原因" duration:1.5];
            return;
            
        }

    }
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%@",self.tid],@"tid",textfied.text,@"beizhu",nil];
    
    [SVProgressHUD showWithStatus:@"请求中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestJujuefukuan" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
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
