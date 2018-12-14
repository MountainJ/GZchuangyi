//
//  MyAddressViewController.m
//  NB2
//
//  Created by Jayzy on 2017/9/10.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "MyAddressViewController.h"
#import "ModifyLocationCell.h"
#import "AddAddressInfoVC.h"
#import "AddAddressInfoVC.h"
@interface MyAddressViewController ()<UITableViewDelegate,UITableViewDataSource,ModifyLocationCellDelegate,TopViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL hideRefresh;

@end

@implementation MyAddressViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE, SCREEN_WIDTH, SCREEN_HEIGHT - (20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLOR_LIGHTGRAY_BACK;
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
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
    self.topView.titileTx = @"我的地址";
    self.topView.imgRight = @"add_plus";

    [self.topView setTopView];
    self.page = 1;
    [self requstUserLocation];
    
    WS(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1 ;
        [weakSelf requstUserLocation];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requstUserLocation];
    }];
    
}

- (void)requstUserLocation
{
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5],@"num":[NSString stringWithFormat:@"%d",5],@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
    }
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestDizhilist" params:paramDict success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];

        if (![dict isKindOfClass:[NSDictionary class]]) {
            [self.tableView reloadData];
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
                    LocationModel *model = [[LocationModel alloc] initWithDataDict:dataDict];
                    [self.dataSource addObject:model];
                }
            }else if ([dict[@"result"] isKindOfClass:[NSDictionary class]])
            {
                LocationModel * model = [[LocationModel alloc] initWithDataDict:dict[@"result"]];
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
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
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return KKFitScreen(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KKFitScreen(200);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LocationCell";
    ModifyLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ModifyLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID buttonText:@"设为默认地址"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    LocationModel *model = [self.dataSource objectAtCheckIndex:indexPath.section];
    [cell updateUIWithModel:model];
    return cell;
}

- (void)ModifyLocationCell:(ModifyLocationCell *)cell clickAciton:(id)action
{
    if ([action isKindOfClass:[LocationModel class]]) {
        LocationModel *model = (LocationModel *)action;
        [self updateDefaultAddressWithModel:model];
    }
}



- (void)updateDefaultAddressWithModel:(LocationModel *)model
{
    WS(weakSelf)
    [SVProgressHUD showWithStatus:@"设置中..." maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5],@"tid":[NSString stringWithFormat:@"%@",model.itemID]};
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestDizhimoren" params:paramDict success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        if (![dict[RequestResponseCodeKey] isEqualToString:RequestResponseCodeValue]) {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            return ;
        }
        if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
        {
            if (self.dataSource.count > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            [self.tableView.mj_header beginRefreshing];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
    
}

- (void)actionRight
{
    AddAddressInfoVC * addVC = [[AddAddressInfoVC alloc] init];
    WS(weakSelf)
    [addVC didSaveAddress:^{
         weakSelf.page = 1 ;
//        self.hideRefresh = YES;
        [weakSelf requstUserLocation];
    }];
    [self presentViewController:addVC animated:YES completion:nil];
}


@end
