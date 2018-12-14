//
//  NumberListViewController.m
//  NB2
//
//  Created by zcc on 16/9/27.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "NumberListViewController.h"
@interface NumberListViewController ()
{
    TopView *topView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
    int tempPage;
}
@end
@implementation NumberListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    tempPage=1;
    arrayData=[[NSMutableArray alloc] init];
    [self initTopView];
    [self initData];
// Do any additional setup after loading the view.
}

-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"转让记录";
    topView.imgLeft=@"back_btn_n";
    //topView.imgRight=@"more";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
    
}
-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",1],@"page",[NSString stringWithFormat:@"%d",10],@"num",nil];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestZrjhmjl" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            [workTableView stopLoadWithState:PullDownLoadState];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                //[arrayData removeAllObjects];
                arrayData=[[dict objectForKey:@"result"] mutableCopy];
                [self initUI];
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
    }];
    
    
}
-(void)initUI
{
    [workTableView removeFromSuperview];
    workTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,topView.frame.origin.y+topView.frame.size.height+5 ,SCREEN_WIDTH ,SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-5)];
    workTableView.backgroundColor = [UIColor clearColor];
    workTableView.delegate = self;
    workTableView.dataSource = self;
    workTableView.tableFooterView=[[UIView alloc] init];
    workTableView.scrollEnabled=YES;
    workTableView.pullDelegate = self;
    workTableView.canPullUp = YES;
    workTableView.canPullDown=YES;
    workTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:workTableView];
    if ([arrayData count]>10)
    {
        [ConvertValue scrollTableToNum:YES :10 :workTableView];
    }
}
#pragma mark - TableView
//tab数量1
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//tab一页多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayData.count;
}
//tab每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 113;
    
}

//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
    
    UILabel *tempL0=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH*0.5, 20)];
    tempL0.text= @"时间：";
    tempL0.textColor=[UIColor grayColor];
    [tempL0 setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:tempL0];
    
    UILabel *tempL1=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL0.frame), SCREEN_WIDTH*0.5, 20)];
    tempL1.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    tempL1.text= [dictTable objectForKey:@"shijian"];
    [tempL1 setFont:[UIFont systemFontOfSize:13]];
    [cell addSubview:tempL1];
    
    
    UILabel *tempL2=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL1.frame)+20, SCREEN_WIDTH*0.15, 20)];
    tempL2.textAlignment = NSTextAlignmentLeft;
    tempL2.text=@"会员名：";
    tempL2.adjustsFontSizeToFitWidth=YES;
    [tempL2 setFont:[UIFont boldSystemFontOfSize:14]];
    [tempL2 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL2];
    
    UILabel *tempL22=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tempL2.frame), CGRectGetMaxY(tempL1.frame)+20, SCREEN_WIDTH*0.25, 20)];
    tempL22.textAlignment = NSTextAlignmentLeft;
    tempL22.text=[dictTable objectForKey:@"user"];
    [tempL22 setFont:[UIFont systemFontOfSize:14]];
    tempL22.adjustsFontSizeToFitWidth=YES;
    [tempL22 setTextColor:[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1]];
    [cell addSubview:tempL22];
    
    //金额
    UILabel *tempL3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.55, 5, SCREEN_WIDTH*0.4, 20)];
    tempL3.textAlignment = NSTextAlignmentLeft;
    tempL3.text=@"转让用户：";
    [tempL3 setFont:[UIFont systemFontOfSize:14]];
    [tempL3 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL3];
    
    //金额
    UILabel *tempL4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.55, CGRectGetMaxY(tempL3.frame), SCREEN_WIDTH*0.46, 30)];
    tempL4.textAlignment = NSTextAlignmentLeft;
    tempL4.text=[NSString stringWithFormat:@"%@",[dictTable objectForKey:@"zhuanranguser"]];
    [tempL4 setFont:[UIFont systemFontOfSize:14]];
    tempL4.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
    [cell addSubview:tempL4];
    
    //金额
    UILabel *tempL5=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.55, CGRectGetMaxY(tempL4.frame), SCREEN_WIDTH*0.4, 18)];
    tempL5.textAlignment = NSTextAlignmentLeft;
    tempL5.text=@"数量：";
    [tempL5 setFont:[UIFont systemFontOfSize:14]];
    [tempL5 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL5];
    
    //金额
    UILabel *tempL6=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.55, CGRectGetMaxY(tempL5.frame), SCREEN_WIDTH*0.45, 30)];
    tempL6.textAlignment = NSTextAlignmentLeft;
    tempL6.text=[dictTable objectForKey:@"num"];
    [tempL6 setFont:[UIFont boldSystemFontOfSize:14]];
    //tempL6.adjustsFontSizeToFitWidth=YES;
    tempL6.numberOfLines=2;
    tempL6.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
    [cell addSubview:tempL6];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,113-5 , SCREEN_WIDTH, 5)];
    view.backgroundColor=[UIColor whiteColor];
    [cell addSubview:view];
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    cell.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1];
    return cell;
}
- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state
{
    if (state == PullDownLoadState)
    {
        [self initData];
    }
    else//加载更多
    {
        tempPage=[ConvertValue getPageNum:[arrayData count] :10];
        if (tempPage<=0) {
            
            [ToolControl showHudWithResult:NO andTip:@"暂无更多数据！"];
            [workTableView stopLoadWithState:PullUpLoadState];
            return;
        }
        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",tempPage],@"page",[NSString stringWithFormat:@"%d",10],@"num",nil];
    
        [SVProgressHUD showWithStatus:@"加载更多中..." maskType:SVProgressHUDMaskTypeBlack];
        //        NSMutableString *post2 = nil;
        //        post2=[HttpTool getDataString:dicton];
        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestZrjhmjl" params:dicton success:^(NSDictionary *dict) {
            @try
            {
                [SVProgressHUD dismiss];
                [workTableView stopLoadWithState:PullUpLoadState];
                
                if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
                {
                    NSMutableArray *newarray=[NSMutableArray arrayWithArray:arrayData];
                    [newarray addObjectsFromArray:[dict objectForKey:@"result"]];
                    arrayData=newarray;
                    [self initUI];
                    
                }
                [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
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
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
