//
//  MingriZhonggouHomeVC.m
//  NB2
//
//  Created by Jayzy on 2017/9/10.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "MingriZhonggouHomeVC.h"
#import "ZhongchouHomeCell.h"

#import "ShopHomeListVC.h"
#import "ChuangyiHomeListVC.h"
#import "ZhongchouModel.h"
#import "KKActionSheetView.h"

#import "ChuangyibiBuyViewController.h"
#import "JihuomaInputVC.h"
#import "MyOrderViewController.h"
#import "MyAddressViewController.h"

@interface MingriZhonggouHomeVC ()<UITableViewDelegate,UITableViewDataSource,TopViewDelegate,KKActionSheetViewDelegate>
{
    UILabel *descLbl;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation MingriZhonggouHomeVC

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + NAV_BAR_HEIGHT + JF_TOP_ACTIVE_SPACE, SCREEN_WIDTH, SCREEN_HEIGHT - (20 + NAV_BAR_HEIGHT + JF_TOP_ACTIVE_SPACE)) style:UITableViewStyleGrouped];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        ZhongchouModel * model2 = [[ZhongchouModel alloc] init];
        model2.homeBackImg = @"ic_shoping_02";
        model2.titleImg = @"ic_public_chuangyi";
        model2.leftImg = @"ic_webshoping_logo";
        model2.title = @"明日众筹";
        [_dataSource addObject:model2];
        
        
        ZhongchouModel * model1 = [[ZhongchouModel alloc] init];
        model1.homeBackImg = @"ic_shoping_01";
        model1.titleImg = @"ic_pentacles_shoping";
        model1.leftImg = @"ic_webshoping_logo";
        model1.title = @"会员商店";
        [_dataSource addObject:model1];

      


    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.titileTx = @"众筹平台";
    self.topView.imgRight = @"choice";
    [self.topView setTopView];
    
    [self dataRequest];
    [self tableView];
}

- (void)dataRequest
{
    [self.tableView reloadData];
}


#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KKFitScreen(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ZHONGCHOU_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ZhongchouHomeCell";
    ZhongchouHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZhongchouHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ZhongchouModel * model = [self.dataSource objectAtCheckIndex:indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) { //商店
        ShopHomeListVC * shopHome = [[ShopHomeListVC alloc] init];
        [self.navigationController pushViewController:shopHome animated:YES];
    }else if (indexPath.section == 0){ //众筹
        ChuangyiHomeListVC * shopHome = [[ChuangyiHomeListVC alloc] init];
        [self.navigationController pushViewController:shopHome animated:YES];
    }else{
        
    }
}

- (void)actionRight
{

   KKActionSheetView *sheetView = [[KKActionSheetView alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创益币兑换",@"激活码兑换",@"下单记录",@"收寄地址",nil];
    [sheetView showInView:self.view];
}

- (void)actionSheet:(KKActionSheetView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//创益币兑换
        ChuangyibiBuyViewController *vc = [[ChuangyibiBuyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else  if (buttonIndex == 1) {//激活码兑换
         JihuomaInputVC *vc = [[JihuomaInputVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else  if (buttonIndex == 2) {//购买记录
         MyOrderViewController *vc = [[MyOrderViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else  if (buttonIndex == 3) {//下单地址
        MyAddressViewController *vc = [[MyAddressViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
