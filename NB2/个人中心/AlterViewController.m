//
//  AlterViewController.m
//  NB2
//
//  Created by zcc on 16/2/19.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "AlterViewController.h"
#import "LHDropDownControlView.h"
#import "ZHPickView.h"
#import "FristViewController.h"
#import "NavViewController.h"
@interface AlterViewController ()<ZHPickViewDelegate>
{
    TopView *topView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
    UIImageView *bodyView;
    LHDropDownControlView *mDropDownView;
    ZHPickView *_pickview;
    int type;
    UILabel *textlable;
}
@end

@implementation AlterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTopView];
    [self initUI];
    type=1;
    // Do any additional setup after loading the view.
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"修改密码";
    topView.delegate=self;
    topView.imgLeft=@"back_btn_n";
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
    NSArray *arraytitle=[[NSArray alloc] initWithObjects:@"会员账号:",@"交易密码类型:",@"旧密码:",@"新密码:",@"确认新密码", nil];
    //NSArray *arraytext=[[NSArray alloc] initWithObjects:@"N83607",@"张三",@"1355.4",@"189****2356", nil];
    for (int i=0; i<arraytitle.count; i++)
    {
        UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 38*(i+1)+5, SCREEN_WIDTH*0.28, 25)];
        labletitle.textAlignment=NSTextAlignmentRight;
        labletitle.textColor=[UIColor grayColor];
        labletitle.text=[arraytitle objectAtIndex:i];
        labletitle.adjustsFontSizeToFitWidth=YES;
        labletitle.font=[UIFont systemFontOfSize:15];
        [bodyView addSubview:labletitle];
        
        if (i==1)
        {
            [textlable removeFromSuperview];
            textlable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, 38*(i+1)+5, SCREEN_WIDTH*0.6, 25)];
            textlable.userInteractionEnabled=YES;
            textlable.text=@"登录密码";
            textlable.layer.masksToBounds=YES;
            textlable.layer.cornerRadius=3;
            textlable.textColor=[UIColor grayColor];
            textlable.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickchoose)];
            [textlable addGestureRecognizer:tap];
            //keywordNoTF.delegate = self;
            [textlable setFont:[UIFont systemFontOfSize:15]];
            
            [bodyView addSubview:textlable];
        }else
        {
            UITextField *text=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, 38*(i+1)+5, SCREEN_WIDTH*0.6, 25)];
            //[text setPlaceholder:[arraytext objectAtIndex:i]];
            //text.secureTextEntry = YES;
            if (i==0)
            {
                text.enabled=NO;
                text.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
            }
            text.tag=i+101;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
            [text setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            text.layer.masksToBounds=YES;
            text.layer.cornerRadius=3;
            text.textColor=[UIColor grayColor];
            text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
            
            text.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
            text.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
            //keywordNoTF.delegate = self;
            [text setFont:[UIFont systemFontOfSize:15]];
            [bodyView addSubview:text];
        
        }
        [bodyView bringSubviewToFront:mDropDownView];
        
        
    }
    
    UIButton *getbut=[UIButton buttonWithType:UIButtonTypeCustom];
    getbut.frame=CGRectMake(SCREEN_WIDTH*0.28+5, SCREEN_HEIGHT*0.4, SCREEN_WIDTH*0.6, 40);
    [getbut setBackgroundColor:[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1]];
    [getbut setTitle:@"提交保存" forState:UIControlStateNormal];
    [getbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getbut addTarget:self action:@selector(clickPresvers) forControlEvents:UIControlEventTouchUpInside];
    getbut.layer.masksToBounds=YES;
    getbut.layer.cornerRadius=3;
    [bodyView addSubview:getbut];
}
-(void)clickchoose
{
    [_pickview remove];
    NSArray *array=@[@"登录密码",@"二级密码"];
    _pickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
    _pickview.delegate=self;
    [_pickview show];

}
-(void)click
{
    [self.view endEditing:NO];
}
-(void)clickPresvers
{
    [self click];
    if (_pickview!=nil) {
        [_pickview remove];
    }
    UITextField *text=[bodyView viewWithTag:103];
    UITextField *text1=[bodyView viewWithTag:104];
    UITextField *text2=[bodyView viewWithTag:105];
    if ([text.text isEqualToString:@""]) {
        
        [ToolControl showBlockHudWithResult:NO andTip:@"请输入旧密码"];
        return;
    }if ([text1.text isEqualToString:@""]) {
        
        [ToolControl showBlockHudWithResult:NO andTip:@"请输入新密码"];
        return;
    }if ([text2.text isEqualToString:@""]) {
        
        [ToolControl showBlockHudWithResult:NO andTip:@"请输入确认密码"];
        return;
    }if (![text1.text isEqualToString:text2.text]) {
        
        [ToolControl showBlockHudWithResult:NO andTip:@"新密码不一致"];
        return;
    }
    
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",text.text,@"oldpwd",text1.text,@"pwd",[NSString stringWithFormat:@"%d",type],@"type",nil];
    [ToolControl showHudWithTip:@"修改中..."];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestEditpwd" params:dicton success:^(NSDictionary *dict){
        
        @try
        {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                if (type==1)
                {
                    NSDictionary *diction=[[NSDictionary alloc] init];
                    NSArray *array=[[NSArray alloc] initWithObjects:diction, nil];
                    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"result"];
                    FristViewController *loginCtrl = [[FristViewController alloc] init];
                    NavViewController *navCtrl = [[NavViewController alloc] initWithRootViewController:loginCtrl];
                    navCtrl.navigationBarHidden=YES;
                    self.view.window.rootViewController = navCtrl;
                    [ToolControl showHudWithResult:NO andTip:@"修改成功，请重新登录"];
                }else
                {
                    [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
                }
//                [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"result"] forKey:@"result"];
//                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"result"]);
//                TabViewController *tabview=[[TabViewController alloc] init];
//                [self.navigationController pushViewController:tabview animated:YES];
            }
        }
        @catch (NSException *exception) {
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        }
        @finally {
            
        }
        // [ToolControl hideHud];
        
    } failure:^(NSError *error) {
        [ToolControl hideHud];
        //[SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
     
}
-(void)clickTap
{
    [self.view endEditing:NO];
    if (_pickview!=nil) {
        [_pickview remove];
    }
}

-(void)actionLeft
{
    if (_pickview!=nil) {
        [_pickview remove];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - Drop Down Selector Delegate

- (void)dropDownControlViewWillBecomeActive:(LHDropDownControlView *)view  {
    //self.tableView.scrollEnabled = NO;
}
#pragma mark UsefulpickVIewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    if ([resultString isEqualToString:@"登录密码"])
    {
        type=1;
        textlable.text=@"登录密码";

    }else
    {
        type=2;
        textlable.text=@"二级密码";
    }
    
    
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
