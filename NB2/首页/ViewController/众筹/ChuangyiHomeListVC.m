//
//  ChuangyiHomeListVC.m
//  NB2
//
//  Created by Jayzy on 2017/9/3.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ChuangyiHomeListVC.h"
#import "ZhongchouModel.h"
#import "ZhougchouListCell.h"
#import "CHuangyiDetailVC.h"
#import "ShopHistoryVC.h"

@interface ChuangyiHomeListVC ()<TopViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger page;

@end

@implementation ChuangyiHomeListVC

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE, SCREEN_WIDTH, SCREEN_HEIGHT - (20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE)) style:UITableViewStyleGrouped];
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

    self.topView.titileTx = @"明日众筹";
    self.topView.buttonRB = @"跟投记录";
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
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestZhongchoulist" params:paramDict success:^(NSDictionary *dict) {
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
                    ZhongchouModel *model = [[ZhongchouModel alloc] initWithDataDict:dataDict];
                    [self.dataSource addObject:model];
                }
            }else if ([dict[@"result"] isKindOfClass:[NSDictionary class]])
            {
                ZhongchouModel * model = [[ZhongchouModel alloc] initWithDataDict:dict[@"result"]];
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
    return KKFitScreen(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ZHONGCHOU_LIST_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ZhougchouListCell";
    ZhougchouListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZhougchouListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ZhongchouModel * model = [self.dataSource objectAtCheckIndex:indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZhongchouModel * model = [self.dataSource objectAtCheckIndex:indexPath.section];
    CHuangyiDetailVC * detailVC = [[CHuangyiDetailVC alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)actionRight
{
    ShopHistoryVC * hisVC = [[ShopHistoryVC alloc] init];
    hisVC.requstType = @"0";
    hisVC.titleName = @"跟投记录";
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
