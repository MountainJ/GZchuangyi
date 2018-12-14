//
//  MeilDetailsViewController.m
//  NB2
//
//  Created by zcc on 16/3/11.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "MeilDetailsViewController.h"

@implementation MeilDetailsViewController
{
    TopView *topView;
    NSMutableArray *arrayData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTopView];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
}
-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%@",self.meilid],@"tid",nil];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSMutableString *post2 = nil;
    post2=[HttpTool getDataString:dicton];
    [HttpTool myPostWithBaseURL:kBaseURL path:@"/api/requestEmaildetail"
                         params:post2
                        success:^(NSDictionary *dict)
     {
         [SVProgressHUD dismiss];
         [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
         if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
         {
             arrayData=[dict objectForKey:@"result"];
             [self initUI];
             
         }
         NSLog(@"%@",dict);
     } failure:^(NSError *error)
     {
         [SVProgressHUD dismiss];
         [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
     }];

}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"邮件详情";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
}
-(void)initUI
{
    UILabel *titile=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.1, CGRectGetMaxY(topView.frame), SCREEN_WIDTH*0.8, 45)];
    titile.numberOfLines=2;
    titile.font=[UIFont boldSystemFontOfSize:14];
    titile.text=[[arrayData objectAtIndex:0] objectForKey:@"title"];
    [self.view addSubview:titile];
    
    UILabel *titileName=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.1, CGRectGetMaxY(titile.frame), SCREEN_WIDTH*0.8, 25)];
    titileName.numberOfLines=2;
    titileName.font=[UIFont systemFontOfSize:13];
    titileName.textColor=[UIColor grayColor];
    titileName.text=[[arrayData objectAtIndex:0] objectForKey:@"fa"];
    [self.view addSubview:titileName];
    
    UILabel *titileTime=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.1, CGRectGetMaxY(titileName.frame), SCREEN_WIDTH*0.8, 25)];
    titileTime.font=[UIFont systemFontOfSize:13];
    titileTime.textColor=[UIColor grayColor];
    titileTime.text=[[arrayData objectAtIndex:0] objectForKey:@"shijian"];
    [self.view addSubview:titileTime];
    
    UIView *geview=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titileTime.frame)+20, SCREEN_WIDTH, 1)];
    geview.backgroundColor=[UIColor grayColor];
    [self.view addSubview:geview];
    
    UILabel *titileContent=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.1, CGRectGetMaxY(geview.frame)+20, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.3)];
    titileContent.font=[UIFont boldSystemFontOfSize:14];
    titileContent.textColor=[UIColor grayColor];
    titileContent.text=[[arrayData objectAtIndex:0] objectForKey:@"content"];
    [self.view addSubview:titileContent];
    

}
-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
