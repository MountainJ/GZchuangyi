//
//  EnquiriesViewController.m
//  NB2
//
//  Created by zcc on 16/2/24.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "EnquiriesViewController.h"
#import "AgreeViewController.h"
#import "NoAgreeViewController.h"
#import "CopyLable.h"
#import "GiveMoneyViewController.h"
@interface EnquiriesViewController ()
{
    TopView *topView;
    UIImageView *bodView;
    NSMutableDictionary *idArrayData;
    UIImageView *bodViews;
    UIImage *imageMain;
    UIView *background;
    CGFloat _firstMargin;
    CGFloat _midMargin;
    CGFloat _labelHeight;
    
}

@end

@implementation EnquiriesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    idArrayData=[[NSMutableDictionary alloc] init];
    topView = [[TopView alloc]init];
    topView.titileTx=@"查询";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    
    _firstMargin = 30.f;
    _midMargin = 10.f;
    _labelHeight = SCREEN_HEIGHT/22.23;
    
    
    
    if (self.sign==100)
    {
        topView.buttonRB=@"付款信息";
    }
    [self.view addSubview:topView];
    [topView setTopView];
    NSArray *arraycolcor;
    if (self.sign==100) {
        arraycolcor=[[NSArray alloc] initWithObjects:@"查看资料",@"账户信息", nil];
    }else
    {
        arraycolcor=[[NSArray alloc] initWithObjects:@"查看资料",@"付款信息", nil];
    }
    
    for (int i=0; i<arraycolcor.count; i++)
    {
        UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
        but.frame=CGRectMake(SCREEN_WIDTH/2.0*i, CGRectGetMaxY(topView.frame), SCREEN_WIDTH/2.0, 40);
        but.tag=100+i;
        [but addTarget:self action:@selector(clickbut:) forControlEvents:UIControlEventTouchUpInside];
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
        
        [but setTitle:[arraycolcor objectAtIndex:i] forState:UIControlStateNormal];
        [self.view addSubview:but];
        CGFloat topMargin = 40;
        bodView=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)+topMargin, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-topMargin)];
        bodView.userInteractionEnabled=YES;
        
        bodView.backgroundColor=[UIColor whiteColor];
        bodViews=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)+topMargin, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-topMargin)];
        bodViews.userInteractionEnabled=YES;
        bodViews.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:bodViews];
        [self.view addSubview:bodView];
        bodViews.hidden=YES;
    }
    
    
    // Do any additional setup after loading the view.
}
-(void)actionRight
{
    GiveMoneyViewController *give=[[GiveMoneyViewController alloc] init];
    give.diction=idArrayData;
    [self.navigationController pushViewController:give animated:YES];
}
-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%@",[self.diction objectForKey:@"id"]],@"tid",[NSString stringWithFormat:@"%d",self.sign==100?1:2],@"type",nil];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestPyainfo" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                //[arrayData removeAllObjects];
                idArrayData=[[[dict objectForKey:@"result"] objectAtIndex:0] mutableCopy];
                [self initTopView];
                [self initInfo];
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
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        //[self showError:error];
    }];


}
-(void)initTopView
{
    
        
        NSArray *arraytitle;
        if (self.sign==100)
        {
//            arraytitle=[[NSArray alloc] initWithObjects:@"单号:",@"接收人帐号:",@"接收人:",@"匹配金额:",@"联系人电话:",@"推荐人:",@"手机号:",@"匹配时间:",@"状态:",nil];
            arraytitle=[[NSArray alloc] initWithObjects:@"单号:",@"接收人帐号:",@"接收人:",@"会员级别:",@"匹配金额:",@"联系人电话:",@"推荐人:",@"手机号:",@"匹配时间:",@"状态:",nil];

        }else
        {
            arraytitle=[[NSArray alloc] initWithObjects:@"单号:",@"打款人会员号:",@"打款人姓名:",@"匹配金额:",@"联系电话:",@"推荐人姓名:",@"推荐人电话:",@"匹配时间:",@"状态:",nil];
        }
        
        for (int i=0; i<arraytitle.count; i++)
        {
//            CGFloat firstMargin = 30.f;
//            CGFloat midMargin = 10.f;
//            CGFloat labelHeight = SCREEN_HEIGHT/22.23;
//            CGFloat originY =  SCREEN_HEIGHT/16.675*(i+1)+SCREEN_HEIGHT/120.0;
            CGFloat originY =  _firstMargin + i *(_labelHeight + _midMargin);
            UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH*0.28, _labelHeight)];
            labletitle.textAlignment=NSTextAlignmentRight;
            labletitle.textColor=[UIColor grayColor];
            labletitle.text=[arraytitle objectAtIndex:i];
            labletitle.font=[UIFont systemFontOfSize:14];
            [bodView addSubview:labletitle];
            
            CopyLable *text1;
            UILabel *text;
            if (i==5 && self.sign == 100) {//复制电话号码的下标
                text1=[[CopyLable alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY, SCREEN_WIDTH*0.6, _labelHeight)];
                text1.layer.masksToBounds=YES;
                text1.layer.cornerRadius=3;
                text1.textColor=[UIColor grayColor];
                text1.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
                text1.tag=150+i;
                [text1 setFont:[UIFont systemFontOfSize:14]];
                [bodView addSubview:text1];
            }else if (i==4 && self.sign == 101){
                text1=[[CopyLable alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY, SCREEN_WIDTH*0.6, _labelHeight)];
                text1.layer.masksToBounds=YES;
                text1.layer.cornerRadius=3;
                text1.textColor=[UIColor grayColor];
                text1.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
                text1.tag=150+i;
                [text1 setFont:[UIFont systemFontOfSize:14]];
                [bodView addSubview:text1];
            }
            else
            {
            text=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY, SCREEN_WIDTH*0.6, _labelHeight)];
            text.layer.masksToBounds=YES;
            text.layer.cornerRadius=3;
            text.textColor=[UIColor grayColor];
            text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
            text.tag=150+i;
            [text setFont:[UIFont systemFontOfSize:14]];
            [bodView addSubview:text];
            }
           
            if(self.sign==100)
            {
                if (i==0)
                {
                    text.text=[idArrayData objectForKey:@"orderid"];
                }else if(i==1)
                {
                    text.text=[idArrayData objectForKey:@"user"];
                }else if(i==2)
                {
                    text.text=[idArrayData objectForKey:@"name"];
                }
                else if(i==3)
                {
                    text.text=[idArrayData objectForKey:@"jibie"];
                }
                else if(i==4)
                {
                    text.text=[idArrayData objectForKey:@"jine"];
                }
                else if(i==5)
                {
                    text1.text=[idArrayData objectForKey:@"phone"];
                }
                else if(i==6)
                {
                    text.text=[idArrayData objectForKey:@"tuijianname"];
                }
                else if(i==7)
                {
                    text.text=[idArrayData objectForKey:@"tuijianphone"];
                }else if(i==8)
                {
                    text.text=[idArrayData objectForKey:@"pipeishijian"];
                }
                else if(i==9)
                {
                    if ([[idArrayData objectForKey:@"paystation"] integerValue]==0)
                    {
                        text.text=@"未付款";
                        
                    }else if ([[idArrayData objectForKey:@"paystation"] integerValue]==1)
                    {
                        text.text=@"已付款";
                        
                    }
                    else if ([[idArrayData objectForKey:@"paystation"] integerValue]==2)
                    {
                        text.text=@"已收款";
                        
                    }
                    //text.text=[idArrayData objectForKey:@"beizhu"];
                }
            }else
            {
                if (i==0)
                {
                    text.text=[idArrayData objectForKey:@"orderid"];
                }else if(i==1)
                {
                    text.text=[idArrayData objectForKey:@"user"];
                }else if(i==2)
                {
                    text.text=[idArrayData objectForKey:@"name"];
                }
                else if(i==3)
                {
                    text.text=[idArrayData objectForKey:@"jine"];
                }
                else if(i==4)
                {
                    text1.text=[idArrayData objectForKey:@"phone"];
                }
                else if(i==5)
                {
                    text.text=[idArrayData objectForKey:@"tuijianname"];
                }
                else if(i==6)
                {
                    text.text=[idArrayData objectForKey:@"tuijianphone"];
                }else if(i==7)
                {
                    text.text=[idArrayData objectForKey:@"pipeishijian"];
                }
                else if(i==8)
                {
                    if ([[idArrayData objectForKey:@"paystation"] integerValue]==0)
                    {
                        text.text=@"未付款";
                        
                    }else if ([[idArrayData objectForKey:@"paystation"] integerValue]==1)
                    {
                        text.text=@"已付款";
                        
                    }
                    else if ([[idArrayData objectForKey:@"paystation"] integerValue]==2)
                    {
                        text.text=@"已收款";
                        
                    }
                    //text.text=[idArrayData objectForKey:@"beizhu"];
                }
            }
            
            
        }
    
        if (self.sign==100)//
        {
            if ([[idArrayData objectForKey:@"paystation"] integerValue]==0)
            {
                UIButton *getbut=[UIButton buttonWithType:UIButtonTypeCustom];
                getbut.frame=CGRectMake(SCREEN_WIDTH*0.1, SCREEN_HEIGHT*0.66, SCREEN_WIDTH*0.3, 40);
                [getbut setBackgroundColor:[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1]];
                [getbut setTitle:@"同意付款" forState:UIControlStateNormal];
                [getbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                getbut.layer.masksToBounds=YES;
                getbut.layer.cornerRadius=3;
                getbut.tag=500;
                [getbut addTarget:self action:@selector(clickisagree:) forControlEvents:UIControlEventTouchUpInside];
                [bodView addSubview:getbut];
                
                UIButton *getbut1=[UIButton buttonWithType:UIButtonTypeCustom];
                getbut1.frame=CGRectMake(SCREEN_WIDTH*0.6, SCREEN_HEIGHT*0.66, SCREEN_WIDTH*0.3, 40);
                [getbut1 setBackgroundColor:[UIColor greenColor]];
                [getbut1 setTitle:@"拒绝付款" forState:UIControlStateNormal];
                [getbut1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                getbut1.layer.masksToBounds=YES;
                getbut1.layer.cornerRadius=3;
                getbut1.tag=501;
                [getbut1 addTarget:self action:@selector(clickisagree:) forControlEvents:UIControlEventTouchUpInside];
                [bodView addSubview:getbut1];
            
            }else
            {
                UIButton *btn1 = [bodView viewWithTag:500];
                btn1.hidden = YES;
                UIButton *btn2 = [bodView viewWithTag:501];
                btn2.hidden = YES;
            }
        }else
        {
            if ([[idArrayData objectForKey:@"paystation"] integerValue]==1)
            {
                UIButton *getbut=[UIButton buttonWithType:UIButtonTypeCustom];
                getbut.frame=CGRectMake(SCREEN_WIDTH*0.1, SCREEN_HEIGHT*0.66, SCREEN_WIDTH*0.8, 40);
                [getbut setBackgroundColor:[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1]];
                [getbut setTitle:@"确认收款" forState:UIControlStateNormal];
                [getbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                getbut.layer.masksToBounds=YES;
                getbut.layer.cornerRadius=3;
                getbut.tag=502;
                [getbut addTarget:self action:@selector(clickisagree:) forControlEvents:UIControlEventTouchUpInside];
                [bodView addSubview:getbut];
            
            }
            
        }

}
-(void)clickisagree:(UIButton *)sender
{
    if (sender.tag==500)
    {
        AgreeViewController *ager=[[AgreeViewController alloc] init];
        ager.tid=[NSString stringWithFormat:@"%@",[self.diction objectForKey:@"id"]];
        [self.navigationController pushViewController:ager animated:YES];
        
    }else if(sender.tag==501)
    {
        NoAgreeViewController *ager=[[NoAgreeViewController alloc] init];
        ager.tid=[NSString stringWithFormat:@"%@",[self.diction objectForKey:@"id"]];
        [self.navigationController pushViewController:ager animated:YES];
    }else
    {
    
        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%@",[self.diction objectForKey:@"id"]],@"tid",nil];
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
        
        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestQuerenshoukuan" params:dicton success:^(NSDictionary *dict) {
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

}
-(void)clickbut:(UIButton *)sneder
{
    if (sneder.tag==100)
    {
        sneder.selected=YES;
        UIButton *but1=[self.view viewWithTag:101];
        but1.selected=NO;
        bodView.hidden=NO;
        bodViews.hidden=YES;
    }
    if (sneder.tag==101)
    {
        sneder.selected=YES;
        UIButton *but1=[self.view viewWithTag:100];
        but1.selected=NO;
        bodView.hidden=YES;
        bodViews.hidden=NO;
    }
}

-(void)initInfo
{
    if(self.sign==100)
    {
        NSArray *arraytitle=[[NSArray alloc] initWithObjects:@"开户银行:",@"开户行地址:",@"银行卡号:",@"户名:",@"微信:",@"支付宝:",nil];
        for (int i=0; i<arraytitle.count; i++)
        {
            CGFloat originY =  _firstMargin + i *(_labelHeight + _midMargin);

            UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH*0.28, _labelHeight)];
            labletitle.textAlignment=NSTextAlignmentRight;
            labletitle.textColor=[UIColor grayColor];
            labletitle.text=[arraytitle objectAtIndex:i];
            labletitle.font=[UIFont systemFontOfSize:14];
            [bodViews addSubview:labletitle];
            
            CopyLable *text1;
            UILabel *text;
            if (i==2||i==5) {
                text1=[[CopyLable alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5,originY, SCREEN_WIDTH*0.6, _labelHeight)];
                text1.layer.masksToBounds=YES;
                text1.layer.cornerRadius=3;
                text1.textColor=[UIColor grayColor];
                text1.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
                text1.tag=150+i;
                [text1 setFont:[UIFont systemFontOfSize:14]];
                [bodViews addSubview:text1];
            }else
            {
                text=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labletitle.frame)+5, originY, SCREEN_WIDTH*0.6, _labelHeight)];
                text.layer.masksToBounds=YES;
                text.layer.cornerRadius=3;
                text.textColor=[UIColor grayColor];
                text.backgroundColor=[UIColor colorWithRed:221.0/255 green:222.0/255 blue:221.0/255 alpha:1];
                text.tag=150+i;
                [text setFont:[UIFont systemFontOfSize:14]];
                [bodViews addSubview:text];
            }
            
            if (i==0) {
                text.text=[idArrayData objectForKey:@"bankname"];
            }else if(i==1)
            {
                text.text=[idArrayData objectForKey:@"kaihuhang"];
            }else if(i==2)
            {
                text1.text=[idArrayData objectForKey:@"banknum"];
            }else if(i==3)
            {
                text.text=[idArrayData objectForKey:@"huming"];
            }else if(i==4)
            {
                text.text=[idArrayData objectForKey:@"weixin"];
            }else if(i==5)
            {
                text1.text=[idArrayData objectForKey:@"alipay"];
            }
            
            
        }
    }else
    {
        [self initUIPay];
    
    }
  
}
-(void)initUIPay
{
    
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH*0.5,20 )];
    lable.text=@"转账日期：";
    lable.font=[UIFont systemFontOfSize:14];
    lable.textColor=[UIColor grayColor];
    [bodViews addSubview:lable];
    
    UILabel *daylable=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lable.frame)+2, SCREEN_WIDTH*0.6, 25)];
    daylable.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    daylable.font=[UIFont systemFontOfSize:13];
    daylable.text=[self.diction objectForKey:@"paytime"];
    daylable.userInteractionEnabled=YES;
    [bodViews addSubview:daylable];
    
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    but.frame=CGRectMake(SCREEN_WIDTH*0.6-20, 2, 20, 20);
    [but setBackgroundImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
    [daylable addSubview:but];
    
    UILabel *daylable1=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(daylable.frame)+15, SCREEN_WIDTH*0.6, 25)];
    daylable1.backgroundColor=[UIColor clearColor];
    daylable1.text=@"付款的订单信息：";
    daylable1.font=[UIFont systemFontOfSize:14];
    [bodViews addSubview:daylable1];
    
    
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(daylable1.frame), 80, 100)];
    imgview.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",kBaseURL,[self.diction objectForKey:@"pic"]];
    UIImage *imgae=[HttpTool getUrlDataForm:strurl];
    if (imgae==nil) {
        imgview.image=[UIImage imageNamed:@""];
    }else
    {
        imgview.image=imgae;
        imageMain=imgae;
        //允许用户交互
        imgview.userInteractionEnabled = YES;
        //添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [imgview addGestureRecognizer:tapGesture];
    }
    [bodViews addSubview:imgview];
    
    
    UILabel *lablebei=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imgview.frame)+20, SCREEN_WIDTH*0.5,20 )];
    lablebei.text=@"备注信息：";
    lablebei.font=[UIFont systemFontOfSize:15];
    lablebei.textColor=[UIColor grayColor];
    [bodViews addSubview:lablebei];
    
    UITextView *textfied=[[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lablebei.frame)+2, SCREEN_WIDTH-30, 60)];
    textfied.layer.borderWidth=1;
    textfied.text=[self.diction objectForKey:@"beizhu"];
    textfied.layer.borderColor=[UIColor grayColor].CGColor;
    textfied.textColor=[UIColor blackColor];
    textfied.backgroundColor=[UIColor grayColor];
    textfied.editable=NO;
    [bodViews addSubview:textfied];
    
}


- (void) tapAction{
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    [bgView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bgView];
    
    //创建显示图像的视图
    //初始化要显示的图片内容的imageView（这里位置继续偷懒...没有计算）
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //要显示的图片，即要放大的图片
    [imgView setImage:imageMain];
    [bgView addSubview:imgView];
    
    imgView.userInteractionEnabled = YES;
    //添加点击手势（即点击图片后退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [imgView addGestureRecognizer:tapGesture];
    
    [self shakeToShow:bgView];//放大过程中的动画
}
-(void)closeView{
    [background removeFromSuperview];
}
//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
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
