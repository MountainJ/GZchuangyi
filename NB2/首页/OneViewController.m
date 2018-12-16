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

@interface OneViewController ()<SKStoreProductViewControllerDelegate>
{
    UIImageView *bodyView;
    UITextField *nameTF;
}

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
    UIView *barView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20+JF_TOP_ACTIVE_SPACE)];
//    barView.backgroundColor=[UIColor colorWithRed:5/255.0 green:104.0/255 blue:155.0/255 alpha:1];
    barView.backgroundColor = COLOR_STATUS_NAV_BAR_BACK;
    [self.view addSubview:barView];
    //主view
    bodyView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20+JF_TOP_ACTIVE_SPACE, SCREEN_WIDTH, SCREEN_HEIGHT-20-JF_TOP_ACTIVE_SPACE-HEIGHT_MENU_VIEW)];
    bodyView.backgroundColor=[UIColor whiteColor];
    bodyView.userInteractionEnabled=YES;
    [self.view addSubview:bodyView];
    [self initTopview];
    
}
-(void)initTopview
{
    UIImageView *naview=[[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,SCREEN_WIDTH, NAV_BAR_HEIGHT)];
    naview.backgroundColor = COLOR_STATUS_NAV_BAR_BACK;
    UIImageView *titleview=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-35)/2.0, 3, 35, 40)];
    titleview.image=[UIImage imageNamed:@"标题栏LOGO"];
    [naview addSubview:titleview];
    [bodyView addSubview:naview];
    
    //轮播的图片
    UIImageView *lunimgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(naview.frame), SCREEN_WIDTH, SCREEN_HEIGHT*0.25)];
    lunimgview.image=[UIImage imageNamed:@"index"];
    
//    UILabel *lableText=[[UILabel alloc] initWithFrame:CGRectMake(15,SCREEN_HEIGHT*0.12 ,SCREEN_WIDTH*0.3 ,25)];
//    lableText.text=@"公益众筹";
//    lableText.font=[UIFont boldSystemFontOfSize:18];
//    lableText.textColor=[UIColor whiteColor];
//    [lunimgview addSubview:lableText];
//    
//    UILabel *lableText1=[[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(lableText.frame) ,SCREEN_WIDTH*0.45 ,18 )];
//    lableText1.text=@"我们一起托起明日之星";
//    lableText1.font=[UIFont systemFontOfSize:14];
//    lableText1.textColor=[UIColor whiteColor];
//    [lunimgview addSubview:lableText1];
//    
//    UILabel *lableText2=[[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(lableText1.frame) ,SCREEN_WIDTH*0.65 ,18 )];
//    lableText2.text=@"我们共同沐浴明日之星的光芒！";
//    lableText2.font=[UIFont systemFontOfSize:14];
//    lableText2.textColor=[UIColor whiteColor];
//    [lunimgview addSubview:lableText2];
//    
    [bodyView addSubview:lunimgview];
    
    UIView *middeleView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lunimgview.frame), SCREEN_WIDTH, SCREEN_HEIGHT/11.116)];
    middeleView.backgroundColor=[UIColor colorWithRed:5.0/255 green:96.0/255 blue:139.0/255 alpha:1];
    [bodyView addSubview:middeleView];
    NSArray *array=[[NSArray alloc] initWithObjects:@"众筹参与",@"众筹红利",@"记录查询", nil];
    NSArray *arrays=[[NSArray alloc] initWithObjects:@"Public participation",@"All chips bonus",@"To match", nil];
    for (int i=0; i<3; i++)
    {
        UIButton *but=[UIButton buttonWithType: UIButtonTypeCustom];
        but.showsTouchWhenHighlighted=YES;
        but.frame=CGRectMake(i*SCREEN_WIDTH/3.0, 0, SCREEN_WIDTH/3.0, SCREEN_HEIGHT/11.116);
        but.tag=400+i;
        [but addTarget:self action:@selector(clickhelp:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *labletitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH/3.0, but.frame.size.height/3.0)];
        labletitle.textAlignment=NSTextAlignmentCenter;
        labletitle.textColor=[UIColor whiteColor];
        labletitle.text=[array objectAtIndex:i];
        labletitle.font=[UIFont systemFontOfSize:13];
        [but addSubview:labletitle];
        UILabel *labletitles=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labletitle.frame), SCREEN_WIDTH/3.0, but.frame.size.height/3.0)];
        labletitles.textColor=[UIColor whiteColor];
        labletitles.adjustsFontSizeToFitWidth = YES;
        labletitles.text=[arrays objectAtIndex:i];
        labletitles.textAlignment=NSTextAlignmentCenter;
        labletitles.font=[UIFont systemFontOfSize:13];
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
        declar.indexsign=sender.tag;
        [self.navigationController pushViewController:declar animated:YES];

    }else
    {
        RecordViewController *record=[[RecordViewController alloc] init];
        [self.navigationController pushViewController:record animated:YES];
    }
}
-(void)initFoot:(UIView *)senderview
{
    UIImageView *naview=[[UIImageView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(senderview.frame) , SCREEN_WIDTH, SCREEN_HEIGHT/13.896)];
    naview.backgroundColor=[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
    naview.userInteractionEnabled=YES;
    [bodyView addSubview:naview];
    
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.1, 5,SCREEN_WIDTH*0.8,SCREEN_HEIGHT/17.55)];
    [nameTF setPlaceholder:@" 请输入查询内容"];
    [nameTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
    nameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
    nameTF.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    nameTF.returnKeyType =UIReturnKeyDone;
    nameTF.delegate = self;
    nameTF.textColor=[UIColor grayColor];
    nameTF.layer.masksToBounds=YES;
    nameTF.layer.cornerRadius=5;
    nameTF.backgroundColor=[UIColor whiteColor];
    [nameTF setFont:[UIFont systemFontOfSize:15]];
    [naview addSubview:nameTF];
    
    UIButton *shoubut=[UIButton buttonWithType:UIButtonTypeCustom];
    shoubut.frame=CGRectMake(nameTF.frame.size.width-SCREEN_WIDTH/9.868, 0, SCREEN_WIDTH/9.868, SCREEN_HEIGHT/17.55);
    [shoubut setBackgroundImage:[UIImage imageNamed:@"shousuo"] forState:UIControlStateNormal];
    [nameTF addSubview:shoubut];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake((SCREEN_WIDTH/2.0-60)/2.0, CGRectGetMaxY(naview.frame)+SCREEN_HEIGHT/22.233, SCREEN_WIDTH/6.25, SCREEN_HEIGHT/11.116);
    [button setBackgroundImage:[UIImage imageNamed:@"匹配中心"] forState:UIControlStateNormal];
    button.tag=2;
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame)+button.frame.size.height/12, SCREEN_WIDTH/2.0, button.frame.size.height/2.0)];
    title.text=@"众筹平台";
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=[UIColor grayColor];
    [button addTarget:self action:@selector(clikTag:) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:button];
    [bodyView addSubview:title];
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(SCREEN_WIDTH/2.0+(SCREEN_WIDTH/2.0-60)/2.0, CGRectGetMaxY(naview.frame)+SCREEN_HEIGHT/22.233, SCREEN_WIDTH/6.25, SCREEN_HEIGHT/11.116);
    [button1 setBackgroundImage:[UIImage imageNamed:@"报单中心"] forState:UIControlStateNormal];
    button1.tag=3;
    [button1 addTarget:self action:@selector(clikTag:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *title1=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, CGRectGetMaxY(button1.frame)+button.frame.size.height/12, SCREEN_WIDTH/2.0, button.frame.size.height/2.0)];
    title1.text=@"报单中心";
    title1.textAlignment=NSTextAlignmentCenter;
    title1.textColor=[UIColor grayColor];
    [bodyView addSubview:button1];
    [bodyView addSubview:title1];
    
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake((SCREEN_WIDTH/2.0-60)/2.0, CGRectGetMaxY(title1.frame)+button.frame.size.height/3.0, SCREEN_WIDTH/6.25, SCREEN_HEIGHT/11.116);
    [button2 addTarget:self action:@selector(clikTag:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag=4;
    [button2 setBackgroundImage:[UIImage imageNamed:@"奖金业绩"] forState:UIControlStateNormal];
    UILabel *title2=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button2.frame)+button.frame.size.height/12, SCREEN_WIDTH/2.0, button.frame.size.height/2.0)];
    title2.text=@"业绩分红";
    title2.textAlignment=NSTextAlignmentCenter;
    title2.textColor=[UIColor grayColor];
    [bodyView addSubview:button2];
    [bodyView addSubview:title2];

    
    UIButton *button3=[UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame=CGRectMake(SCREEN_WIDTH/2.0+(SCREEN_WIDTH/2.0-60)/2.0, CGRectGetMaxY(title1.frame)+button.frame.size.height/3.0, SCREEN_WIDTH/6.25, SCREEN_HEIGHT/11.116);
    [button3 setBackgroundImage:[UIImage imageNamed:@"明日众购"] forState:UIControlStateNormal];
    button3.tag=5;
    [button3 addTarget:self action:@selector(clikTag:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *title3=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, CGRectGetMaxY(button3.frame)+button.frame.size.height/12, SCREEN_WIDTH/2.0, button.frame.size.height/2.0)];
    title3.text=@"明日众购";
    title3.textAlignment=NSTextAlignmentCenter;
    title3.textColor=[UIColor grayColor];
    [bodyView addSubview:button3];
    [bodyView addSubview:title3];


}
-(void)clikTag:(UIButton *)snder
{
    if (snder.tag==2) //匹配中心
    {
//        MarryConrtolViewController *declar=[[MarryConrtolViewController alloc] init];
//        [self.navigationController pushViewController:declar animated:YES];
        MingriZhonggouHomeVC *bouns=[[MingriZhonggouHomeVC alloc] init];
        [self.navigationController pushViewController:bouns animated:YES];
        
        
    }if (snder.tag==3)//报单中心
    {
        DeclarationViewController *declar=[[DeclarationViewController alloc] init];
        [self.navigationController pushViewController:declar animated:YES];
        
    }
    if (snder.tag==4)//业绩分红
    {
        BonusViewController *bouns=[[BonusViewController alloc] init];
        [self.navigationController pushViewController:bouns animated:YES];
    }
    if (snder.tag==5)//明日众购
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
