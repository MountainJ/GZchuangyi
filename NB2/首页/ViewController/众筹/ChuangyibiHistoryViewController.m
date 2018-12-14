//
//  ChuangyibiHistoryViewController.m
//  NB2
//
//  Created by Jayzy on 2017/9/10.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ChuangyibiHistoryViewController.h"
#import "GoodsModel.h"
#import "ChuangyiHistoryCell.h"

@interface ChuangyibiHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger page;

@end

@implementation ChuangyibiHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topView.titileTx = @"兑换记录";
    [self.topView setTopView];
    self.page = 1;
    [self requstHistoryData];
    
    WS(weakSelf)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requstHistoryData];
    }];
}

- (void)requstHistoryData
{
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5],@"num":[NSString stringWithFormat:@"%d",10],@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
    }
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestDuihuancyyjl" params:paramDict success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshing];

        if (![dict isKindOfClass:[NSDictionary class]]) {
            [ToolControl showHudWithResult:NO andTip:@"数据有误！"];
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
            if ([dict[@"result"] isKindOfClass:[NSArray class]] && [dict[@"result"] count]){
               
                if ([dict[@"result"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dataDict in dict[@"result"]) {
                        HistoryModel *model = [[HistoryModel alloc] initWithDataDict:dataDict];
                        [self.dataSource addObject:model];
                    }
                }else if ([dict[@"result"] isKindOfClass:[NSDictionary class]])
                {
                    HistoryModel * model = [[HistoryModel alloc] initWithDataDict:dict[@"result"]];
                    [self.dataSource addObject:model];
                }
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshing];

        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
    
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE, SCREEN_WIDTH, SCREEN_HEIGHT - (20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE)) style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_LIGHTGRAY_BACK;
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [ToolControl setSeparatorWithTableView:_tableView];        
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

#pragma mark -



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KKFitScreen(200);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ChuangyiHistoryCell";
    ChuangyiHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ChuangyiHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HistoryModel *model = [self.dataSource objectAtCheckIndex:indexPath.row];
    cell.model = model;
    return cell;
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
