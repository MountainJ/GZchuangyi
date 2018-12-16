//
//  OneViewController.m
//  NB2
//
//  Created by zcc on 16/2/18.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "OneViewController.h"
#import "DeclarationViewController.h"
#import "NavViewController.h"
#import "BonusViewController.h"
#import "MailViewController.h"
#import "MingriZhonggouHomeVC.h"
#import "RecordViewController.h"
#import "MarryConrtolViewController.h"
#import <StoreKit/StoreKit.h>

#import "UIButton+PASEExtra.h"


@interface OneViewController ()<SKStoreProductViewControllerDelegate>
{
    UIImageView *bodyView;
    UITextField *nameTF;
}

@property (nonatomic,strong) UIView  *middleView;
@property (nonatomic,strong) TopView  *topView;

@property (nonatomic,strong) UIButton  *zhouchouBtn;
@property (nonatomic,strong) UIButton  *baodanBtn;
@property (nonatomic,strong) UIButton  *yejiBtn;
@property (nonatomic,strong) UIButton  *mingriBtn;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)initUI
{
//    UIView *barView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20+JF_TOP_ACTIVE_SPACE)];
//    barView.backgroundColor = COLOR_STATUS_NAV_BAR_BACK;
//    [self.view addSubview:barView];
    
    //标题栏
    _topView = [[TopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20+JF_TOP_ACTIVE_SPACE)];
    _topView.titileTx=@"创业板";
    _topView.backgroundColor = COLOR_STATUS_NAV_BAR_BACK;
    [self.view addSubview:_topView];
    [_topView setTopView];
    
    //主view
    bodyView=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), SCREEN_WIDTH, self.view.bounds.size.height -_topView.bounds.size.height - TAB_BAR_HEIGHT)];
    bodyView.backgroundColor= COLOR_RGB(246, 246, 246);
    bodyView.userInteractionEnabled=YES;
    [self.view addSubview:bodyView];
    [self initTopview];
    
}


-(void)initTopview
{
//    UIImageView *naview=[[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,SCREEN_WIDTH, NAV_BAR_HEIGHT)];
//    naview.backgroundColor = COLOR_STATUS_NAV_BAR_BACK;
//    UIImageView *titleview=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-35)/2.0, 3, 35, 40)];
//    titleview.image=[UIImage imageNamed:@"标题栏LOGO"];
//    [naview addSubview:titleview];
//    [bodyView addSubview:naview];
    //轮播的图片
    UIImageView *lunimgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KKFitScreen(450.))];
    lunimgview.image=[UIImage imageNamed:@"homepage_top_back"];
    [bodyView addSubview:lunimgview];
    
    UIView *middeleView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lunimgview.frame), SCREEN_WIDTH, SCREEN_HEIGHT/11.116)];
    middeleView.backgroundColor=[UIColor colorWithRed:30.0/255 green:102.0/255 blue:152.0/255 alpha:1];
    [bodyView addSubview:middeleView];
    self.middleView = middeleView;
    NSArray *array=[[NSArray alloc] initWithObjects:@"众筹参与",@"众筹红利",@"记录查询", nil];
    NSArray *arrays=[[NSArray alloc] initWithObjects:@"Public participation",@"All chips bonus",@"To match", nil];
    for (int i=0; i<array.count; i++)
    {
        UIButton *but=[UIButton buttonWithType: UIButtonTypeCustom];
        but.showsTouchWhenHighlighted=YES;
        but.frame=CGRectMake(i*SCREEN_WIDTH/3.0, 0, SCREEN_WIDTH/3.0, SCREEN_HEIGHT/11.116);
        but.tag= 400+i;
        [but addTarget:self action:@selector(clickhelp:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH/3.0, but.frame.size.height/3.0)];
        labletitle.textAlignment=NSTextAlignmentCenter;
        
        labletitle.textColor= [UIColor whiteColor];
        labletitle.text=[array objectAtIndex:i];
        labletitle.font=[UIFont systemFontOfSize:14.];
        [but addSubview:labletitle];
        UILabel *labletitles=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labletitle.frame), SCREEN_WIDTH/3.0, but.frame.size.height/3.0)];
        labletitles.textColor=COLOR_RGB(110., 147, 174);
        labletitles.adjustsFontSizeToFitWidth = YES;
        labletitles.text=[arrays objectAtIndex:i];
        labletitles.textAlignment=NSTextAlignmentCenter;
        labletitles.font=[UIFont systemFontOfSize:12.];
        [but addSubview:labletitles];
        [middeleView addSubview:but];
        if (i!=0)
        {
            UIView *hengview=[[UIView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/3.0-1, but.frame.size.height/4.0, 1, but.frame.size.height/1.71)];
            hengview.backgroundColor=[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
            [middeleView addSubview:hengview];
        }
    }
    [self initFoot:middeleView];
}
-(void)clickhelp:(UIButton *)sender
{
    if (sender.tag==400||sender.tag==401)
    {
        MarryConrtolViewController *declar=[[MarryConrtolViewController alloc] init];
        declar.indexsign= sender.tag;
        [self.navigationController pushViewController:declar animated:YES];
    }else
    {
        RecordViewController *record=[[RecordViewController alloc] init];
        [self.navigationController pushViewController:record animated:YES];
    }
}


-(void)initFoot:(UIView *)senderview
{
//    UIImageView *naview=[[UIImageView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(senderview.frame) , SCREEN_WIDTH, SCREEN_HEIGHT/13.896)];
//    naview.backgroundColor=[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
//    naview.userInteractionEnabled=YES;
//    [bodyView addSubview:naview];
    
    //输入查询内容
//    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.1, 5,SCREEN_WIDTH*0.8,SCREEN_HEIGHT/17.55)];
//    [nameTF setPlaceholder:@" 请输入查询内容"];
//    [nameTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
//    nameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
//    nameTF.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
//    nameTF.returnKeyType =UIReturnKeyDone;
//    nameTF.delegate = self;
//    nameTF.textColor=[UIColor grayColor];
//    nameTF.layer.masksToBounds=YES;
//    nameTF.layer.cornerRadius=5;
//    nameTF.backgroundColor=[UIColor whiteColor];
//    [nameTF setFont:[UIFont systemFontOfSize:15]];
//    [naview addSubview:nameTF];
    
//    UIButton *shoubut=[UIButton buttonWithType:UIButtonTypeCustom];
//    shoubut.frame=CGRectMake(nameTF.frame.size.width-SCREEN_WIDTH/9.868, 0, SCREEN_WIDTH/9.868, SCREEN_HEIGHT/17.55);
//    [shoubut setBackgroundImage:[UIImage imageNamed:@"shousuo"] forState:UIControlStateNormal];
//    [nameTF addSubview:shoubut];
    
    
    //众筹平台
    CGFloat leftHeight = bodyView.bounds.size.height - CGRectGetMaxY(self.middleView.frame);
    
    CGRect frame=CGRectMake(0, CGRectGetMaxY(self.middleView.frame), SCREEN_WIDTH * 0.5 -1, leftHeight * 0.5);
    self.zhouchouBtn = [self creatMiddleBottomFrame:frame imgName:@"homepage_bottom_platform" title:@"众筹平台"];
    [bodyView addSubview:self.zhouchouBtn];
    //报单
    CGRect baodanframe = CGRectMake(SCREEN_WIDTH * 0.5, CGRectGetMinY(self.zhouchouBtn.frame), SCREEN_WIDTH * 0.5 -1, CGRectGetHeight(self.zhouchouBtn.frame));
    self.baodanBtn = [self creatMiddleBottomFrame:baodanframe imgName:@"homepage_bottom_center" title:@"报单中心"];
    [bodyView addSubview:self.baodanBtn];
    //业绩分红
    CGRect yejiframe=CGRectMake(0, CGRectGetMaxY(self.zhouchouBtn.frame)+1, CGRectGetWidth(self.zhouchouBtn.frame), leftHeight * 0.5);
    self.yejiBtn = [self creatMiddleBottomFrame:yejiframe imgName:@"homepage_bottom_benefit" title:@"业绩分红"];
    [bodyView addSubview:self.yejiBtn];
    
    CGRect mingriframe=CGRectMake(CGRectGetMinX(self.baodanBtn.frame), CGRectGetMinY(self.yejiBtn.frame), CGRectGetWidth(self.baodanBtn.frame), CGRectGetHeight(self.yejiBtn.frame));
    self.mingriBtn = [self creatMiddleBottomFrame:mingriframe imgName:@"homepage_bottom_tomorrow" title:@"明日众购"];
    [bodyView addSubview:self.mingriBtn];
}

- (UIButton *)creatMiddleBottomFrame:(CGRect)frame imgName:(NSString *)imgName title:(NSString *)title
{
    UIButton *zhongchouBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    zhongchouBtn.frame = frame;
    zhongchouBtn.backgroundColor = [UIColor whiteColor];
    [zhongchouBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [zhongchouBtn setTitle:title forState:UIControlStateNormal];
    [zhongchouBtn setTitleColor:COLOR_RGB(145, 145, 145) forState:UIControlStateNormal];
    [zhongchouBtn pase_setImagePosition:PASEImagePositionTop spacing:20.];
    [zhongchouBtn addTarget:self action:@selector(clikTag:) forControlEvents:UIControlEventTouchUpInside];
    return zhongchouBtn;
}

-(void)clikTag:(UIButton *)snder
{
    if (snder==self.zhouchouBtn) //众筹平台
    {
        [ToolControl showHudWithResult:NO andTip:@"功能维护中"];
        return;
//        MingriZhonggouHomeVC *bouns=[[MingriZhonggouHomeVC alloc] init];
//        [self.navigationController pushViewController:bouns animated:YES];
    }if (snder==self.baodanBtn)//报单中心
    {
        DeclarationViewController *declar=[[DeclarationViewController alloc] init];
        [self.navigationController pushViewController:declar animated:YES];
        
    }
    if (snder==self.yejiBtn)//业绩分红
    {
        BonusViewController *bouns=[[BonusViewController alloc] init];
        [self.navigationController pushViewController:bouns animated:YES];
    }
    if (snder==self.mingriBtn)//明日众购
    {
        SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
        //设置代理请求为当前控制器本身
        storeProductViewContorller.delegate = self;
        //加载一个新的视图展示
        [storeProductViewContorller loadProductWithParameters:
         //appId唯一的
         @{SKStoreProductParameterITunesItemIdentifier : @"1223255345"} completionBlock:^(BOOL result, NSError *error) {
             //block回调
             if(error){
                 NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
             }else{
                 //模态弹出appstore
                 [self presentViewController:storeProductViewContorller animated:YES completion:^{
                     
                 }
                  ];
             }
         }];
        
    }

}

//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
