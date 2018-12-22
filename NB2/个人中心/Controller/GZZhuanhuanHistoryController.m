//
//  GZZhuanhuanHistoryController.m
//  NB2
//
//  Created by 张毅 on 2018/12/22.
//  Copyright © 2018年 MoutainJay. All rights reserved.
//

#import "GZZhuanhuanHistoryController.h"
#import "GZChangeListCell.h"

#define URL_CHANGE_RECORD  @"/api/requestZhonggouorderlog" //众购转换记录

@interface GZZhuanhuanHistoryController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger  reloadIndexPage;

@end

@implementation GZZhuanhuanHistoryController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + NAV_BAR_HEIGHT + JF_TOP_ACTIVE_SPACE, SCREEN_WIDTH, SCREEN_HEIGHT - (20 + NAV_BAR_HEIGHT + JF_TOP_ACTIVE_SPACE)) style:UITableViewStyleGrouped];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_LIGHTGRAY_BACK;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_tableView];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.reloadIndexPage = 1;
            [self dataRequest];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.reloadIndexPage++;
            [self dataRequest];
        }];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topView.titileTx = @"转换记录";
    [self.topView setTopView];
    self.dataSource = [NSMutableArray array];
    [self dataRequest];
    [self tableView];
}

- (void)dataRequest
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *paramDict =  @{@"id":SAFE_STRING(UID),
                                 @"md5":SAFE_STRING(MD5),
                                 @"num":[NSString stringWithFormat:@"%d",10],
                                 @"page":[NSString stringWithFormat:@"%ld",(long)self.reloadIndexPage]
                                 };
    if (self.reloadIndexPage <=1) {
        [self.dataSource removeAllObjects];
    }
    NSString *requestHost =  URL_CHANGE_RECORD;
    [HttpTool postWithBaseURL:kBaseURL path:requestHost params:paramDict success:^(NSDictionary *dict) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView.mj_footer endRefreshing];
        
        [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
        if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
        {
            if (![[dict objectForKey:@"result"] count]) {
                [ToolControl showHudWithResult:NO andTip:@"暂无更多数据！"];
                return ;
            }
            for (NSDictionary *arrDict  in  dict[@"result"]) {
                GZChangeOrderModel *model =[[GZChangeOrderModel alloc] initwithDict:arrDict];
                model.recordFlag = YES;
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        }
        NSLog(@"%@",dict);
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
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
    return KKFitScreen(30);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KKFitScreen(170.);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ZhongchouHomeCell";
    GZChangeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GZChangeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    GZChangeOrderModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.model = model;
    cell.actionBtnHidden = YES;
    return cell;
}



@end
