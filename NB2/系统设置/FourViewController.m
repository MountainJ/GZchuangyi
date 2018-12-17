//
//  FourViewController.m
//  NB2
//
//  Created by zcc on 16/2/18.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "FourViewController.h"
#import "FristViewController.h"
#import "NavViewController.h"
@interface FourViewController ()
{
    TopView *topView;
    UITableView *customTableView;
    NSArray *titleName3;
    NSArray *iconName3;
}
@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    [self initTopView];
    self.view.backgroundColor=[UIColor whiteColor];
    titleName3 = [NSArray arrayWithObjects:@"4000-4444-758",@"mrstar@vip.163.com", nil];
    iconName3 = [NSArray arrayWithObjects:@"当前版本",@"客服邮箱", nil];
    [self initUI];
    [self addFootBut];
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
    topView.titileTx=@"系统设置";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
    
}
-(void)initUI
{
    customTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-60) style:UITableViewStylePlain];
    //[customTableView setShowsVerticalScrollIndicator:NO];
    customTableView.backgroundColor=[UIColor whiteColor];
    customTableView.delegate = self;
    customTableView.dataSource = self;
    [self.view addSubview:customTableView];
    customTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)addFootBut
{
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    but.frame=CGRectMake(SCREEN_WIDTH*0.05, SCREEN_HEIGHT- KKFitScreen(80) - TAB_BAR_HEIGHT - KKFitScreen(40) - JF_BOTTOM_SPACE, SCREEN_WIDTH*0.9, KKFitScreen(80));
    but.layer.masksToBounds=YES;
    but.layer.cornerRadius=16;
    [but setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [but setTitle:@"退出登录" forState:UIControlStateNormal];
    but.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    [but addTarget:self action:@selector(clickLognOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];

}
-(void)clickLognOut
{
    NSDictionary *diction=[[NSDictionary alloc] init];
    NSArray *array=[[NSArray alloc] initWithObjects:diction, nil];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"result"];
    FristViewController *loginCtrl = [[FristViewController alloc] init];
    NavViewController *navCtrl = [[NavViewController alloc] initWithRootViewController:loginCtrl];
    navCtrl.navigationBarHidden=YES;
    self.view.window.rootViewController = navCtrl;

}
//tab数量1
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//tab一页4行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return titleName3.count;
    }
    
    return 0;
}
//tab每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return SCREEN_HEIGHT*0.22;
    }
    return KKFitScreen(100);
    
}
//tab头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return  0.1;
    }
    return 10;//section头部高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;//section底部高度
}



//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.section==0)
    {
        if (indexPath.row == 0)
        {
            CGFloat width = KKFitScreen(220.);
            UIImageView *ivTemp= [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-width)/2.0, SCREEN_HEIGHT/33.35, width,width)];
            [ivTemp setImage:[UIImage imageNamed:@"logo"]];
            [cell.contentView addSubview:ivTemp];
            
        }
    }
    else
    {
        NSString *titleName= [NSString stringWithFormat:@"%@", [iconName3 objectAtIndex:indexPath.row]];
         CGSize labelSize = [titleName sizeWithFont:[UIFont systemFontOfSize:KKFitScreen(28)]];
         UILabel *ivTemp= [[UILabel alloc]initWithFrame:CGRectMake(15,  15, labelSize.width, labelSize.height)];
         [ivTemp setText:titleName];
        ivTemp.font=[UIFont systemFontOfSize:KKFitScreen(28)];
         [cell.contentView addSubview:ivTemp];
        
        NSString *imageNameL;
        if (indexPath.row==0)
        {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            imageNameL = [NSString stringWithFormat:@"当前版本%@", appCurVersion];
            
        }else
        {
            imageNameL = [NSString stringWithFormat:@"%@", [titleName3 objectAtIndex:indexPath.row]];
        }
        CGSize NameLSize = [imageNameL sizeWithFont:[UIFont systemFontOfSize:KKFitScreen(28)]];
         UILabel *lbTemp3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.50,  15, SCREEN_WIDTH*0.5-10, NameLSize.height)];
        lbTemp3.font=[UIFont systemFontOfSize:KKFitScreen(28)];
        lbTemp3.adjustsFontSizeToFitWidth=YES;
        lbTemp3.textAlignment=NSTextAlignmentRight;
         [lbTemp3 setText:imageNameL];
         [cell.contentView addSubview:lbTemp3];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
