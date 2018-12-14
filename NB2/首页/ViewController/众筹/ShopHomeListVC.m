//
//  ShopHomeListVC.m
//  NB2
//
//  Created by Jayzy on 2017/9/3.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ShopHomeListVC.h"

#import "GoodsModel.h"
#import "GoodsHomeCell.h"
#import "ShopDetailInfoVC.h"
#import "ShopHistoryVC.h"

@interface ShopHomeListVC ()<TopViewDelegate,UITableViewDelegate,UITableViewDataSource,GoodsHomeCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;

@end

@implementation ShopHomeListVC

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE, SCREEN_WIDTH, SCREEN_HEIGHT - (20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE)) style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_LIGHTGRAY_BACK;
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
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.topView.titileTx = @"会员商店";
    self.topView.buttonRB = @"购买记录";
    [self.topView setTopView];

    self.page = 1;
    [self dataRequest];
    WS(weakSelf)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf dataRequest];
    }];
    
}

- (void)dataRequest
{
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
    }
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *paramDict = @{@"id":UID?UID:@"",@"md5":MD5?MD5:@"",@"page":[NSString stringWithFormat:@"%ld",(long)self.page],@"num":[NSString stringWithFormat:@"%d",10]};
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestShoplistnew" params:paramDict success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshing];

        if (![dict isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        if (![dict[RequestResponseCodeKey] isEqualToString:RequestResponseCodeValue]) {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            return ;
        }
        if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
        {
            if (![dict[@"result"] count]) {
                [ToolControl showHudWithResult:NO andTip:@"没有更多数据了！"];
                return;
            }
            if ([dict[@"result"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dataDict in dict[@"result"]) {
                    GoodsModel *model = [[GoodsModel alloc] initWithDataDict:dataDict];
                    [self.dataSource addObject:model];
                }
            }else if ([dict[@"result"] isKindOfClass:[NSDictionary class]])
            {
                GoodsModel * model = [[GoodsModel alloc] initWithDataDict:dict[@"result"]];
                [self.dataSource addObject:model];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshing];

        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
}

#pragma mark -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return KKFitScreen(0.00001);
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.000001;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GOODS_HOME_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"GoodsHomeCell";
    GoodsHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GoodsHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    GoodsModel * model = [self.dataSource objectAtCheckIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsModel * model = [self.dataSource objectAtCheckIndex:indexPath.row];
    ShopDetailInfoVC * detailVC = [[ShopDetailInfoVC alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)GoodsHomeCell:(GoodsHomeCell *)cell model:(GoodsModel *)model
{
    ShopDetailInfoVC * detailVC = [[ShopDetailInfoVC alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)actionRight
{
    ShopHistoryVC * hisVC = [[ShopHistoryVC alloc] init];
    hisVC.requstType = @"1";
    hisVC.titleName = @"购买记录";
    [self.navigationController pushViewController:hisVC animated:YES];
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
