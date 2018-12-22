//
//  GZZhunahuanListController.m
//  NB2
//
//  Created by 张毅 on 2018/12/22.
//  Copyright © 2018年 MoutainJay. All rights reserved.
//

#import "GZZhunahuanListController.h"
#import "GZZhuanhuanHistoryController.h"
#import "GZChangeListCell.h"



#define URL_CHANGE_LIST  @"/api/requestZhonggouorderlist" //众购转换订单列表
#define URL_CHANGE_ACTION  @"/api/requestZhonggouzhuanhuan" //众购转换操作


@interface GZZhunahuanListController ()<UITableViewDelegate,UITableViewDataSource,GZChangeListCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger  reloadIndexPage;
@property (nonatomic,strong) GZChangeOrderModel  *changeModel;


@end

@implementation GZZhunahuanListController


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
    self.topView.titileTx = @"众购转换";
    self.topView.buttonRB =@"记录查询";
    self.reloadIndexPage = 1;
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
    NSString *requestHost =  URL_CHANGE_LIST;
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
    return KKFitScreen(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KKFitScreen(240.);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ZhongchouHomeCell";
   GZChangeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GZChangeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    GZChangeOrderModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.model = model;
    return cell;
}

- (void)GZChangeListCell:(GZChangeListCell *)cell changeModel:(GZChangeOrderModel *)model
{
    self.changeModel = model;
    //弹出是否转换的提示----只读取确认收货7天后的商品订单，每个订单只能转换一次，转换后，将无法还原，请谨慎操作！
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定转换吗?" message:@"只读取确认收货7天后的商品订单，每个订单只能转换一次，转换后，将无法还原，请谨慎操作！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self actionDealChangeWithModel:self.changeModel];
    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)actionRight
{
    GZZhuanhuanHistoryController *list = [GZZhuanhuanHistoryController new];
    [self.navigationController pushViewController:list animated:YES];
   
}

//cell代理处理

//
- (void)actionDealChangeWithModel:(GZChangeOrderModel*)model
{

    [SVProgressHUD showWithStatus:@"转换中..." maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *paramDict =  @{@"id":SAFE_STRING(UID),
                                 @"md5":SAFE_STRING(MD5),
                                 @"tid":SAFE_STRING(model.itemId)
                                 };
    NSString *requestHost =  URL_CHANGE_ACTION;
    [HttpTool postWithBaseURL:kBaseURL path:requestHost params:paramDict success:^(NSDictionary *dict) {
        
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
        if (![[dict objectForKey:@"station"] isEqualToString:@"success"]){
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
            return ;
        }
       //转换成功页面进行刷新处理
        [self.tableView.mj_header beginRefreshing];
        NSLog(@"%@",dict);
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
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
