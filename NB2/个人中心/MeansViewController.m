//
//  MeansViewController.m
//  NB2
//
//  Created by zcc on 16/2/19.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "MeansViewController.h"

@interface MeansViewController ()
{
    TopView *topView;
    UITableView *workTableView;
    UIView *keyview;
    UIView *keyview1;
    UIView *keyview2;
    NSDictionary *dictionData;
    NSMutableArray *arrayData;
}
@end

@implementation MeansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    arrayData=[[NSMutableArray alloc] init];
    [self initTopView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
    if (keyBoardController==nil)
    {
        keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    }
    [keyBoardController addToolbarToKeyboard];
}
-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",nil];
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
    
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestUserinfo" params:dicton success:^(NSDictionary *dict){
        
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                dictionData=[[dict objectForKey:@"result"] objectAtIndex:0];
                [arrayData addObject:SAFE_STRING([dictionData objectForKey:@"user"])];
                [arrayData addObject:SAFE_STRING([dictionData objectForKey:@"name"])];
                [arrayData addObject:SAFE_STRING([dictionData objectForKey:@"sex"])];
                [arrayData addObject:SAFE_STRING([dictionData objectForKey:@"shijian"])];
                [arrayData addObject:SAFE_STRING([dictionData objectForKey:@"lasttime"])];
                [arrayData addObject:SAFE_STRING([dictionData objectForKey:@"jibie"])];
                [arrayData addObject:SAFE_STRING([dictionData objectForKey:@"tuijian"])];
                [self initUI:300];
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
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"资料管理";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    //topView.buttonRB=@"联系消息";
    [self.view addSubview:topView];
    [topView setTopView];
    
    NSArray *arraycolcor=[[NSArray alloc] initWithObjects:@"会员信息",@"会员业绩",@"账户信息", nil];
    for (int i=0; i<arraycolcor.count; i++)
    {
        UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
        but.frame=CGRectMake(SCREEN_WIDTH/3.0*i, CGRectGetMaxY(topView.frame), SCREEN_WIDTH/3.0, 40);
        but.titleLabel.font=[UIFont systemFontOfSize:14];

        but.tag=300+i;
        if (i==0)
        {
            but.selected=YES;
            [but setBackgroundImage:[UIImage imageNamed:@"frist"] forState:UIControlStateSelected];
            [but setBackgroundImage:[UIImage imageNamed:@"butnooselectgreen"] forState:UIControlStateNormal];
        }else if(i==1)
        {
            [but setBackgroundImage:[UIImage imageNamed:@"two"] forState:UIControlStateSelected];
            [but setBackgroundImage:[UIImage imageNamed:@"butnooselect"] forState:UIControlStateNormal];
        }else
        {
            [but setBackgroundImage:[UIImage imageNamed:@"three"] forState:UIControlStateSelected];
            [but setBackgroundImage:[UIImage imageNamed:@"butnooselectbule"] forState:UIControlStateNormal];

        }
        
        [but setTitle:[arraycolcor objectAtIndex:i] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
        
    }
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)clickTag:(UIButton*)sender
{
    [self initUI:sender.tag];
    if (sender.tag==300) {
        sender.selected=YES;
        UIButton *but1=[self.view viewWithTag:301];
        UIButton *but2=[self.view viewWithTag:302];
        but1.selected=NO;
        but2.selected=NO;
    }else if(sender.tag==301)
    {
        sender.selected=YES;
        UIButton *but1=[self.view viewWithTag:300];
        UIButton *but2=[self.view viewWithTag:302];
        but1.selected=NO;
        but2.selected=NO;
    }else
    {
        sender.selected=YES;
        UIButton *but1=[self.view viewWithTag:300];
        UIButton *but2=[self.view viewWithTag:301];
        but1.selected=NO;
        but2.selected=NO;
    }
    
}

-(void)initUIFrist
{
    //键盘view
    keyview=[[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height+40, SCREEN_WIDTH, SCREEN_HEIGHT-topView.frame.size.height-40)];
    keyview.backgroundColor=[UIColor whiteColor];
    keyview.tag=101;
    [self.view addSubview:keyview];
    [self.view sendSubviewToBack:keyview];
    
//    NSArray *arraytitle=[[NSArray alloc] initWithObjects:@"会员账号:",@"姓名:",@"性别:",@"注册时间",@"最后登录时间",@"会员级别",@"推荐人编号",@"服务中心编号",nil];
    NSArray *arraytitle=[[NSArray alloc] initWithObjects:@"会员账号:",@"姓名:",@"性别:",@"注册时间",@"最后登录时间",@"会员级别",@"推荐人编号",nil];

    for (int i=0; i<arraytitle.count; i++)
    {
        UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 35*(i+1), SCREEN_WIDTH*0.28, 25)];
        labletitle.textAlignment=NSTextAlignmentRight;
        labletitle.textColor=[UIColor grayColor];
        labletitle.text=[arraytitle objectAtIndex:i];
        labletitle.font=[UIFont systemFontOfSize:15];
        [keyview addSubview:labletitle];
        
        UITextField *text=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, 35*(i+1), SCREEN_WIDTH*0.6, 25)];
        //[text setPlaceholder:[arraytext objectAtIndex:i]];
        text.tag=210+i;
        text.enabled=NO;
        text.returnKeyType=UIReturnKeyDone;
        text.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
        text.text=[arrayData objectAtIndex:i];
        text.layer.masksToBounds=YES;
        text.layer.cornerRadius=3;
        text.textColor=[UIColor grayColor];
        text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
        
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
        text.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
        text.delegate = self;
        [text setFont:[UIFont systemFontOfSize:15]];
        [keyview addSubview:text];
    }

}
-(void)initUI:(NSInteger)sign
{
    if (sign==300)
    {
        keyview1.hidden=YES;
        keyview2.hidden=YES;
        if (keyview==nil) {
            [self initUIFrist];
        }else
        {
            keyview.hidden=NO;
            
        }
        
        
    }else if(sign==301)
    {
        //keyview.hidden=YES;
        keyview.hidden=YES;
        keyview2.hidden=YES;
        if (keyview1==nil)
        {
            [self initUITwo];
        }else
        {
            keyview1.hidden=NO;
        }
        
    }else
    {
        keyview.hidden=YES;
        keyview1.hidden=YES;
        if (keyview2==nil)
        {
            [self initUIThree];
        }else
        {
            keyview2.hidden=NO;
        }
        
    }

}
-(void)initUITwo
{
    //键盘view
    keyview1=[[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height+40, SCREEN_WIDTH, SCREEN_HEIGHT-topView.frame.size.height-40)];
    keyview1.backgroundColor=[UIColor whiteColor];
    keyview1.tag=101;
    [self.view addSubview:keyview1];
    [self.view sendSubviewToBack:keyview1];
    
    NSArray *arraytitle=[[NSArray alloc] initWithObjects:@"推荐人数:",@"可用额度:",nil];
    for (int i=0; i<arraytitle.count; i++)
    {
        UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 35*(i+1), SCREEN_WIDTH*0.28, 25)];
        labletitle.textAlignment=NSTextAlignmentRight;
        labletitle.textColor=[UIColor grayColor];
        labletitle.text=[arraytitle objectAtIndex:i];
        labletitle.font=[UIFont systemFontOfSize:15];
        [keyview1 addSubview:labletitle];
        
        UITextField *text=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, 35*(i+1), SCREEN_WIDTH*0.6, 25)];
        //[text setPlaceholder:[arraytext objectAtIndex:i]];
        text.tag=210+i;
        text.enabled=NO;
        text.returnKeyType=UIReturnKeyDone;
        text.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
        if (i==0) {
            text.text=[dictionData objectForKey:@"tuijiannum"];
        }else
        {
            text.text=[dictionData objectForKey:@"qingqiuedu"];
        }
        
        text.layer.masksToBounds=YES;
        text.layer.cornerRadius=3;
        text.textColor=[UIColor grayColor];
        text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
        
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
        text.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
        text.delegate = self;
        [text setFont:[UIFont systemFontOfSize:15]];
        [keyview1 addSubview:text];
    }


}
-(void)initUIThree
{
    //键盘view
    keyview2=[[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height+40, SCREEN_WIDTH, SCREEN_HEIGHT-topView.frame.size.height-40)];
    keyview2.backgroundColor=[UIColor whiteColor];
    keyview2.tag=101;
    [self.view addSubview:keyview2];
    [self.view sendSubviewToBack:keyview2];
    
    NSArray *arraytitle=[[NSArray alloc] initWithObjects:@"银行名称",@"开户行",@"开户行地址:",@"银行户名",@"银行账号",@"微信号",@"支付宝",@"qq",nil];
    NSArray *arraytext=[[NSArray alloc] initWithObjects:[dictionData objectForKey:@"bankname"],[dictionData objectForKey:@"kaihuhang"],[dictionData objectForKey:@"kaihudizhi"],[dictionData objectForKey:@"huming"],[dictionData objectForKey:@"banknum"],[dictionData objectForKey:@"weixin"],[dictionData objectForKey:@"alipay"],[dictionData objectForKey:@"qq"],nil];
   // NSArray *liarray=[[NSArray alloc] initWithObjects:@"例如：招商银行",@"例如：皇岗支行",@"例如：福田区金田路",@"例如：张三",@"例如：621955********1223",@"可选填",@"可选填",@"可选填",nil];
    for (int i=0; i<arraytitle.count; i++)
    {
        UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 35*(i+1), SCREEN_WIDTH*0.3, 25)];
        labletitle.textAlignment=NSTextAlignmentRight;
        labletitle.textColor=[UIColor grayColor];
        labletitle.text=[arraytitle objectAtIndex:i];
        labletitle.adjustsFontSizeToFitWidth=YES;
        labletitle.font=[UIFont systemFontOfSize:14];
        [keyview2 addSubview:labletitle];
        
        UITextField *text=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, 35*(i+1), SCREEN_WIDTH*0.6, 25)];
        //[text setPlaceholder:[liarray objectAtIndex:i]];
        text.tag=210+i;
        text.returnKeyType=UIReturnKeyDone;
        text.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
        text.text=[arraytext objectAtIndex:i];
        text.layer.masksToBounds=YES;
        text.layer.cornerRadius=3;
        text.enabled=NO;
        text.textColor=[UIColor grayColor];
        text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
        
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
        text.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
        text.delegate = self;
        [text setFont:[UIFont systemFontOfSize:15]];
        [keyview2 addSubview:text];
    }

    UIButton *getbut=[UIButton buttonWithType:UIButtonTypeCustom];
    getbut.frame=CGRectMake(SCREEN_WIDTH*0.2, SCREEN_HEIGHT*0.53, SCREEN_WIDTH*0.6, 40);
    [getbut setBackgroundColor:[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1]];
    [getbut setTitle:@"提交保存" forState:UIControlStateNormal];
    [getbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getbut addTarget:self action:@selector(clickChange) forControlEvents:UIControlEventTouchUpInside];
    getbut.layer.masksToBounds=YES;
    getbut.layer.cornerRadius=3;
    //[keyview2 addSubview:getbut];
    [self.view bringSubviewToFront:keyview2];

}
-(void)clickChange
{
    UITextField *textfied=[keyview2 viewWithTag:210];
    UITextField *textfied1=[keyview2 viewWithTag:211];
    UITextField *textfied2=[keyview2 viewWithTag:212];
    UITextField *textfied3=[keyview2 viewWithTag:213];
    UITextField *textfied4=[keyview2 viewWithTag:214];
    UITextField *textfied5=[keyview2 viewWithTag:215];
    UITextField *textfied6=[keyview2 viewWithTag:216];
    UITextField *textfied7=[keyview2 viewWithTag:217];
    if (textfied.text.length==0)
    {
        [ToolControl showHudWithResult:NO andTip:@"银行名称不能为空"];
        return;
    }if (textfied1.text.length==0) {
        [ToolControl showHudWithResult:NO andTip:@"开户行不能为空"];
        return;
    }
    if (textfied2.text.length==0) {
        [ToolControl showHudWithResult:NO andTip:@"开户行地址不能为空"];
        return;
    }
    if (textfied3.text.length==0) {
        [ToolControl showHudWithResult:NO andTip:@"银行户名不能为空"];
        return;
    }
    if (textfied4.text.length==0) {
        [ToolControl showHudWithResult:NO andTip:@"银行账号不能为空"];
        return;
    }
    
    
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",textfied.text,@"bankname",textfied1.text,@"kaihuhang",textfied2.text,@"kaihudizhi",textfied3.text,@"huming",textfied4.text,@"banknum",textfied5.text,@"weixin",textfied6.text,@"alipay",textfied7.text,@"qq",nil];
    [SVProgressHUD showWithStatus:@"提交中..." maskType:SVProgressHUDMaskTypeBlack];

    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestEdituserinfo" params:dicton success:^(NSDictionary *dict){
        
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                [self.navigationController popViewControllerAnimated:YES];
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
-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)actionRight
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
