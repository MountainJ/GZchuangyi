//
//  RecommendViewController.m
//  NB2
//
//  Created by zcc on 16/6/14.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "RecommendViewController.h"
#import "SubordincsXiaViewController.h"
@interface RecommendViewController ()
{
    TopView *topView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
    int tempPage;
}

@end
@implementation RecommendViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //[self initTopView];
    tempPage=1;
    arrayData=[[NSMutableArray alloc] init];
    
    [self initTopView];
    [self initData];
    // Do any additional setup after loading the view.
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=[NSString stringWithFormat:@"%@(下属会员)",[self.diction objectForKey:@"user"]];
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}
-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",1],@"page",[NSString stringWithFormat:@"%@",[self.diction objectForKey:@"tid"]],@"tid",[NSString stringWithFormat:@"%d",10],@"num",nil];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestJiegou" params:dicton success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        @try
        {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            [workTableView stopLoadWithState:PullDownLoadState];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
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
    workTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:workTableView];
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
    
    return SCREEN_HEIGHT/14.2;
    
}

////tab每行的赋值
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    NSDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    CGSize moneyTextSize = [[NSString stringWithFormat:@"%@",[dictTable objectForKey:@"user"]] sizeWithFont:[UIFont systemFontOfSize:14]];
//    UILabel *tempL0=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, moneyTextSize.width, moneyTextSize.height)];
//    tempL0.text= [NSString stringWithFormat:@"%@",[dictTable objectForKey:@"user"]];
//    tempL0.textColor=[UIColor grayColor];
//    [tempL0 setFont:[UIFont systemFontOfSize:14]];
//    [cell addSubview:tempL0];
//
//    CGSize textSize = [@"姓名：" sizeWithFont:[UIFont systemFontOfSize:14]];
//    UILabel *tempL2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tempL0.frame)+2, 10, textSize.width, textSize.height)];
//    tempL2.textAlignment = NSTextAlignmentLeft;
//    tempL2.text=@"姓名：";
//    tempL2.adjustsFontSizeToFitWidth=YES;
//    [tempL2 setFont:[UIFont boldSystemFontOfSize:13]];
//    [tempL2 setTextColor:[UIColor grayColor]];
//    [cell addSubview:tempL2];
//
//    CGSize TextSize = [@"(普通会员)" sizeWithFont:[UIFont systemFontOfSize:14]];
//    UILabel *tempL1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tempL2.frame)+5, 10, TextSize.width, TextSize.height)];
//    tempL1.textColor=[UIColor colorWithWhite:0.5 alpha:1];
//    tempL1.text=@"(普通会员)";
//    [tempL1 setFont:[UIFont systemFontOfSize:14]];
//    [cell addSubview:tempL1];
//    if ([[dictTable objectForKey:@"num"] integerValue]>0) {
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    }else
//    {
//        cell.accessoryType=UITableViewCellAccessoryNone;
//    }
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
//    cell.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
//    return cell;
//}



//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGSize moneyTextSize = [[NSString stringWithFormat:@"%@",[dictTable objectForKey:@"user"]] sizeWithFont:[UIFont systemFontOfSize:14]];
    UILabel *tempL0=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, moneyTextSize.width, 47)];
    tempL0.text= [NSString stringWithFormat:@"%@",[dictTable objectForKey:@"user"]];
    tempL0.textColor=[UIColor grayColor];
    [tempL0 setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:tempL0];
    
    CGSize textSize = [[dictTable objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:14]];
    UILabel *tempL2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tempL0.frame)+5, 0, textSize.width, 47)];
    tempL2.textAlignment = NSTextAlignmentLeft;
    tempL2.text=[dictTable objectForKey:@"name"];
    tempL2.adjustsFontSizeToFitWidth=YES;
    [tempL2 setFont:[UIFont boldSystemFontOfSize:13]];
    [tempL2 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL2];
    
    CGSize TextSize = [[NSString stringWithFormat:@"(团队人数：%@)",[dictTable objectForKey:@"totel"]] sizeWithFont:[UIFont systemFontOfSize:14]];
    UILabel *tempL1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tempL2.frame)+5, 0, TextSize.width, 47)];
    tempL1.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    tempL1.text=[NSString stringWithFormat:@"(团队人数：%@)",[dictTable objectForKey:@"totel"]];
    [tempL1 setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:tempL1];
    
    if ([[dictTable objectForKey:@"num"] integerValue]>0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    cell.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
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
        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",tempPage],@"page",[NSString stringWithFormat:@"%@",[self.diction objectForKey:@"tid"]],@"tid",[NSString stringWithFormat:@"%d",10],@"num",nil];
        
        [SVProgressHUD showWithStatus:@"加载更多中..." maskType:SVProgressHUDMaskTypeBlack];
        
        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestJiegou" params:dicton success:^(NSDictionary *dict) {
            [SVProgressHUD dismiss];
            @try
            {
                
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
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        }];
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[[arrayData objectAtIndex:indexPath.row] objectForKey:@"num"] integerValue]>0)
    {
        SubordincsXiaViewController *subord=[[SubordincsXiaViewController alloc] init];
        subord.diction=[arrayData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:subord animated:YES];
        
    }
    
    
}
-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
