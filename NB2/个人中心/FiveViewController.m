//
//  FiveViewController.m
//  NB2
//
//  Created by zcc on 16/2/18.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "FiveViewController.h"
#import "NumberViewController.h"
#import "MyPaidanbiViewController.h"
#import "MeansViewController.h"
#import "AlterViewController.h"
#import "RecommedViewController.h"
#import "NavViewController.h"
#import "MyAccountInfoViewController.h"

@interface FiveViewController ()
{
    TopView *topView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
}
@end

@implementation FiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    arrayData=[[NSMutableArray alloc] initWithObjects:@"我的激活码",@"我的创益币",@"我的账户",@"资料管理",@"修改密码",@"推荐结构", nil];
    [self initTopView];
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

-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"个人中心";
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
    
    return arrayData.count;
}
//tab每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KKFitScreen(100);
}


//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *tempL0=[[UILabel alloc]init];
        tempL0.text=[arrayData objectAtIndex:indexPath.row];
        tempL0.font = [UIFont systemFontOfSize:KKFitScreen(28)];
        tempL0.textColor=[UIColor blackColor];
        tempL0.backgroundColor=[UIColor clearColor];
        tempL0.frame=CGRectMake(20, 0,(SCREEN_WIDTH/2), KKFitScreen(100));
        [cell addSubview:tempL0];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0)
    {
        
        NumberViewController *number=[[NumberViewController alloc] init];
        [self.navigationController pushViewController:number animated:YES];

    }
    if (indexPath.row==1)
    {
        MyPaidanbiViewController *number=[[MyPaidanbiViewController alloc] init];
        [self.navigationController pushViewController:number animated:YES];
    }
    if (indexPath.row==2)
    {
         MyAccountInfoViewController *number=[[MyAccountInfoViewController alloc] init];
        [self.navigationController pushViewController:number animated:YES];
    }
    if (indexPath.row==3)
    {
        MeansViewController *number=[[MeansViewController alloc] init];
       [self.navigationController pushViewController:number animated:YES];
    }
    if (indexPath.row==4)
    {
        AlterViewController *number=[[AlterViewController alloc] init];
        [self.navigationController pushViewController:number animated:YES];
    }
    if (indexPath.row==5)
    {
        RecommedViewController *number=[[RecommedViewController alloc] init];
        [self.navigationController pushViewController:number animated:YES];
    }

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
