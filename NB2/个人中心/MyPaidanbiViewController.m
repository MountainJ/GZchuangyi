//
//  MyPaidanbiViewController.m
//  NB2
//
//  Created by zcc on 2017/3/12.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "MyPaidanbiViewController.h"
#import "PaidanRecordViewController.h"
#import "ToolBarButton.h"
#import "RegistPickerView.h"

@interface MyPaidanbiViewController ()<ToolBarButtonDelegate>
{
    TopView *topView;
    NSMutableArray *arrayData;
    UIAlertView *customAlertView;
    UIButton *getbut;
    UITextField *numTextFld;
    UITextField *yinbinumTextFld;
    UITextField *userTextFld;
    UITextField *totalNumFld;
    UITextField *pwdFld;
    UITextField *_cardFeild;

}

@property (nonatomic, strong) ToolBarButton *cycleBtn;
@property (nonatomic, strong) RegistPickerView *cyclePickerView;
@property (nonatomic, strong) UILabel       *cycleLbl;

@end

@implementation MyPaidanbiViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
//    [self initTopView];
    arrayData=[[NSMutableArray alloc] init];
    [self initTopView];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
    
}

- (ToolBarButton *)cycleBtn
{
    if (!_cycleBtn)
    {
        _cycleBtn = [[ToolBarButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _cycleBtn.delegate = self;
        _cycleBtn.inputView = self.cyclePickerView;
        _cycleBtn.layer.masksToBounds=YES;
        _cycleBtn.layer.cornerRadius=3;
        [_cycleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _cycleBtn.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
        _cycleBtn.tag = 0;
    }
    return _cycleBtn;
}

- (RegistPickerView *)cyclePickerView
{
    if (!_cyclePickerView)
    {
        _cyclePickerView = [[RegistPickerView alloc] initWithItem:@[@"创益金币",@"创益银币"]];
    }
    return _cyclePickerView;
}
- (UILabel *)cycleLbl
{
    if (!_cycleLbl)
    {
        _cycleLbl = [[UILabel alloc] init];
        _cycleLbl.textColor = [UIColor grayColor];
        _cycleLbl.font = [UIFont systemFontOfSize:14];
        _cycleLbl.layer.masksToBounds=YES;
        _cycleLbl.layer.cornerRadius=3;
        _cycleLbl.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
        _cycleLbl.text = @"创益金币";
        [_cycleLbl setFont:[UIFont systemFontOfSize:14]];
    }
    return _cycleLbl;
}


-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",nil];
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
    
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestUserinfo" params:dicton success:^(NSDictionary *dict){
        
        @try
        {
            [SVProgressHUD dismiss];
//            [ToolControl showHudWithResult:NO andTip:@""];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                NSDictionary *dictionData=[[dict objectForKey:@"result"] objectAtIndex:0];
                numTextFld.text = dictionData[@"chuangyebi"];
//                yinbinumTextFld.text = dictionData[@"yinbi"];
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
    topView.titileTx=@"创业币转让";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];

    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(SCREEN_WIDTH-70, 35+JF_TOP_ACTIVE_SPACE, 70, 20)];
    [button2 setBackgroundColor:[UIColor clearColor]];
    [button2 setTitle:@"记录查询" forState:UIControlStateNormal];
    button2.titleLabel.font=[UIFont systemFontOfSize:14];
    [button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
//    NSArray *arraytitle=@[@{@"title":@"创益金币总数：",@"placeHolder":@""},
//                          @{@"title":@"创益银币总数：",@"placeHolder":@""},
//                          @{@"title":@"转让会员账号：",@"placeHolder":@"请输入账号或手机号"},
//                          @{@"title":@"数量：",@"placeHolder":@"请输入转让数量"},
//                          @{@"title":@"二级密码：",@"placeHolder":@"请输入二级密码"},
//                          @{@"title":@"身份证号码：",@"placeHolder":@"请输入身份证最后6位"},
//                          @{@"title":@"转让类型：",@"placeHolder":@"请输入二级密码"}
//                        ];
    NSArray *arraytitle=@[@{@"title":@"创业币数量：",@"placeHolder":@""},
                          @{@"title":@"帐号或手机号：",@"placeHolder":@"请输入账号或手机号"},
                          @{@"title":@"转让数量：",@"placeHolder":@"请输入转让数量"},
                          @{@"title":@"二级密码：",@"placeHolder":@"请输入二级密码"},
                          ];
    
    CGFloat originY = 60;
    for (int i=0; i<arraytitle.count; i++)
    {
        NSDictionary *dic = arraytitle[i];
        UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, originY + 40*(i+1)+5, SCREEN_WIDTH*0.3, 30)];
        labletitle.textAlignment=NSTextAlignmentRight;
        labletitle.textColor=[UIColor grayColor];
        labletitle.text=dic[@"title"];
        labletitle.adjustsFontSizeToFitWidth=YES;
        labletitle.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:labletitle];
        
        if (i == 0) {
            numTextFld=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY + 40*(i+1)+5, SCREEN_WIDTH*0.6, 30)];
            numTextFld.enabled = NO;
            [self setTextFld:numTextFld];
        }
//        else if (i == 1) {
//            yinbinumTextFld=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY + 40*(i+1)+5, SCREEN_WIDTH*0.6, 30)];
//            yinbinumTextFld.enabled = NO;
//            [self setTextFld:yinbinumTextFld];
//        }
        else if (i == 1){
            userTextFld = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY + 40*(i+1)+5, SCREEN_WIDTH*0.6, 30)];
            userTextFld.placeholder = dic[@"placeHolder"];
            [self setTextFld:userTextFld];
        }
        else if (i == 2){
            totalNumFld = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY + 40*(i+1)+5, SCREEN_WIDTH*0.6, 30)];
            totalNumFld.placeholder = dic[@"placeHolder"];
            totalNumFld.keyboardType = UIKeyboardTypeNumberPad;
            [self setTextFld:totalNumFld];
        }else if (i == 3){
            pwdFld = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY + 40*(i+1)+5, SCREEN_WIDTH*0.6, 30)];
            pwdFld.placeholder = dic[@"placeHolder"];
            pwdFld.secureTextEntry = YES;
            [self setTextFld:pwdFld];
        }
//        else if (i == 5){
//            _cardFeild = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY + 40*(i+1)+5, SCREEN_WIDTH*0.6, 30)];
//            _cardFeild.placeholder = dic[@"placeHolder"];
//            [self setTextFld:_cardFeild];
//        }
//        else if (i == 6)
//        {
//            self.cycleBtn.frame = CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY + 40*(i+1)+5, SCREEN_WIDTH*0.6, 30);
//            self.cycleLbl.frame = CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY + 40*(i+1)+5, SCREEN_WIDTH*0.6, 30);
//            [self.view addSubview:self.cycleBtn];
//            [self.view addSubview:self.cycleLbl];
//        }
        
    }
    getbut=[UIButton buttonWithType:UIButtonTypeCustom];
    getbut.frame=CGRectMake(SCREEN_WIDTH*0.2, CGRectGetMaxY(pwdFld.frame) + 50., SCREEN_WIDTH*0.6, 40);
    [getbut setBackgroundColor:[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1]];
    [getbut setTitle:@"确认转让" forState:UIControlStateNormal];
    [getbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getbut.layer.masksToBounds=YES;
    getbut.layer.cornerRadius=3;
    [getbut addTarget:self action:@selector(clickbao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getbut];
 
}

- (void)setTextFld:(UITextField *)text
{
    text.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
    [text setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    text.layer.masksToBounds=YES;
    text.layer.cornerRadius=3;
    text.textColor=[UIColor grayColor];
    text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
    text.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    [text setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:text];
}

-(void)buttonClicked:(UIButton *)sender
{
    PaidanRecordViewController *number=[[PaidanRecordViewController alloc] init];
    [self.navigationController pushViewController:number animated:YES];
}

-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)clickbao
{

    if ([userTextFld.text length]==0) {
        [ToolControl showHudWithResult:NO andTip:@"请输入账号"];
        return;
    }
    
    if ([totalNumFld.text floatValue]==0||[totalNumFld.text length]==0) {
        [ToolControl showHudWithResult:NO andTip:@"请输入转让数量"];
        return;
    }
    
    if ([pwdFld.text length]==0) {
        [ToolControl showHudWithResult:NO andTip:@"请输入二级密码"];
        return;
    }
//    if (![_cardFeild.text length]) {
//        [ToolControl showHudWithResult:NO andTip:@"请输入身份证最后6位"];
//        return;
//    }
//    NSString *type = @"1";
//    if ([self.cycleLbl.text isEqualToString:@"创益银币"]) {
//        type = @"0";
//    }
    
//    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",userTextFld.text,@"user",totalNumFld.text,@"num",pwdFld.text,@"erpwd",type,@"type",_cardFeild.text,@"cardnum",  nil];
    NSDictionary *paramDict = @{@"id":SAFE_STRING(UID),
                                @"md5":SAFE_STRING(MD5),
                                @"user":SAFE_STRING(userTextFld.text),
                                @"num":SAFE_STRING(totalNumFld.text),
                                @"erpwd":SAFE_STRING(pwdFld.text)
                                };
    [SVProgressHUD showWithStatus:@"请求中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestChuangyebizr" params:paramDict success:^(NSDictionary *dict) {
//    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestChuangyibizrnew" params:dicton success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        @try
        {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                //[arrayData removeAllObjects];
                [self.navigationController popViewControllerAnimated:YES];
                
                double delayInSeconds = 3.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //执行事件
                    getbut.enabled=YES;
                    if (getbut.isEnabled==YES) {
                        [getbut setBackgroundColor:[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1]];
                    }
                    
                });
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

- (void)doneButtonClicked:(id)sender superClass:(ToolBarButton *)toolBarBtn
{
    if (toolBarBtn.tag == 0) {
        self.cycleLbl.text = self.cyclePickerView.titleStr;
    }
}

@end
