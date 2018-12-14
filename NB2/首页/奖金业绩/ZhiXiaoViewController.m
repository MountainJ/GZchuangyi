//
//  ZhiXiaoViewController.m
//  NB2
//
//  Created by ZhiBin Zou on 16/5/2.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "ZhiXiaoViewController.h"
#import "DetailsViewController.h"
#import "PopoverView.h"
@interface ZhiXiaoViewController ()
{
    UITableView *workTableView;
    TopView *topView;
    NSMutableArray *arrayData;
    long sign;
    long type;
}

@end

@implementation ZhiXiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopView];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initData];
    // Do any additional setup after loading the view.
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"直推动态";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, CGRectGetMaxY(topView.frame),SCREEN_WIDTH/2.0-1 , 30)];
    [button setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1]];
    [button setTitle:@"全部" forState:UIControlStateNormal];
    button.tag=300;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(SCREEN_WIDTH/2.0, CGRectGetMaxY(topView.frame),SCREEN_WIDTH/2.0 , 30)];
    [button2 setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1]];
    [button2 setTitle:@"全部" forState:UIControlStateNormal];
    button.tag=301;
    [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button2.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

-(void)button1Clicked:(UIButton *)sender
{
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
    NSArray *titles = @[@"全部", @"众筹参与", @"众筹红利"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        NSLog(@"select index:%ld", (long)index);

        type=index;
        [sender setTitle:[titles objectAtIndex:index] forState:UIControlStateNormal];
        [self initData];
    };
    [pop show];
}

-(void)button2Clicked:(UIButton *)sender
{
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
    NSArray *titles = @[@"全部", @"排队中", @"匹配中",@"付款中", @"冻结中", @"已完成"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        NSLog(@"select index:%ld", (long)index);
        
        sign=index;
        [sender setTitle:[titles objectAtIndex:index] forState:UIControlStateNormal];
        [self initData];
    };
    [pop show];
}
-(void)initData
{
    
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",1],@"page",[NSString stringWithFormat:@"%d",10],@"num",nil];
    
    if (type==1) {
        [dicton setObject:@"1" forKey:@"type"];
    }else if (type==2)
    {
        [dicton setObject:@"2" forKey:@"type"];
    }
    if(sign==1)
    {
        [dicton setObject:[NSString stringWithFormat:@"%ld",sign-1] forKey:@"station"];
    }
    else if(sign==2)
    {
        [dicton setObject:[NSString stringWithFormat:@"%ld",sign-1] forKey:@"station"];
    }
    else if(sign==3)
    {
        [dicton setObject:[NSString stringWithFormat:@"%ld",sign-1] forKey:@"station"];
    }
    else if(sign==4)
    {
        [dicton setObject:[NSString stringWithFormat:@"%ld",sign] forKey:@"station"];
    }
    else if(sign==5)
    {
        [dicton setObject:[NSString stringWithFormat:@"%ld",sign] forKey:@"station"];
    }
    NSLog(@"%@",dicton);
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestZhitui" params:dicton success:^(NSDictionary *dict) {
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
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
    
    
}
-(void)initUI
{
    [workTableView removeFromSuperview];
    workTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,topView.frame.origin.y+topView.frame.size.height+31 ,SCREEN_WIDTH ,SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-31)];
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
    
    return 94;
    
}

-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *tempL0=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH*0.5, 20)];
    tempL0.text= [NSString stringWithFormat:@"第%@号",[dictTable objectForKey:@"orderid"]];
    tempL0.textColor=[UIColor grayColor];
    [tempL0 setFont:[UIFont systemFontOfSize:14]];
    tempL0.adjustsFontSizeToFitWidth=YES;
    [cell addSubview:tempL0];
    
    UILabel *tempL1=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL0.frame)+30, SCREEN_WIDTH*0.5, 20)];
    tempL1.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    tempL1.text= [dictTable objectForKey:@"shijian"];
    [tempL1 setFont:[UIFont systemFontOfSize:12]];
    [cell addSubview:tempL1];
    
    
    //金额
    UILabel *tempL3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+15, 5, SCREEN_WIDTH*0.4, 20)];
    tempL3.textAlignment = NSTextAlignmentLeft;
    tempL3.text=@"金额：";
    [tempL3 setFont:[UIFont systemFontOfSize:12]];
    [tempL3 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL3];
    
    //金额
    UILabel *tempL4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+15, CGRectGetMaxY(tempL3.frame), SCREEN_WIDTH*0.4, 20)];
    tempL4.textAlignment = NSTextAlignmentLeft;
    tempL4.textColor=[UIColor orangeColor];
    tempL4.text=[NSString stringWithFormat:@"%@元",[dictTable objectForKey:@"jine"]];
    [tempL4 setFont:[UIFont systemFontOfSize:12]];
    [cell addSubview:tempL4];
    
    //金额
    UILabel *tempL5=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+15, CGRectGetMaxY(tempL4.frame)+5, SCREEN_WIDTH*0.4, 18)];
    tempL5.textAlignment = NSTextAlignmentLeft;
    tempL5.text=@"姓名：";
    [tempL5 setFont:[UIFont systemFontOfSize:12]];
    [tempL5 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL5];
    
    //金额
    UILabel *tempL6=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+15, CGRectGetMaxY(tempL5.frame), SCREEN_WIDTH*0.4, 20)];
    tempL6.textAlignment = NSTextAlignmentLeft;
     tempL6.text=[NSString stringWithFormat:@"%@",[dictTable objectForKey:@"name"]];
    
    [tempL6 setFont:[UIFont boldSystemFontOfSize:14]];
    tempL6.adjustsFontSizeToFitWidth=YES;
    tempL6.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
    [cell addSubview:tempL6];
    
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 40)];
    [cell addSubview:imgview];
    if ([[dictTable objectForKey:@"station"] integerValue]==0)
    {
        imgview.image=[UIImage imageNamed:@"waiting"];
        
    }else if ([[dictTable objectForKey:@"station"] integerValue]==1)
    {
        imgview.image=[UIImage imageNamed:@"pipei"];
        
    }
    else if ([[dictTable objectForKey:@"station"] integerValue]==2)
    {
        imgview.image=[UIImage imageNamed:@"fukaunzhong"];
        
    }
    else if ([[dictTable objectForKey:@"station"] integerValue]==3)
    {
        imgview.image=[UIImage imageNamed:@"weipay"];
        
    }
    else if ([[dictTable objectForKey:@"station"] integerValue]==4)
    {
        imgview.image=[UIImage imageNamed:@"dongjie"];
        
    }
    else if ([[dictTable objectForKey:@"station"] integerValue]==5)
    {
        imgview.image=[UIImage imageNamed:@"finish"];
        
    }
    
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,94-5 , SCREEN_WIDTH, 5)];
    view.backgroundColor=[UIColor whiteColor];
    [cell addSubview:view];
    
    NSString *zhouqi = [dictTable objectForKey:@"zhouqi"];
    if (zhouqi.length > 0) {
        UILabel *zhouqiLbl=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 55, CGRectGetMaxY(tempL5.frame) - 10, 45, 24)];
        zhouqiLbl.textAlignment = NSTextAlignmentCenter;
        zhouqiLbl.text=[NSString stringWithFormat:@"%@天",zhouqi];
        [zhouqiLbl setFont:[UIFont boldSystemFontOfSize:12]];
        zhouqiLbl.layer.masksToBounds = YES;
        zhouqiLbl.layer.cornerRadius = 12;
        zhouqiLbl.textColor = [UIColor whiteColor];
        zhouqiLbl.adjustsFontSizeToFitWidth=YES;
        zhouqiLbl.backgroundColor=[UIColor colorWithRed:24/255.0 green:146/255.0 blue:209/255.0 alpha:1];
        [cell addSubview:zhouqiLbl];
    }
    
    
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
        int tempPage=[ConvertValue getPageNum:[arrayData count] :10];
        if (tempPage<=0) {
            
            [ToolControl showHudWithResult:NO andTip:@"暂无更多数据！"];
            [workTableView stopLoadWithState:PullUpLoadState];
            return;
        }
        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",tempPage],@"page",[NSString stringWithFormat:@"%d",10],@"num",nil];
        
        if (type==1) {
            [dicton setObject:@"1" forKey:@"type"];
        }else if (type==2)
        {
            [dicton setObject:@"2" forKey:@"type"];
        }
        if(sign==1)
        {
            [dicton setObject:[NSString stringWithFormat:@"%ld",sign-1] forKey:@"station"];
        }
        else if(sign==2)
        {
            [dicton setObject:[NSString stringWithFormat:@"%ld",sign-1] forKey:@"station"];
        }
        else if(sign==3)
        {
            [dicton setObject:[NSString stringWithFormat:@"%ld",sign-1] forKey:@"station"];
        }
        else if(sign==4)
        {
            [dicton setObject:[NSString stringWithFormat:@"%ld",sign] forKey:@"station"];
        }
        else if(sign==5)
        {
            [dicton setObject:[NSString stringWithFormat:@"%ld",sign] forKey:@"station"];
        }

        
        [SVProgressHUD showWithStatus:@"加载更多中..." maskType:SVProgressHUDMaskTypeBlack];
        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestZhitui" params:dicton success:^(NSDictionary *dict) {
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
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        }];
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailsViewController *detalis=[[DetailsViewController alloc] init];
    detalis.sign=103;
    detalis.namestring=@"直推动态";
    NSMutableDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
    detalis.diction=dictTable;
    [self.navigationController pushViewController:detalis animated:YES];
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
