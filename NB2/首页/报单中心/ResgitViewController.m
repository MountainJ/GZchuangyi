//
//  ResgitViewController.m
//  NB2
//
//  Created by zcc on 16/2/19.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "ResgitViewController.h"
#import "ZHPickView.h"
@interface ResgitViewController ()<ZHPickViewDelegate,UITextFieldDelegate>
{
    TopView *topView;
    UIScrollView *keyview;
    NSString *ipstring;
    NSString *profive;
    NSString *city;
    NSArray *arraytitle;
    int iske;
}
@property(nonatomic,strong)ZHPickView *pickview;
@end

@implementation ResgitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTopView];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"会员注册";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    topView.buttonRB=@"提交";
    [self.view addSubview:topView];
    [topView setTopView];
    
    //键盘view
    keyview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-topView.frame.origin.y-topView.frame.size.height)];
    keyview.contentSize=CGSizeMake(0,32*22);
    keyview.backgroundColor=[UIColor whiteColor];
    keyview.tag=101;
    [self.view addSubview:keyview];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ipstring=[HttpTool deviceIPAdress];
    if (keyBoardController==nil)
    {
        keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    }
    [keyBoardController addToolbarToKeyboard];
}
-(void)initUI
{
    arraytitle=[[NSArray alloc] initWithObjects:@"用户名:",@"登录密码:",@"确认登录密码:",@"二级密码:",@"确认二级密码:",@"推荐人账号:",@"姓名:",@"性别:",@"身份证:",@"手机号码:",@"银行类型:",@"开户行:",@"开户地址:",@"户名:",@"银行卡号:",@"地区",@"微信:",@"支付宝",@"QQ", nil];
    NSArray *liarray=[[NSArray alloc] initWithObjects:@"例如：张三",@"例如：男",@"例如：360***1993****60**",@"例如：183******52",@"例如：招商银行",@"例如：皇岗支行",@"例如：福田区金田路",@"例如：张三",@"例如：621955********1223",@"广东深圳",@"可选填",@"可选填",@"可选填",nil];
    for (int i=0; i<arraytitle.count; i++)
    {
        UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 32*(i+1), SCREEN_WIDTH*0.3, 25)];
        labletitle.textAlignment=NSTextAlignmentRight;
        labletitle.textColor=[UIColor grayColor];
        labletitle.text=[arraytitle objectAtIndex:i];
        labletitle.font=[UIFont systemFontOfSize:14];
        [keyview addSubview:labletitle];
        
        if(arraytitle.count-4==i)
        {
            UILabel *text=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, 32*(i+1), SCREEN_WIDTH*0.6, 25)];
            text.tag=102+i;
            //[text setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            text.textColor=[UIColor colorWithWhite:0.4 alpha:0.6];
            text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
            text.layer.masksToBounds=YES;
            text.layer.cornerRadius=3;
            [text setFont:[UIFont systemFontOfSize:14]];
            text.text=[liarray lastObject];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickchoose)];
            [text addGestureRecognizer:tap];
            text.userInteractionEnabled=YES;
            [keyview addSubview:text];
        
        }else
        {
            UITextField *text=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, 32*(i+1), SCREEN_WIDTH*0.6, 25)];
            if (i==9||i==arraytitle.count-2)
            {
                text.keyboardType=UIKeyboardTypeNumberPad;
            }
            text.tag=102+i;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
            [text setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            if (i>5) {
                text.placeholder=[liarray objectAtIndex:i-6];
            }
            if (self.type==1) {
                
            if (i==5) {
                text.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]  objectForKey:@"name"]];
                text.enabled=NO;
            }
            }
            if(i==6)
            {
                [text addTarget:self action:@selector(clicktian:) forControlEvents:UIControlEventEditingChanged];
            }
            text.layer.masksToBounds=YES;
            text.layer.cornerRadius=3;
            text.textColor=[UIColor grayColor];
            text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
            
            text.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
            text.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
            [text setFont:[UIFont systemFontOfSize:14]];
            if(i==0)
            {
                text.keyboardType=UIKeyboardTypeASCIICapable;
                [text addTarget:self action:@selector(clickchoose:) forControlEvents:UIControlEventEditingChanged];
                text.delegate=self;
            }
            [keyview addSubview:text];
        
        }
        
    }


    [self.view bringSubviewToFront:topView];
}
-(void)clickchoose:(UITextField *)text
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnoqprstuvwxyzABCDEFGHIJKLMNOQPRSTUVWXYZ1234567890"] invertedSet];
    
    NSString *filtered = [[text.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [text.text isEqualToString:filtered];
    if (canChange==NO) {
        text.text=filtered;
    }

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnoqprstuvwxyzABCDEFGHIJKLMNOQPRSTUVWXYZ1234567890"] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;

}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}
-(void)clicktian:(UITextField *)textfied
{
    UITextField *intput13=[keyview viewWithTag:115];
    intput13.text=textfied.text;
    intput13.enabled=NO;
}
-(void)actionRight
{
    iske=0;
    UITextField *intput0=[keyview viewWithTag:102];
    [intput0.text isEqualToString:@""];
    UITextField *intput4=[keyview viewWithTag:107];
    [intput4.text isEqualToString:@""];
    UITextField *intput9=[keyview viewWithTag:111];
    [intput9.text isEqualToString:@""];
    if(![intput0.text isEqualToString:@""])
    {
        [self yanzheng:@{@"title":intput0.text,@"type":@"1"}];
    }
    else
    {
        [ToolControl showHudWithResult:NO andTip:@"用户名不能为空"];
        return;
    }
    if(![intput4.text isEqualToString:@""])
    {
        [self yanzheng:@{@"title":intput4.text,@"type":@"2"}];
    }
    else
    {
        [ToolControl showHudWithResult:NO andTip:@"推荐人账号为空"];
        return;
    }
    if([intput9.text length]==11&&[[intput9.text substringWithRange:NSMakeRange(0, 1)] integerValue]==1)
    {
        [self yanzheng:@{@"title":intput9.text,@"type":@"1"}];
    }else
    {
        //[ToolControl showHudWithResult:NO andTip:@"请输入正确手机号"];
        return;
    }
    
}
-(void)yanzheng:(NSDictionary *)diction
{

    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestCheckuserinfo" params:diction success:^(NSDictionary *dict){
        @try
        {
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                iske++;
                if (iske>=3)
                {
                    [self clickPresver];
                }
                
            }else
            {
                [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
                return ;
            }
        }
        @catch (NSException *exception) {
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
            return ;
        }
        @finally {
            
        }
        // [ToolControl hideHud];
        
    } failure:^(NSError *error) {
        return ;
        [ToolControl hideHud];
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];

}
-(void)clickPresver
{
    UITextField *intput0=[keyview viewWithTag:102];
    UITextField *intput=[keyview viewWithTag:103];
    UITextField *intput1=[keyview viewWithTag:104];
    UITextField *intput2=[keyview viewWithTag:105];
    UITextField *intput3=[keyview viewWithTag:106];
    UITextField *intput4=[keyview viewWithTag:107];
    //UITextField *intput5=[keyview viewWithTag:108];
    UITextField *intput6=[keyview viewWithTag:108];
    UITextField *intput7=[keyview viewWithTag:109];
    UITextField *intput8=[keyview viewWithTag:110];
    UITextField *intput9=[keyview viewWithTag:111];
    UITextField *intput10=[keyview viewWithTag:112];
    UITextField *intput11=[keyview viewWithTag:113];
    UITextField *intput12=[keyview viewWithTag:114];
    UITextField *intput13=[keyview viewWithTag:115];
    UITextField *intput14=[keyview viewWithTag:116];
    UITextField *intput15=[keyview viewWithTag:117];
    UITextField *intput16=[keyview viewWithTag:118];
    UITextField *intput17=[keyview viewWithTag:119];
    UITextField *intput18=[keyview viewWithTag:120];

    if ([intput0.text isEqualToString:@""])
    {
        [ToolControl showHudWithResult:NO andTip:@"用户名不能为空"];
        return;
    }

    if (intput.text.length<6)
    {
        [ToolControl showHudWithResult:NO andTip:@"登录密码不能少于六位"];
        return;
    }
    if (intput1.text.length<6)
    {
        [ToolControl showHudWithResult:NO andTip:@"登录密码不能少于六位"];
        return;
    }
    if (![intput.text isEqualToString:intput1.text])
    {
        [ToolControl showHudWithResult:NO andTip:@"登录密码不一致"];
        return;
    }
    if (intput2.text.length<6)
    {
        [ToolControl showHudWithResult:NO andTip:@"二级密码不能少于六位"];
        return;
    }
    if (intput3.text.length<6)
    {
        [ToolControl showHudWithResult:NO andTip:@"二级密码不能少于六位"];
        return;
    }
    if (![intput2.text isEqualToString:intput3.text])
    {
        [ToolControl showHudWithResult:NO andTip:@"二级密码不一致"];
        return;
    }
    if ([intput4.text isEqualToString:@""])
    {
        [ToolControl showHudWithResult:NO andTip:@"推荐人账号为空！"];
        return;
    }
    
    if ([intput6.text isEqualToString:@""])
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入姓名"];
        return;
    }
    if ([intput7.text isEqualToString:@""])
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入性别"];
        return;
    }
    if ([intput8.text isEqualToString:@""])
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入身份证号"];
        return;
    }
    if ([intput9.text length]!=11||[[intput9.text substringWithRange:NSMakeRange(0, 1)] integerValue]!=1)
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入正确手机号"];
        return;
    }
    if (![ConvertValue validateIdentityCard:intput8.text])
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入正确的身份证号"];
        return;
    }
    if ([intput10.text isEqualToString:@""])
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入银行类型"];
        return;
    }
    if ([intput11.text isEqualToString:@""])
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入开户行"];
        return;
    }
    if ([intput12.text isEqualToString:@""])
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入开户地址"];
        return;
    }
    if ([intput13.text isEqualToString:@""])
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入户名"];
        return;
    }
    if ([intput14.text isEqualToString:@""])
    {
        [ToolControl showHudWithResult:NO andTip:@"请输入银行卡号"];
        return;
    }
    if (profive==nil||[profive isEqualToString:@""]) {
        [ToolControl showHudWithResult:NO andTip:@"请选择地区"];
        return;
    }
    
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",intput0.text],@"user",intput.text,@"pwd",ipstring,@"ip",intput2.text,@"erpwd",intput4.text,@"tuijian",intput6.text,@"name",intput7.text,@"sex",intput8.text,@"cardnum",intput9.text,@"phone",intput10.text,@"bankname",intput11.text,@"kaihuhang",intput12.text,@"kaihudizhi",intput13.text,@"huming",intput14.text,@"banknum",profive,@"sheng",city,@"shi",intput16.text,@"weixin",intput17.text,@"alipay",intput18.text,@"qq",nil];
    [SVProgressHUD showWithStatus:@"提交中..." maskType:SVProgressHUDMaskTypeBlack];
    
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestReg" params:dicton success:^(NSDictionary *dict){
        
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
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
-(void)clickchoose
{
    [_pickview remove];
    _pickview=[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
    
    _pickview.delegate=self;
    
    [_pickview show];

}
#pragma mark ZhpickVIewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    NSLog(@"%@",resultString);
    UITextField *intput15=[keyview viewWithTag:117];
    NSRange range=[resultString rangeOfString:@"|"];
    profive =[resultString substringToIndex:range.location];
    if ([profive isEqualToString:@"北京"]||[profive isEqualToString:@"上海"]||[profive isEqualToString:@"天津"]||[profive isEqualToString:@"重庆"]) {
        city=profive;
        intput15.text=[NSString stringWithFormat:@"%@",profive];
    }else
    {
        city =[resultString substringWithRange:NSMakeRange(range.location+1, resultString.length-profive.length-1)];
        UITextField *intput15=[keyview viewWithTag:117];
        intput15.text=[NSString stringWithFormat:@"%@%@",profive,city];
    
    }
    
}
-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_pickview!=nil)
    {
        [_pickview remove];
    }
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
