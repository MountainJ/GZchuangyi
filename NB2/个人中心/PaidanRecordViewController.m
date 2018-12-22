//
//  PaidanRecordViewController.m
//  NB2
//
//  Created by zcc on 2017/3/12.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "PaidanRecordViewController.h"

#import "GZCoinHistoryListCell.h"

#define URL_TRANSFER_HISTORY  @"/api/requestChuangyebizrlist" //转让记录
#define URL_ACCEPT_HISTORY  @"/api/requestChuangyebijslist" //接收记录
#define URL_COIN_DETAIL  @"/api/requestChuangyebilist" //创业币明细


@interface PaidanRecordViewController ()
{
    TopView *topView;
    int tempPage;
    UIAlertView *customAlertView;
}

@property (nonatomic,assign) NSInteger  reloadIndexPage;
@property (nonatomic,strong) NSMutableArray  *arrayData;
@property (nonatomic,strong) UITableView  *tableView;

@end

@implementation PaidanRecordViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,topView.frame.origin.y+topView.frame.size.height+5 ,SCREEN_WIDTH ,SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-5) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLOR_LIGHTGRAY_BACK;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView=[[UIView alloc] init];
        WS(weakSelf);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.reloadIndexPage = 1;
            [weakSelf initData];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.reloadIndexPage++;
            [weakSelf initData];
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
//        if ([self.arrayData count]>10)
//        {
//            [ConvertValue scrollTableToNum:YES :10 :workTableView];
//        }
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTopView];
    self.reloadIndexPage = 1;
    tempPage=1;
    _arrayData=[NSMutableArray array];
    [self initData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}



-(void)initTopView
{
    topView = [[TopView alloc]init];
    NSString *title = nil;
    switch (self.chuangyebiType) {
        case ChuangyebiListTypeSend:
            title = @"转让记录";
            break;
            case ChuangyebiListTypeReceive:
            title = @"接收记录";
            break;
        case ChuangyebiListTypeDetail:
            title = @"创业币明细";
            break;
        default:
            break;
    }
    topView.titileTx=title;
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
    
}

-(void)initData
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *paramDict =  @{@"id":SAFE_STRING(UID),
                                 @"md5":SAFE_STRING(MD5),
                                 @"num":[NSString stringWithFormat:@"%d",10],
                                 @"page":[NSString stringWithFormat:@"%ld",(long)self.reloadIndexPage]
                                 };
    if (self.reloadIndexPage <=1) {
        [self.arrayData removeAllObjects];
    }
    NSString *requestHost =  [self configRequestHost];
    [HttpTool postWithBaseURL:kBaseURL path:requestHost params:paramDict success:^(NSDictionary *dict) {
        @try
        {
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
                    GZChuangyebiModel *model = [[GZChuangyebiModel alloc] initwithDict:arrDict];
                    if (self.chuangyebiType == ChuangyebiListTypeDetail) {
                        model.isDetailInfo = YES;
                    }
                    [self.arrayData addObject:model];
                }
                [self.tableView reloadData];
            }
            NSLog(@"%@",dict);
        }
        @catch (NSException *exception)
        {
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
}

- (NSString *)configRequestHost
{
    switch (self.chuangyebiType) {
        case ChuangyebiListTypeSend:
            return URL_TRANSFER_HISTORY;
            break;
        case ChuangyebiListTypeReceive:
            return URL_ACCEPT_HISTORY;
            break;
        case ChuangyebiListTypeDetail:
            return URL_COIN_DETAIL;
            break;
            
        default:
            return @"";
            break;
    }
}


#pragma mark - TableView
//tab数量1
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayData.count;
}
//tab一页多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//tab每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KKFitScreen(210.);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KKFitScreen(20.);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.chuangyebiType == ChuangyebiListTypeReceive || self.chuangyebiType == ChuangyebiListTypeSend) {
        static NSString *chuangyiCellid = @"chuangyiCellid";
        GZCoinHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:chuangyiCellid];
        if (!cell) {
            cell = [[GZCoinHistoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chuangyiCellid];
        }
        GZChuangyebiModel *model = [self.arrayData objectAtCheckIndex:indexPath.section];
        cell.model = model;
        return cell;
    }else if (self.chuangyebiType == ChuangyebiListTypeDetail){
        static NSString *coindetailCellid = @"coindetailCellid";
        GZCoinHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:coindetailCellid];
        if (!cell) {
            cell = [[GZCoinHistoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:coindetailCellid];
        }
        GZChuangyebiModel *model = [self.arrayData objectAtCheckIndex:indexPath.section];
        cell.model = model;
        return cell;
    }else{
        static NSString *defaultCellid = @"defaultCellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellid];
        }
        return cell;
    }
//
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSDictionary *dictTable=[self.arrayData objectAtIndex:indexPath.row];
//
//    UILabel *tempL0=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2, 20)];
//    tempL0.text= @"转让会员账户：";
//    tempL0.textColor=[UIColor grayColor];
//    [tempL0 setFont:[UIFont systemFontOfSize:13]];
//    [cell addSubview:tempL0];
//
//    UILabel *tempL1=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL0.frame), SCREEN_WIDTH*0.5, 20)];
//    tempL1.textColor=[UIColor colorWithWhite:0.5 alpha:1];
//    tempL1.text= [dictTable objectForKey:@"user"];
//    [tempL1 setFont:[UIFont systemFontOfSize:13]];
//    [tempL1 setTextColor:[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1]];
//    [cell addSubview:tempL1];
//
//
//
//
//
//    UILabel *tempL2=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL1.frame)+10, SCREEN_WIDTH*0.2, 20)];
//    tempL2.textAlignment = NSTextAlignmentLeft;
//    tempL2.text=@"转让数量：";
//    tempL2.adjustsFontSizeToFitWidth=YES;
//    [tempL2 setFont:[UIFont boldSystemFontOfSize:13]];
//    [tempL2 setTextColor:[UIColor grayColor]];
//    [cell addSubview:tempL2];
//
//    UILabel *tempL23=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tempL2.frame), CGRectGetMaxY(tempL1.frame)+10, SCREEN_WIDTH*0.22, 20)];
//    tempL23.textAlignment = NSTextAlignmentLeft;
//    tempL23.text=[dictTable objectForKey:@"num"];
//    [tempL23 setFont:[UIFont boldSystemFontOfSize:14]];
//    tempL23.adjustsFontSizeToFitWidth=YES;
//    [tempL23 setTextColor:[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1]];
//    [cell addSubview:tempL23];
//
//    //金额
//    UILabel *tempL3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5 + 10, 5, SCREEN_WIDTH*0.4, 20)];
//    tempL3.textAlignment = NSTextAlignmentLeft;
//    tempL3.text=@"转让时间";
//    [tempL3 setFont:[UIFont systemFontOfSize:13]];
//    [tempL3 setTextColor:[UIColor grayColor]];
//    [cell addSubview:tempL3];
//
//    //金额
//    UILabel *tempL4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5 + 10, CGRectGetMaxY(tempL3.frame), SCREEN_WIDTH*0.4, 30)];
//    tempL4.textAlignment = NSTextAlignmentLeft;
//    tempL4.text=[NSString stringWithFormat:@"%@",[dictTable objectForKey:@"shijian"]];
//    [tempL4 setFont:[UIFont systemFontOfSize:13]];
//    tempL4.numberOfLines = 2;
//    [tempL4 setTextColor:[UIColor grayColor]];
////    tempL4.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
//    [cell addSubview:tempL4];
//
//    UILabel *tempL22=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5 + 10, CGRectGetMaxY(tempL4.frame), SCREEN_WIDTH*0.4, 15)];
//    tempL22.textAlignment = NSTextAlignmentLeft;
//    tempL22.text=[NSString stringWithFormat:@"转让类型：%@",[dictTable objectForKey:@"type"]];
//    tempL22.adjustsFontSizeToFitWidth=YES;
//    [tempL22 setFont:[UIFont boldSystemFontOfSize:13]];
//    [tempL22 setTextColor:[UIColor grayColor]];
//    [cell addSubview:tempL22];
//
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,90-5 , SCREEN_WIDTH, 5)];
//    view.backgroundColor=[UIColor whiteColor];
//    [cell addSubview:view];
//
//
//    cell.accessoryType=UITableViewCellAccessoryNone;
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
//    cell.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1];
//    return cell;
}
//- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state
//{
//    if (state == PullDownLoadState)
//    {
//        [self initData];
//    }
//    else//加载更多
//    {
//        tempPage=[ConvertValue getPageNum:[arrayData count] :10];
//        if (tempPage<=0) {
//
//            [ToolControl showHudWithResult:NO andTip:@"暂无更多数据！"];
//            [workTableView stopLoadWithState:PullUpLoadState];
//            return;
//        }
//        NSDictionary *paramDict =  @{@"id":SAFE_STRING(UID),
//                                     @"md5":SAFE_STRING(MD5),
//                                     @"num":[NSString stringWithFormat:@"%d",10],
//                                     @"page":[NSString stringWithFormat:@"%d",tempPage]
//                                     };
//        [ToolControl showHudWithTip:@"加载更多中..."];
//        [HttpTool postWithBaseURL:kBaseURL path:URL_TRANSFER_HISTORY params:paramDict success:^(NSDictionary *dict) {
//            @try
//            {
//
//                [workTableView stopLoadWithState:PullUpLoadState];
//
//                if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
//                {
//                    NSMutableArray *newarray=[NSMutableArray arrayWithArray:arrayData];
//                    [newarray addObjectsFromArray:[dict objectForKey:@"result"]];
//                    arrayData=newarray;
//                    [self initUI];
//
//                }
//                [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
//                NSLog(@"%@",dict);
//
//            }
//            @catch (NSException *exception)
//            {
//                [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
//
//            }
//            @finally {
//
//            }
//        } failure:^(NSError *error) {
//            [SVProgressHUD dismiss];
//            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
//        }];
//
//    }
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//#pragma mark - 创业币接收记录
//
//- (void)requestAcceptedHistoryList
//{
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
//    NSDictionary *paramDict =  @{@"id":SAFE_STRING(UID),
//                                 @"md5":SAFE_STRING(MD5),
//                                 @"num":[NSString stringWithFormat:@"%d",10],
//                                 @"page":[NSString stringWithFormat:@"%ld",(long)self.reloadIndexPage]
//                                 };
//    if (self.reloadIndexPage <=1) {
//        [self.arrayData removeAllObjects];
//    }
//    [HttpTool postWithBaseURL:kBaseURL path:URL_ACCEPT_HISTORY params:paramDict success:^(NSDictionary *dict) {
//        @try
//        {
//            [SVProgressHUD dismiss];
//            [workTableView.mj_header endRefreshing];
//            [workTableView.mj_footer endRefreshing];
//
//            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
//            [workTableView stopLoadWithState:PullDownLoadState];
//            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
//            {
//                [self.arrayData addObjectsFromArray:[dict objectForKey:@"result"]];
//                [self initUI];
//            }
//            NSLog(@"%@",dict);
//        }
//        @catch (NSException *exception)
//        {
//            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
//        }
//        @finally {
//
//        }
//    } failure:^(NSError *error) {
//
//        [workTableView.mj_header endRefreshing];
//        [workTableView.mj_footer endRefreshing];
//
//        [SVProgressHUD dismiss];
//        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
//    }];
//}
//
////创业币明细
//- (void)requestCoinDetailInfo
//{
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
//    NSDictionary *paramDict =  @{@"id":SAFE_STRING(UID),
//                                 @"md5":SAFE_STRING(MD5),
//                                 @"num":[NSString stringWithFormat:@"%d",10],
//                                 @"page":[NSString stringWithFormat:@"%ld",(long)self.reloadIndexPage]
//                                 };
//    if (self.reloadIndexPage <=1) {
//        [self.arrayData removeAllObjects];
//    }
//    [HttpTool postWithBaseURL:kBaseURL path:URL_COIN_DETAIL params:paramDict success:^(NSDictionary *dict) {
//        @try
//        {
//            [SVProgressHUD dismiss];
//            [workTableView.mj_header endRefreshing];
//            [workTableView.mj_footer endRefreshing];
//
//            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
//            [workTableView stopLoadWithState:PullDownLoadState];
//            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
//            {
//                [self.arrayData addObjectsFromArray:[dict objectForKey:@"result"]];
//                [self initUI];
//            }
//            NSLog(@"%@",dict);
//        }
//        @catch (NSException *exception)
//        {
//            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
//        }
//        @finally {
//
//        }
//    } failure:^(NSError *error) {
//
//        [workTableView.mj_header endRefreshing];
//        [workTableView.mj_footer endRefreshing];
//
//        [SVProgressHUD dismiss];
//        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
//    }];
//}


@end
