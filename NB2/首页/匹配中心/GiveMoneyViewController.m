//
//  GiveMoneyViewController.m
//  NB2
//
//  Created by zcc on 16/8/13.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "GiveMoneyViewController.h"

@implementation GiveMoneyViewController
{
    TopView *topView;
    UIScrollView *keyview;
    UIView *background;
    UIImage *imageMain;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    [self initTopView];
    [self initUI];
    //[self initData];
    
    // Do any additional setup after loading the view.
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"付款信息";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
}
-(void)initUI
{
    //主bodyview
    keyview=[[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(topView.frame) , SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topView.frame))];
    keyview.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    keyview.tag=101;
    
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH*0.5,20 )];
    lable.text=@"转账日期：";
    lable.font=[UIFont systemFontOfSize:14];
    lable.textColor=[UIColor grayColor];
    [keyview addSubview:lable];
    
    UILabel *daylable=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lable.frame)+2, SCREEN_WIDTH*0.6, 25)];
    daylable.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    daylable.font=[UIFont systemFontOfSize:13];
    daylable.text=[self.diction objectForKey:@"paytime"];
    daylable.userInteractionEnabled=YES;
    [keyview addSubview:daylable];
    
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    but.frame=CGRectMake(SCREEN_WIDTH*0.6-20, 2, 20, 20);
    [but setBackgroundImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
    [daylable addSubview:but];
    
    UILabel *daylable1=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(daylable.frame)+15, SCREEN_WIDTH*0.6, 25)];
    daylable1.backgroundColor=[UIColor clearColor];
    daylable1.text=@"付款的订单信息：";
    daylable1.font=[UIFont systemFontOfSize:14];
    [keyview addSubview:daylable1];
    

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
    [keyview addSubview:imgview];
    
    
    UILabel *lablebei=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imgview.frame)+20, SCREEN_WIDTH*0.5,20 )];
    lablebei.text=@"备注信息：";
    lablebei.font=[UIFont systemFontOfSize:15];
    lablebei.textColor=[UIColor grayColor];
    [keyview addSubview:lablebei];
    
    UITextView *textfied=[[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lablebei.frame)+2, SCREEN_WIDTH-30, 60)];
    textfied.layer.borderWidth=1;
    textfied.text=[self.diction objectForKey:@"beizhu"];
    textfied.layer.borderColor=[UIColor grayColor].CGColor;
    textfied.textColor=[UIColor blackColor];
    textfied.backgroundColor=[UIColor grayColor];
    textfied.editable=NO;
    [keyview addSubview:textfied];

    [self.view addSubview:keyview];
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
// Do any additional setup after loading the view.
-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
