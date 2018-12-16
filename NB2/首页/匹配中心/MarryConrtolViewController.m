//
//  MarryConrtolViewController.m
//  NB2
//
//  Created by zcc on 16/2/22.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "MarryConrtolViewController.h"
#import "RecordViewController.h"
#import "ToolBarButton.h"
#import "RegistPickerView.h"

#define kFristTextfieldTag  1100

@interface MarryConrtolViewController ()<ToolBarButtonDelegate>
{
    TopView *topView;
    int sign;
    UIImageView *bodview;
    //UILabel *labletext;
    NSMutableArray *arrayData;
    UIButton *getbut;
}
@property (nonatomic, strong) ToolBarButton *cycleBtn;
@property (nonatomic, strong) RegistPickerView *cyclePickerView;
@property (nonatomic, strong) UILabel       *cycleLbl;
@property (nonatomic, strong) NSArray       *zhouqiArr;

@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UIButton *goldButton;
@property (nonatomic,strong) UIButton *silverButton;
@property (nonatomic,copy) NSString *selectType;


@end

@implementation MarryConrtolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    topView = [[TopView alloc]init];
    topView.titileTx=@"匹配中心";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    topView.buttonRB=@"记录查询";
    [self.view addSubview:topView];
    [topView setTopView];
    [self initTopView];
    [self initData];
    self.selectType = @"1";
    if (self.indexsign==401)
    {
        sign=1;
        [self clciksign:[self.view viewWithTag:101]];
    }
    
    // Do any additional setup after loading the view.
}
-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5", nil];
    
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestUserinfo" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                //[arrayData removeAllObjects];
                arrayData=[[dict objectForKey:@"result"] mutableCopy];
                if (self.indexsign==401)
                {
                    UITextField *textFeid=[bodview viewWithTag:120];
                    textFeid.text=[NSString stringWithFormat:@"%@",[[arrayData objectAtIndex:0] objectForKey:@"benjin"]];
                    UITextField *textFeid1=[bodview viewWithTag:121];
                    textFeid1.text=[NSString stringWithFormat:@"%@",[[arrayData objectAtIndex:0] objectForKey:@"hongli"]];
                }else
                {
                    UITextField *textFeid=[bodview viewWithTag:kFristTextfieldTag];
                    textFeid.text=[NSString stringWithFormat:@"%@元",[[arrayData objectAtIndex:0] objectForKey:@"zongpaidan"]];
                    UILabel *textlable=[bodview viewWithTag:500];
                    textlable.text=[NSString stringWithFormat:@"可参与额度：%@元",[[arrayData objectAtIndex:0] objectForKey:@"tigongedu"]];
//                    UITextField *textFeid1=[bodview viewWithTag:kFristTextfieldTag+2];
//                    textFeid1.text=[NSString stringWithFormat:@"%@",[[arrayData objectAtIndex:0] objectForKey:@"jinbi"]];
//                    UITextField *textFeid2=[bodview viewWithTag:kFristTextfieldTag+3];
//                    textFeid2.text=[NSString stringWithFormat:@"%@",[[arrayData objectAtIndex:0] objectForKey:@"yinbi"]];
                }
                
                
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
        _cyclePickerView = [[RegistPickerView alloc] initWithItem:@[@"15",@"30",@"60"]];
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
    }
    return _cycleLbl;
}

-(void)initTopView
{
    NSArray *arraycolcor=[[NSArray alloc] initWithObjects:@"众筹参与",@"众筹红利", nil];
    for (int i=0; i<2; i++)
    {
        UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
        but.frame=CGRectMake(SCREEN_WIDTH/2.0*i, CGRectGetMaxY(topView.frame), SCREEN_WIDTH/2.0, 40);
        but.tag=100+i;
        but.titleLabel.font=[UIFont systemFontOfSize:14];
        if (i==0)
        {
            but.selected=YES;
            [but setBackgroundImage:[UIImage imageNamed:@"frist"] forState:UIControlStateSelected];
            [but setBackgroundImage:[UIImage imageNamed:@"butnooselectgreen"] forState:UIControlStateNormal];
        }else if(i==1)
        {
            [but setBackgroundImage:[UIImage imageNamed:@"two"] forState:UIControlStateSelected];
            [but setBackgroundImage:[UIImage imageNamed:@"butnooselect"] forState:UIControlStateNormal];
        }
        [but addTarget:self action:@selector(clciksign:) forControlEvents:UIControlEventTouchUpInside];
        [but setTitle:[arraycolcor objectAtIndex:i] forState:UIControlStateNormal];
        [self.view addSubview:but];
    }
    bodview=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)+40, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-40-45)];
    bodview.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicktap)];
    [bodview addGestureRecognizer:tap];
    [self.view addSubview:bodview];
    
    //sign =0 表示提供帮组，sign=1表示请求帮助
    NSArray *arraytitle;
    if (sign==0)
    {
         arraytitle=[[NSArray alloc] initWithObjects:@"当前参与额:",@"参与金额:",@"二级密码:", nil];
    }else
    {
        arraytitle=[[NSArray alloc] initWithObjects:@"本金钱包:",@"红利钱包:",@"众筹金额:",@"二级密码:", nil];
    }
    CGFloat originY = 0.;
    for (int i=0; i<arraytitle.count; i++)
    {
        UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 50*(i+1)+5, SCREEN_WIDTH*0.3, 30)];
        labletitle.textAlignment=NSTextAlignmentRight;
        labletitle.textColor=[UIColor grayColor];
        labletitle.text=[arraytitle objectAtIndex:i];
        labletitle.adjustsFontSizeToFitWidth=YES;
        labletitle.font=[UIFont systemFontOfSize:14];
        [bodview addSubview:labletitle];
            UITextField *text=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, 50*(i+1)+5, SCREEN_WIDTH*0.6, 30)];
            if (sign == 0) {
                if (i==2) {
                    text.secureTextEntry = YES;
                }
            }else
            {
                if (i==3) {
                    text.secureTextEntry = YES;
                }
            }
            text.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
            [text setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            text.layer.masksToBounds=YES;
            text.layer.cornerRadius=3;
            text.textColor=[UIColor grayColor];
            text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
            text.tag=kFristTextfieldTag+i;
            text.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
            text.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
            [text setFont:[UIFont systemFontOfSize:14]];
            [bodview addSubview:text];

        if (i==1) {
            UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5,135 , SCREEN_WIDTH*0.6, 20)];
            lable.textColor=[UIColor grayColor];
            lable.backgroundColor=[UIColor clearColor];
            lable.adjustsFontSizeToFitWidth=YES;
            lable.font=[UIFont systemFontOfSize:13];
            lable.tag=500;
            [bodview addSubview:lable];
        }
        originY = 50*(i+1)+5.;
    }
    
    getbut=[UIButton buttonWithType:UIButtonTypeCustom];
    getbut.frame=CGRectMake(SCREEN_WIDTH*0.2, originY + 50, SCREEN_WIDTH*0.6, 40);
    [getbut setBackgroundColor:[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1]];
    [getbut setTitle:@"提交保存" forState:UIControlStateNormal];
    [getbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getbut.layer.masksToBounds=YES;
    getbut.layer.cornerRadius=3;
    bodview.userInteractionEnabled=YES;
    [getbut addTarget:self action:@selector(clickbao) forControlEvents:UIControlEventTouchUpInside];
    [bodview addSubview:getbut];
    
}
-(void)clicktap
{
    [self.view endEditing:NO];
}
#pragma mark - 切换
-(void)clciksign:(UIButton *)sender
{
    for(UIView *view in [bodview subviews])
    {
        [view removeFromSuperview];
    }
    if(sender.tag==100)
    {
        sender.selected=YES;
        UIButton *but1=[self.view viewWithTag:101];
        but1.selected=NO;
        sign=0;
        //labletext.text=@"申请完成并在排队三天后，购买匹配码即可进入匹配大厅，接受系统匹配";
        
    }else
    {
        sender.selected=YES;
        UIButton *but1=[self.view viewWithTag:100];
        but1.selected=NO;
        sign=1;
        //labletext.text=@"申请完成并在排队三天后，耐心等待系统随机分配受善需求";
    }

    NSArray *arraytitle;
    if (sign==0)
    {
        arraytitle=[[NSArray alloc] initWithObjects:@"当前参与额:",@"参与金额:",@"二级密码:", nil];
    }else
    {
        arraytitle=[[NSArray alloc] initWithObjects:@"本金钱包:",@"红利钱包:",@"众筹金额:",@"二级密码:", nil];
    }
    
    CGFloat originY = 0.;
    CGFloat selectHeight = 50.f;
    for (int i=0; i<arraytitle.count; i++)
    {
        
        CGFloat fieledLabelOringY = 50*(i+1)+5 ;
        if (sign == 1 && i >= 2) {
            fieledLabelOringY += selectHeight;
        }
        UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, fieledLabelOringY, SCREEN_WIDTH*0.3, 30)];
        labletitle.textAlignment=NSTextAlignmentRight;
        labletitle.textColor=[UIColor grayColor];
        labletitle.text=[arraytitle objectAtIndex:i];
        labletitle.font=[UIFont systemFontOfSize:14];
        [bodview addSubview:labletitle];
        if (sign==0)
        {
            if (i==1)//可参与额度
            {
                UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5,135 , SCREEN_WIDTH*0.6, 20)];
                lable.textColor=[UIColor grayColor];
                lable.adjustsFontSizeToFitWidth=YES;
                lable.font=[UIFont systemFontOfSize:13];
                lable.tag=500;
                [bodview addSubview:lable];
            }
        }
            UITextField *text=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, fieledLabelOringY, SCREEN_WIDTH*0.6, 30)];
            if (sign == 0) {
                if (i==arraytitle.count - 1) {
                    text.secureTextEntry = YES;
                }
            }else
            {
                if (i==3) {
                    text.secureTextEntry = YES;
                }
            }
            text.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
            [text setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            text.layer.masksToBounds=YES;
            text.layer.cornerRadius=3;
            text.textColor=[UIColor grayColor];
            text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
        
        if (sign == 1 && i == 2) {
            //在这里增加选择的钱包：
            self.typeLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMinY(labletitle.frame) - selectHeight - 10, SCREEN_WIDTH*0.3, selectHeight) backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:bodview labelText:@"请选择钱包:"];
            self.typeLabel.textAlignment = NSTextAlignmentRight;

            self.goldButton = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame), CGRectGetMinY(self.typeLabel.frame), KKFitScreen(170), CGRectGetHeight(self.typeLabel.frame)) backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] clickAction:@selector(clidktype:) clickTarget:self addToView:bodview buttonText:@"本金钱包"];
            self.goldButton.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(26)];
            self.goldButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self.goldButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            [self.goldButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            [self.goldButton setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
            [self.goldButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
            self.goldButton.selected = YES;

            self.silverButton = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.goldButton.frame), CGRectGetMinY(self.typeLabel.frame), CGRectGetWidth(self.goldButton.frame), CGRectGetHeight(self.typeLabel.frame)) backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] clickAction:@selector(clidktype:) clickTarget:self addToView:bodview buttonText:@"红利钱包"];
            self.silverButton.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(26)];
            [self.silverButton setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
            self.silverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self.silverButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
            [self.silverButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            [self.silverButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
    
            if (sign==0) {
                text.tag= kFristTextfieldTag+i;
                if (i==0)
                {
                    text.text=[NSString stringWithFormat:@"%@元",[[arrayData objectAtIndex:0] objectForKey:@"zongpaidan"]];
                    text.enabled=NO;
                }if (i==1)
                {
                    UILabel *textlable=[bodview viewWithTag:500];
                    textlable.text=[NSString stringWithFormat:@"可参与额度：%@元",[[arrayData objectAtIndex:0] objectForKey:@"tigongedu"]];
                }
//                else if (i == 2)
//                {
//                    text.enabled = NO;
//                    text.text = [NSString stringWithFormat:@"%@",[[arrayData objectAtIndex:0] objectForKey:@"jinbi"]];
//                }else if (i == 3)
//                {
//                    text.enabled = NO;
//                    text.text = [NSString stringWithFormat:@"%@",[[arrayData objectAtIndex:0] objectForKey:@"yinbi"]];
//                }
                
            }else{
                text.tag=120+i;
                if (i==0)
                {
                    text.text=[NSString stringWithFormat:@"%@",[[arrayData objectAtIndex:0] objectForKey:@"benjin"]];
                    text.enabled=NO;
                }
                if (i==1)
                {
                    text.text=[NSString stringWithFormat:@"%@",[[arrayData objectAtIndex:0] objectForKey:@"hongli"]];
                    text.enabled=NO;
                }
            }
            text.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
            text.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
            [text setFont:[UIFont systemFontOfSize:14]];
            [bodview addSubview:text];
        originY = 50*(i+1)+5.;
        if (sign == 1) {
            originY += selectHeight;
        }
    }
    
    getbut=[UIButton buttonWithType:UIButtonTypeCustom];
    getbut.frame=CGRectMake(SCREEN_WIDTH*0.2, originY + 50, SCREEN_WIDTH*0.6, 40);
    [getbut setBackgroundColor:[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1]];
    [getbut setTitle:@"提交保存" forState:UIControlStateNormal];
    [getbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getbut.layer.masksToBounds=YES;
    getbut.layer.cornerRadius=3;
    [getbut addTarget:self action:@selector(clickbao) forControlEvents:UIControlEventTouchUpInside];
    [bodview addSubview:getbut];

}


- (void)clidktype:(UIButton *)btn
{
    if (btn == self.goldButton) {
        self.goldButton.selected = YES;
        self.silverButton.selected = NO;
        self.selectType = @"1";
    }else if (btn == self.silverButton){
        self.silverButton.selected = YES;
        self.goldButton.selected = NO;
        self.selectType = @"2";
    }
}


-(void)clickbao
{
    NSMutableDictionary *dicton=nil;
    UITextField *textFeid=nil;
    if (sign==0)
    {
        textFeid=[bodview viewWithTag:kFristTextfieldTag + 1];
        if ([textFeid.text floatValue]==0||[textFeid.text length]==0) {
            [ToolControl showHudWithResult:NO andTip:@"请输入正确金额"];
            return;
        }
        UITextField *textFeid1=[bodview viewWithTag:kFristTextfieldTag + 2];
        if ([textFeid1.text length]==0) {
            [ToolControl showHudWithResult:NO andTip:@"请输入二级密码"];
            return;
        }
        
        NSString *zhouqi = @"";
        for (NSDictionary *dic in self.zhouqiArr) {
            NSString *tian = [dic objectForKey:@"tian"];
            if ([tian isEqualToString:self.cycleLbl.text]) {
                zhouqi = [dic objectForKey:@"typeid"];
            }
        }

        dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",textFeid.text,@"jine",@"1",@"type",textFeid1.text,@"erpwd", @"1", @"leixing", @"1", @"type",nil];
        textFeid=[bodview viewWithTag:kFristTextfieldTag+1];
        
    }else
    {
        textFeid=[bodview viewWithTag:122];
        if ([textFeid.text floatValue]==0||[textFeid.text length]==0) {
            [ToolControl showHudWithResult:NO andTip:@"请输入金额"];
            return;
        }
        UITextField *textFeid1=[bodview viewWithTag:123];
        if ([textFeid1.text length]==0) {
            [ToolControl showHudWithResult:NO andTip:@"请输入二级密码"];
            return;
        }
        
        dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",textFeid.text,@"jine",@"2",@"type",textFeid1.text,@"erpwd",self.selectType, @"leixing", nil];
    }
    [SVProgressHUD showWithStatus:@"请求中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestHelp" params:dicton success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        @try
        {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                //[arrayData removeAllObjects];
                [self.navigationController popViewControllerAnimated:YES];
                //执行事件
                getbut.enabled=NO;
                if (getbut.isEnabled==NO) {
                    [getbut setBackgroundColor:[UIColor grayColor]];
                }
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
-(void)actionRight
{
    RecordViewController *record=[[RecordViewController alloc] init];
    [self.navigationController pushViewController:record animated:YES];
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

- (void)singleClickButton:(id)sender
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5", nil];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestZhouqi" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                
                NSArray *result = [dict objectForKey:@"result"];
                self.zhouqiArr = result;
                NSMutableArray *tianArr = [[NSMutableArray alloc] initWithCapacity:result.count];
                for (NSDictionary *dic in result) {
                    NSString *tian = [dic objectForKey:@"tian"];
                    [tianArr addObject:tian];
                }
                [self.cyclePickerView reloadItemList:tianArr];
                [self.cycleBtn becomeFirstResponder];
            }
            
            NSLog(@"%@",dict);
        }
        @catch (NSException *exception)
        {
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)doneButtonClicked:(id)sender superClass:(ToolBarButton *)toolBarBtn
{
    if (toolBarBtn.tag == 0) {
        self.cycleLbl.text = self.cyclePickerView.titleStr;
    }
}
@end
