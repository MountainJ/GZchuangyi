//
//  RecordViewController.m
//  NB2
//
//  Created by zcc on 16/2/23.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordListViewController.h"
@interface RecordViewController ()
{
    TopView *topView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
    int sign;

}

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     sign=1;
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTopView];
    [self initData];
    
    // Do any additional setup after loading the view.
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"记录查询";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];

    NSArray *arraycolcor=[[NSArray alloc] initWithObjects:@"参与记录",@"红利记录", nil];
    for (int i=0; i<arraycolcor.count; i++)
    {
        UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
        but.frame=CGRectMake(SCREEN_WIDTH/2.0*i, CGRectGetMaxY(topView.frame), SCREEN_WIDTH/2.0, 40);
        but.tag=100+i;
        [but addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
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
    }
    
}
-(void)clickBut:(UIButton *)sender
{
    
//    RecordListViewController *recordlist=[[RecordListViewController alloc] init];
//
    if (sender.tag==100)
    {
        sender.selected=YES;
        UIButton *but1=[self.view viewWithTag:101];
        but1.selected=NO;
        //[self initData];
        sign=1;
//        recordlist.sign=100;
//        recordlist.strtitle=@"帮助记录";
        
    }else
    {
        sender.selected=YES;
        UIButton *but1=[self.view viewWithTag:100];
        but1.selected=NO;
        
        sign=2;
//        recordlist.sign=101;
//        recordlist.strtitle=@"求助记录";
    }
    [workTableView removeFromSuperview];
    workTableView=nil;
    [self initData];
//    [self.navigationController pushViewController:recordlist animated:YES];

}
-(void)initData
{
//    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",1],@"page",[NSString stringWithFormat:@"%d",sign],@"type",[NSString stringWithFormat:@"%d",10],@"num",nil];
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",1],@"page",[NSString stringWithFormat:@"%d",sign],@"type",[NSString stringWithFormat:@"%d",10],@"num",@"1",@"test",nil];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestofferlist" params:dicton success:^(NSDictionary *dict) {
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
    workTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,topView.frame.origin.y+topView.frame.size.height+45 ,SCREEN_WIDTH ,SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-45)];
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
    
    if (@available(iOS 11.0, *)) {
        workTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if ([arrayData count]>10)
    {
        [ConvertValue scrollTableToNum:NO :10 :workTableView];
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
    
    return 105;
    
}

-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
    
    UILabel *tempL0=[[UILabel alloc]initWithFrame:CGRectMake(5, 3, SCREEN_WIDTH*0.5, 34)];
    tempL0.text= [NSString stringWithFormat:@"订单号：%@",[dictTable objectForKey:@"orderid"]];
    tempL0.textColor=[UIColor grayColor];
    [tempL0 setFont:[UIFont systemFontOfSize:14]];
    tempL0.numberOfLines=2;
    [cell addSubview:tempL0];
    
    UILabel *tempL1=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL0.frame) + 4, SCREEN_WIDTH*0.5, 15)];
    tempL1.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    tempL1.text= [dictTable objectForKey:@"shijian"];
    [tempL1 setFont:[UIFont systemFontOfSize:12]];
    [cell addSubview:tempL1];
    
    NSString *djshijian = [dictTable objectForKey:@"djshijian"];
    if (djshijian.length != 0) {
        UILabel *tempL10=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL1.frame) + 2, SCREEN_WIDTH*0.5, 15)];
        tempL10.textColor=[UIColor colorWithWhite:0.5 alpha:1];
        tempL10.text= [NSString stringWithFormat:@"冻结日期：%@",djshijian];
        [tempL10 setFont:[UIFont systemFontOfSize:12]];
        [cell addSubview:tempL10];
    }
    
    
    UILabel *tempL2=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL1.frame)+18, SCREEN_WIDTH*0.2, 20)];
    tempL2.textAlignment = NSTextAlignmentLeft;
    tempL2.text=@"匹配人数 ";
    tempL2.adjustsFontSizeToFitWidth=YES;
    [tempL2 setFont:[UIFont boldSystemFontOfSize:13]];
    [tempL2 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL2];
    
    UILabel *tempL22=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tempL2.frame), CGRectGetMaxY(tempL1.frame)+18, SCREEN_WIDTH*0.2, 20)];
    tempL22.textAlignment = NSTextAlignmentLeft;
    tempL22.text=[NSString stringWithFormat:@"%@人",[dictTable objectForKey:@"renshu"]];
    [tempL22 setFont:[UIFont systemFontOfSize:14]];
    tempL22.textColor=[UIColor orangeColor];
    [cell addSubview:tempL22];
    
    //金额
    UILabel *tempL3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+5, 5, SCREEN_WIDTH*0.4, 20)];
    tempL3.textAlignment = NSTextAlignmentLeft;
    if(sign==2)
    {
        tempL3.text=@"求助金额：";
    }else
    {
        tempL3.text=@"帮助金额：";
    }
    [tempL3 setFont:[UIFont systemFontOfSize:12]];
    [tempL3 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL3];
    
    //金额
    UILabel *tempL4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+5, CGRectGetMaxY(tempL3.frame), SCREEN_WIDTH*0.45, 20)];
    tempL4.textAlignment = NSTextAlignmentLeft;
    tempL4.textColor=[UIColor orangeColor];
    tempL4.text=[NSString stringWithFormat:@"%@元",[dictTable objectForKey:@"jine"]];
    [tempL4 setFont:[UIFont systemFontOfSize:12]];
    [cell addSubview:tempL4];
    
    //金额
    UILabel *tempL5=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+5, CGRectGetMaxY(tempL4.frame)+5, SCREEN_WIDTH*0.4, 18)];
    tempL5.textAlignment = NSTextAlignmentLeft;
    tempL5.text=@"剩余金额：";
    [tempL5 setFont:[UIFont systemFontOfSize:12]];
    [tempL5 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL5];
    
    //金额
    UILabel *tempL6=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+5, CGRectGetMaxY(tempL5.frame), SCREEN_WIDTH*0.4, 20)];
    tempL6.textAlignment = NSTextAlignmentLeft;
    tempL6.text=[NSString stringWithFormat:@"%@元",[dictTable objectForKey:@"shengyu"]];
    [tempL6 setFont:[UIFont boldSystemFontOfSize:14]];
    tempL6.adjustsFontSizeToFitWidth=YES;
    tempL6.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
    [cell addSubview:tempL6];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,100 , SCREEN_WIDTH, 5)];
    view.backgroundColor=[UIColor whiteColor];
    [cell addSubview:view];
    
    
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 40)];
    imgview.backgroundColor=[UIColor clearColor];
    //station
    //0排队中
    //1匹配中
    //2付款中
    //3未付款
    //4冻结期
    //5完成
    //6废单
    //7拒绝付款
    //9  已转股
    //10 冻结中
    //11转理财
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
        
    }else if ([[dictTable objectForKey:@"station"] integerValue]==9)
    {
        imgview.image=[UIImage imageNamed:@"ic_station_9"];
        
    }
    else if ([[dictTable objectForKey:@"station"] integerValue]==10)
    {
        imgview.image=[UIImage imageNamed:@"ic_station_10"];
        
    }
    else if ([[dictTable objectForKey:@"station"] integerValue]==11)
    {
        imgview.image=[UIImage imageNamed:@"ic_station_11"];
    }
    
    NSString *zhouqi = [dictTable objectForKey:@"zhouqi"];
    if (zhouqi.length > 0) {
        UILabel *zhouqiLbl=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 55, CGRectGetMaxY(tempL5.frame), 45, 24)];
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
    
    

    [cell addSubview:imgview];
    
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
//        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",tempPage],@"page",[NSString stringWithFormat:@"%d",10],@"num",[NSString stringWithFormat:@"%d",sign],@"type",nil];
        
        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",tempPage],@"page",[NSString stringWithFormat:@"%d",10],@"num",[NSString stringWithFormat:@"%d",sign],@"type",@"1",@"test",nil];

        [SVProgressHUD showWithStatus:@"加载更多中..." maskType:SVProgressHUDMaskTypeBlack];;
        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestofferlist" params:dicton success:^(NSDictionary *dict) {
            @try
            {
                [SVProgressHUD dismiss];
                [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
                [workTableView stopLoadWithState:PullUpLoadState];
                if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
                {
                    NSMutableArray *newarray=[NSMutableArray arrayWithArray:arrayData];
                    [newarray addObjectsFromArray:[dict objectForKey:@"result"]];
                    [arrayData removeAllObjects];
                    [arrayData addObjectsFromArray:newarray];
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
     NSDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
    if ([[dictTable objectForKey:@"station"] integerValue]==0)
    {
        [ToolControl showHudWithResult:NO andTip:@"排队中"];
        return;
    }
//修改2018.2.1 jay，需要支持点击可查看匹配中的...
//    else if ([[dictTable objectForKey:@"station"] integerValue]==1)
//    {
//        [ToolControl showHudWithResult:NO andTip:@"匹配中"];
//        return;
//    }
    RecordListViewController *recordlist=[[RecordListViewController alloc] init];
    recordlist.changeBlock = ^{
        [self initData];
    };
    NSDictionary *diction=[arrayData objectAtIndex:indexPath.row];
    if (sign==1)
    {
        recordlist.sign=100;
        recordlist.strtitle=@"参与记录";
        
    }else
    {
        recordlist.sign=101;
        recordlist.strtitle=@"红利记录";
    }
    recordlist.diction=diction;
    [self.navigationController pushViewController:recordlist animated:YES];
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
