//
//  AddressListVC.m
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "AddressListVC.h"
#import "LocationCell.h"
#import "AddAddressInfoVC.h"

#define BOTTOM_MARGIN   KKFitScreen(30)
#define BOTTOM_HEIGHT   KKFitScreen(70)


@interface AddressListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UIButton *addNewButton;

@end

@implementation AddressListVC

- (UIButton *)addNewButton
{
    if (!_addNewButton) {
        _addNewButton = [UIButton buttonWithFrame:CGRectMake(BOTTOM_MARGIN, SCREEN_HEIGHT - BOTTOM_MARGIN - BOTTOM_HEIGHT , SCREEN_WIDTH - 2 * BOTTOM_MARGIN, BOTTOM_HEIGHT) backGroundColor:[UIColor orangeColor] cornerRadius:5.0F textColor:[UIColor whiteColor] clickAction:@selector(addNewAddress) clickTarget:self addToView:self.view buttonText:@"添加新地址"];
    }
    return _addNewButton;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE, SCREEN_WIDTH, SCREEN_HEIGHT - (20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE) - BOTTOM_HEIGHT - BOTTOM_MARGIN) style:UITableViewStyleGrouped];
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
    self.topView.titileTx = @"选择收获地址";
    [self.topView setTopView];
     self.page = 1;
    [self requstUserLocation];
    
    [self.view addSubview:self.addNewButton];
    //
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
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    LocationModel *model = [self.dataSource objectAtCheckIndex:indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LocationModel *model = [self.dataSource objectAtCheckIndex:indexPath.section];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.selectBlock) {
        self.selectBlock(model);
    }
}

- (void)addNewAddress
{
    AddAddressInfoVC * addVC = [[AddAddressInfoVC alloc] init];
    WS(weakSelf)
    [addVC didSaveAddress:^{
        weakSelf.page = 1 ;
        [weakSelf requstUserLocation];
    }];
    [self presentViewController:addVC animated:YES completion:nil];
}

- (void)didChooseAddressBlock:(DidSelectAddress)block
{
    _selectBlock = block;
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
