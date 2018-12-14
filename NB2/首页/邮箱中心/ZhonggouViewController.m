//
//  ZhonggouViewController.m
//  NB2
//
//  Created by kongbin on 2017/3/13.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ZhonggouViewController.h"
#import "ZhongchouHomeCell.h"

#import "ShopHomeListVC.h"
#import "ChuangyiHomeListVC.h"
#import "ZhongchouModel.h"


@interface ZhonggouViewController ()<TopViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UILabel *descLbl;
}

@property (nonatomic,strong) TopView *topView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ZhonggouViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - (20 + NAV_BAR_HEIGHT)) style:UITableViewStyleGrouped];
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
        ZhongchouModel * model1 = [[ZhongchouModel alloc] init];
        model1.homeBackImg = @"ic_shoping_01";
        model1.titleImg = @"ic_pentacles_shoping";
        model1.leftImg = @"ic_webshoping_logo";
        [_dataSource addObject:model1];
        ZhongchouModel * model2 = [[ZhongchouModel alloc] init];
        model2.homeBackImg = @"ic_shoping_02";
        model2.titleImg = @"ic_public_chuangyi";
        model2.leftImg = @"ic_webshoping_logo";
        [_dataSource addObject:model2];

    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self navConfig];
    
    [self dataRequest];
    [self tableView];
    
}

- (void)dataRequest
{
    [self.tableView reloadData];
    
//    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
//    NSDictionary *paramDict = @{@"id":UID?UID:@"",@"md5":MD5?MD5:@"",@"page":[NSString stringWithFormat:@"%d",1],@"num":[NSString stringWithFormat:@"%d",10]};
//    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestZhongchoulist" params:paramDict success:^(NSDictionary *dict) {
//            [SVProgressHUD dismiss];
//        if (![dict[RequestResponseCodeKey] isEqualToString:RequestResponseCodeValue]) {
//            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
//            return ;
//        }
//         
//            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
//            {
//                if ([dict[@"result"] isKindOfClass:[NSArray class]]) {
//                    for (NSDictionary *dataDict in dict[@"result"]) {
//                        ZhongchouModel *model = [[ZhongchouModel alloc] initWithDataDict:dataDict];
//                        [self.dataSource addObject:model];
//                    }
//                }else if ([dict[@"result"] isKindOfClass:[NSDictionary class]])
//                {
//                    ZhongchouModel * model = [[ZhongchouModel alloc] initWithDataDict:dict[@"result"]];
//                    [self.dataSource addObject:model];
//                }
//            }
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
//    }];
}

- (void)navConfig
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.topView = [[TopView alloc]init];
    self.topView.titileTx=@"众筹平台";
    self.topView.imgLeft=@"back_btn_n";
    self.topView.delegate=self;
    [self.view addSubview:self.topView];
    [self.topView setTopView];
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
    if (indexPath.section == 0) { //商店
        ShopHomeListVC * shopHome = [[ShopHomeListVC alloc] init];
        [self.navigationController pushViewController:shopHome animated:YES];
    }else if (indexPath.section == 1){ //众筹
        ChuangyiHomeListVC * shopHome = [[ChuangyiHomeListVC alloc] init];
        [self.navigationController pushViewController:shopHome animated:YES];

    }else{
    
    }
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

-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
