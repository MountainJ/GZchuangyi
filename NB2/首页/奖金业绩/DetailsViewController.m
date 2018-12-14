//
//  DetailsViewController.m
//  NB2
//
//  Created by zcc on 16/2/20.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
{
    TopView *topView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
    NSMutableArray *array1;
    NSMutableArray *array2;
    NSMutableArray *array3;
    NSMutableArray *array4;
    
}
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initTopView];
    if (self.sign==100)
    {
        arrayData=[[NSMutableArray alloc] initWithObjects:@"用户名：",@"金额：",@"收益：", nil];
        array1=[[NSMutableArray alloc] initWithObjects:[self.diction objectForKey:@"user"],[NSString stringWithFormat:@"%@元",[self.diction objectForKey:@"jine"]],[NSString stringWithFormat:@"%@元",[self.diction objectForKey:@"shouyi"]], nil];
        
    }else if (self.sign==101)
    {
        arrayData=[[NSMutableArray alloc] initWithObjects:@"订单ID：",@"金额：",@"会员账号：",@"下单时间：",@"生成时间：",@"备注：", nil];
        array2=[[NSMutableArray alloc] initWithObjects:[self.diction objectForKey:@"orderid"],[NSString stringWithFormat:@"%@元",[self.diction objectForKey:@"jine"]],[NSString stringWithFormat:@"%@",[self.diction objectForKey:@"user"]],[NSString stringWithFormat:@"%@",[self.diction objectForKey:@"shijian"]],[NSString stringWithFormat:@"%@",[self.diction objectForKey:@"cjshijian"]],[self.diction objectForKey:@"beizhu"], nil];
        
    }else if(self.sign==102)
    {
        arrayData=[[NSMutableArray alloc] initWithObjects:@"会员号：",@"冻结日期：",@"解冻日期：",@"金额：",@"收益：", nil];
        array3=[[NSMutableArray alloc] initWithObjects:[self.diction objectForKey:@"user"],[self.diction objectForKey:@"djshijian"],[self.diction objectForKey:@"cjshijian"],[NSString stringWithFormat:@"%@元",[self.diction objectForKey:@"jine"]],[NSString stringWithFormat:@"%@元",[self.diction objectForKey:@"paiduishouyi"]], nil];
    }else
    {
        arrayData=[[NSMutableArray alloc] initWithObjects:@"会员号：",@"姓名：",@"金额：",@"订单状态：",@"订单类型：", nil];
        array4=[[NSMutableArray alloc] initWithObjects:[self.diction objectForKey:@"user"],[self.diction objectForKey:@"name"],[NSString stringWithFormat:@"%@元",[self.diction objectForKey:@"jine"]],[self getstation:[[self.diction objectForKey:@"station"] integerValue]],[NSString stringWithFormat:@"%@",[self.diction objectForKey:@"type"]], nil];
    
    }

    [self initUI];
    // Do any additional setup after loading the view.
}
-(NSString *)getstation:(long)station
{
    if (station==0)
    {
        return @"排队中";
    }
    else if (station==1)
    {
        return @"匹配中";
    }
    else if (station==2)
    {
        return @"付款中";
    }
    else if (station==4)
    {
        return @"冻结中";
    }
    else if (station==5)
    {
        return @"已完成";
    }else if (station==3)
    {
        return @"未付款";
    }
    else if (station==6)
    {
        return @"废单";
    }else
    {
        return @"拒绝付款";
    }
    
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=self.namestring;
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
}
-(void)initUI
{
    workTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,topView.frame.origin.y+topView.frame.size.height ,SCREEN_WIDTH ,SCREEN_HEIGHT-CGRectGetMaxY(topView.frame))];
    workTableView.backgroundColor = [UIColor clearColor];
    workTableView.delegate = self;
    workTableView.dataSource = self;
    workTableView.tableFooterView=[[UIView alloc] init];
    workTableView.scrollEnabled=YES;
    //设置分割线起始位置
    workTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    if (self.sign==103)
    {
        return arrayData.count;
        
    }else
    {
        if(self.sign==101)
        {
            return  arrayData.count;
        }
        return arrayData.count+1;
    
    }
    
}
//tab每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.sign==101)
    {
        return 47;
    }else
    {
        if (self.sign==103) {
            return 47;
        }else
        {
            if (indexPath.row==0) {
                return 94;
            }
            return 47;
        
        }
        
    
    }
    
}


//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.sign!=101)
    {
        if (self.sign==103)
        {
            UILabel *tempL0=[[UILabel alloc]init];
            tempL0.text=[arrayData objectAtIndex:indexPath.row];
            tempL0.font = [UIFont systemFontOfSize:14];
            tempL0.textColor=[UIColor grayColor];
            tempL0.backgroundColor=[UIColor clearColor];
            tempL0.frame=CGRectMake(20, 10,(SCREEN_WIDTH/2), 20);
            [cell addSubview:tempL0];
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            
            UILabel *tempL1=[[UILabel alloc]init];
            tempL1.font = [UIFont systemFontOfSize:14];
            tempL1.textColor=[UIColor grayColor];
            tempL1.backgroundColor=[UIColor clearColor];
            tempL1.textAlignment=NSTextAlignmentRight;
            tempL1.frame=CGRectMake(CGRectGetMaxX(tempL0.frame), 10,(SCREEN_WIDTH/2)-30, 20);
            tempL1.text=[array4 objectAtIndex:indexPath.row];
            [cell addSubview:tempL1];
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        }else
        {
        
            if (indexPath.row==0)
            {
                UILabel *tempL0=[[UILabel alloc]init];
                //tempL0.text=[arrayData objectAtIndex:indexPath.row];
                tempL0.font = [UIFont systemFontOfSize:15];
                tempL0.numberOfLines=2;
                tempL0.textColor=[UIColor grayColor];
                tempL0.textAlignment=NSTextAlignmentCenter;
                tempL0.adjustsFontSizeToFitWidth=YES;
                tempL0.text=[self.diction objectForKey:@"orderid"];
                tempL0.backgroundColor=[UIColor clearColor];
                tempL0.frame=CGRectMake(SCREEN_WIDTH*0.2, 20,(SCREEN_WIDTH*0.6), 40);
                [cell addSubview:tempL0];
                cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
                
            }else
            {
                UILabel *tempL0=[[UILabel alloc]init];
                tempL0.text=[arrayData objectAtIndex:indexPath.row-1];
                tempL0.font = [UIFont systemFontOfSize:14];
                tempL0.textColor=[UIColor grayColor];
                tempL0.backgroundColor=[UIColor clearColor];
                tempL0.frame=CGRectMake(20, 10,(SCREEN_WIDTH/2), 20);
                [cell addSubview:tempL0];
                cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
                
                UILabel *tempL1=[[UILabel alloc]init];
                tempL1.font = [UIFont systemFontOfSize:14];
                tempL1.textColor=[UIColor grayColor];
                tempL1.backgroundColor=[UIColor clearColor];
                tempL1.textAlignment=NSTextAlignmentRight;
                tempL1.frame=CGRectMake(CGRectGetMaxX(tempL0.frame), 10,(SCREEN_WIDTH/2)-30, 20);
                if (self.sign==100)
                {
                    tempL1.text=[array1 objectAtIndex:indexPath.row-1];
                    NSLog(@"%@",tempL1.text);
                }else if (self.sign==102)
                {
                    tempL1.text=[array3 objectAtIndex:indexPath.row-1];
                }
                [cell addSubview:tempL1];
                cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
                
            }
        
        }
        
        return cell;
    }else
    {
        UILabel *tempL0=[[UILabel alloc]init];
        tempL0.text=[arrayData objectAtIndex:indexPath.row];
        tempL0.font = [UIFont systemFontOfSize:14];
        tempL0.textColor=[UIColor grayColor];
        tempL0.backgroundColor=[UIColor clearColor];
        tempL0.frame=CGRectMake(20, 10,(SCREEN_WIDTH/2), 20);
        [cell addSubview:tempL0];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        UILabel *tempL1=[[UILabel alloc]init];
        tempL1.font = [UIFont systemFontOfSize:14];
        tempL1.textColor=[UIColor grayColor];
        tempL1.backgroundColor=[UIColor clearColor];
        tempL1.textAlignment=NSTextAlignmentRight;
        tempL1.frame=CGRectMake(CGRectGetMaxX(tempL0.frame), 10,(SCREEN_WIDTH/2)-30, 20);
        tempL1.text=[array2 objectAtIndex:indexPath.row];
        [cell addSubview:tempL1];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        return cell;
    
    }
    
    
    //cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 50)];
    
    
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
