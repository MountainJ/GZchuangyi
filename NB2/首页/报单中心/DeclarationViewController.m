//
//  DeclarationViewController.m
//  NB2
//
//  Created by zcc on 16/2/19.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "DeclarationViewController.h"
#import "ResgitViewController.h"
#import "AtiinateViewController.h"
#import "ActivateListViewController.h"
#import "ServeControlViewController.h"
#import "SubordinceViewController.h"
@interface DeclarationViewController ()
{
    TopView *topView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
}

@end

@implementation DeclarationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    arrayData=[[NSMutableArray alloc] initWithObjects:@"会员注册",@"激活会员",@"激活记录", nil];
    [self initTopView];
    [self initUI];
    
    
    // Do any additional setup after loading the view.
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"报单中心";
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
    
    return arrayData.count;
}
//tab每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT/14.2;
}


//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *tempL0=[[UILabel alloc]init];
        tempL0.text=[arrayData objectAtIndex:indexPath.row];
        tempL0.font = [UIFont systemFontOfSize:15];
        tempL0.textColor=[UIColor blackColor];
        tempL0.backgroundColor=[UIColor clearColor];
        tempL0.frame=CGRectMake(20, SCREEN_HEIGHT/52.7,(SCREEN_WIDTH/2), 20);
        [cell addSubview:tempL0];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 50)];
    
    
    return cell;
}
-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0)
    {
        ResgitViewController *resgit=[[ResgitViewController alloc] init];
        [self.navigationController pushViewController:resgit animated:YES];
        
    }if (indexPath.row==1)
    {
        AtiinateViewController *resgit=[[AtiinateViewController alloc] init];
        [self.navigationController pushViewController:resgit animated:YES];
        
    }if (indexPath.row==2)
    {
        ActivateListViewController *resgit=[[ActivateListViewController alloc] init];
        [self.navigationController pushViewController:resgit animated:YES];
        
    }if (indexPath.row==3)
    {
        ServeControlViewController *resgit=[[ServeControlViewController alloc] init];
        [self.navigationController pushViewController:resgit animated:YES];
        
    }if (indexPath.row==4)
    {
        SubordinceViewController *resgit=[[SubordinceViewController alloc] init];
        [self.navigationController pushViewController:resgit animated:YES];
    }
}
-(void)actionRight
{
    ResgitViewController *three=[[ResgitViewController alloc] init];
    three.type=1;
    [self.navigationController pushViewController:three animated:YES];
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
