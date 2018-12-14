//
//  ShopDetailInfoVC.m
//  NB2
//
//  Created by Jayzy on 2017/9/5.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ShopDetailInfoVC.h"

#import "CBAdvertisementView.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

#import <WebKit/WebKit.h>

#import "ModifyLocationCell.h"
#import "ShopInfoCell.h"

#import "KKAlertView.h"
#import "GZShopAlertView.h"

#import "AddressListVC.h"

#define MARGIN          KKFitScreen(20)
#define ADBANNER_VIEW_WIDTH     (SCREEN_WIDTH)
//#define ADBANNER_VIEW_HEIGHT    (ADBANNER_VIEW_WIDTH * (210.0/432.0))
#define ADBANNER_VIEW_HEIGHT    (SCREEN_HEIGHT * 0.5)

@interface ShopDetailInfoVC ()<UITableViewDelegate,UITableViewDataSource,CBAdvertisementViewDelegate,MWPhotoBrowserDelegate,WKUIDelegate,WKNavigationDelegate,ShopInfoCellDelegate,ModifyLocationCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CBAdvertisementView *adView;
@property (nonatomic,strong) NSMutableArray *pitures;
@property (nonatomic,strong) NSMutableArray *pitureUrls;
@property (nonatomic,strong) NSMutableArray *photoes;

@property (nonatomic,strong) WKWebView *detailWebView;

@property (nonatomic,strong) GoodsModel *detailModel;
@property (nonatomic,strong) LocationModel *defLoactionModel;

@property (nonatomic,strong) GZShopAlertView *alertView;

@property (nonatomic,copy) NSString *orderNumber;
@property (nonatomic,copy) NSString *orderType;

@property (nonatomic,strong) NSMutableArray *payitemsArray;

@end

@implementation ShopDetailInfoVC

- (NSMutableArray *)payitemsArray
{
    if (!_payitemsArray) {
        _payitemsArray = [NSMutableArray array];
    }
    return _payitemsArray;
}

- (NSMutableArray *)pitures
{
    if (!_pitures) {
        _pitures = [NSMutableArray array];
    }
    return _pitures;
}
- (NSMutableArray *)pitureUrls
{
    if (!_pitureUrls) {
        _pitureUrls = [NSMutableArray array];
    }
    return _pitureUrls;
}
- (NSMutableArray *)photoes
{
    if (!_photoes) {
        _photoes = [NSMutableArray array];
    }
    return _photoes;
}

- (GZShopAlertView *)alertView
{
    if (!_alertView) {
        CGFloat margin = KKFitScreen(60.);
        CGFloat width = SCREEN_WIDTH  - 2 * margin;
        CGFloat payitemHeight = KKFitScreen(50.);//支付方式一行的高度设置为50.
        NSInteger payNumbers = self.payitemsArray.count; //(0~7个)， 一行最多放置 3个支付类型，进行分布
        CGFloat height = KKFitScreen(420) + payitemHeight * (payNumbers / 3 + 1);//原来高度+新增支付类型1行的高度
        _alertView = [[GZShopAlertView alloc] initWithFrame:CGRectMake(margin, SCREEN_HEIGHT*0.5 - height * 0.5, width, height)];
    }
    return _alertView;
}

-  (CBAdvertisementView *)adView
{
    if (!_adView) {
        _adView = [[CBAdvertisementView alloc] initWithFrame:CGRectMake(0, 0, ADBANNER_VIEW_WIDTH, ADBANNER_VIEW_HEIGHT) AndUrlArray:self.pitures];
        _adView.dotPosition = PageControlPositionCenter;
        _adView.delegate = self;
    }
    return _adView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,20 + NAV_BAR_HEIGHT +JF_TOP_ACTIVE_SPACE , SCREEN_WIDTH, SCREEN_HEIGHT - (20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE )) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_LIGHTGRAY_BACK;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
    
}

-(WKWebView *)detailWebView{
    if(!_detailWebView){
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        _detailWebView =  [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2) configuration:wkWebConfig];
        _detailWebView.UIDelegate = self;
        _detailWebView.navigationDelegate = self;
        _detailWebView.scrollView.scrollEnabled = NO;
//        _detailWebView.scrollView.delegate = self;
//        NSString *context= @"das";
//        [_detailWebView.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionNew context:&context];
        
    }
    return _detailWebView;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.topView.titileTx = self.model.title;
    self.topView.titileTx = @"商品详情";
    [self.topView setTopView];
    
    [self dataRequest];
    
    [self requstUserLocation];


}




- (void)dataRequest
{
    
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5],@"tid":[NSString stringWithFormat:@"%@",self.model.itemID]};
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestShopdetailnew" params:paramDict success:^(NSDictionary *dict) {
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
            if ([dict[@"result"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dataDict in dict[@"result"]) {
                    GoodsModel *model = [[GoodsModel alloc] initWithDataDict:dataDict];
                    self.detailModel = model;
                }
                NSDictionary *payDict = [dict[@"result"] firstObject];
                if ([payDict[@"yinbijiage"] integerValue] > 0) {
                    NSDictionary *typeDict = @{kPayitemNameKey:@"银币",kPayitemTypeKey:@"0"};
                    [self.payitemsArray addObject:typeDict];
                }
                if ([payDict[@"jinbijiage"] integerValue] > 0) {
                    NSDictionary *typeDict = @{kPayitemNameKey:@"金币",kPayitemTypeKey:@"1"};
                    [self.payitemsArray addObject:typeDict];
                }
                if ([payDict[@"licaijiage"] integerValue] > 0) {
                    NSDictionary *typeDict = @{kPayitemNameKey:@"理财钱包",kPayitemTypeKey:@"2"};
                    [self.payitemsArray addObject:typeDict];
                }
                if ([payDict[@"fushujiage"] integerValue] > 0) {
                    NSDictionary *typeDict = @{kPayitemNameKey:@"负数钱包",kPayitemTypeKey:@"3"};
                    [self.payitemsArray addObject:typeDict];
                }
                if ([payDict[@"zhonggoujiage"] integerValue] > 0) {
                    NSDictionary *typeDict = @{kPayitemNameKey:@"众购钱包",kPayitemTypeKey:@"4"};
                    [self.payitemsArray addObject:typeDict];
                }
                if ([payDict[@"tianshijiage"] integerValue] > 0) {
                    NSDictionary *typeDict = @{kPayitemNameKey:@"天使资本",kPayitemTypeKey:@"5"};
                    [self.payitemsArray addObject:typeDict];
                }
                if ([payDict[@"jifenjiage"] integerValue] > 0) {
                    NSDictionary *typeDict = @{kPayitemNameKey:@"购物积分",kPayitemTypeKey:@"6"};
                    [self.payitemsArray addObject:typeDict];
                }
            }else if ([dict[@"result"] isKindOfClass:[NSDictionary class]])
            {
                GoodsModel * model = [[GoodsModel alloc] initWithDataDict:dict[@"result"]];
                self.detailModel = model;

            }
           
            
            self.detailModel.content = [self.detailModel.content stringByReplacingOccurrencesOfString:@"#a#" withString:@"\""];
            self.detailModel.pic = [self.detailModel.pic stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray * pics = [self.detailModel.pic componentsSeparatedByString:@"|"];
            if (pics.count > 0) {
                [self.pitures addObjectsFromArray:pics];
                self.tableView.tableHeaderView = self.adView;
                for (NSString *str in pics) {
                    NSURL *url = [NSURL URLWithString:str];
                    if (url) {
                        [self.pitureUrls addObject:url];
                    }
                }
            }
            [self.tableView setTableFooterView:self.detailWebView];
            
            [self.tableView reloadData];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.detailWebView loadHTMLString:self.detailModel.content baseURL:nil];
            });

        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
}

- (void)requstUserLocation
{
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5],@"num":[NSString stringWithFormat:@"%d",20],@"page":[NSString stringWithFormat:@"%ld",(long)1]};
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestDizhilist" params:paramDict success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if (![dict isKindOfClass:[NSDictionary class]]) {
//            [self.tableView reloadData];
            return ;
        }
        if (![dict[RequestResponseCodeKey] isEqualToString:RequestResponseCodeValue]) {
//            [self.tableView reloadData];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            return ;
        }
        if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
        {
            if ([dict[@"result"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dataDict in dict[@"result"]) {
                    LocationModel *model = [[LocationModel alloc] initWithDataDict:dataDict];
                    if ([model.type integerValue]) {
                        self.defLoactionModel = model;
                    }
                }
            }else if ([dict[@"result"] isKindOfClass:[NSDictionary class]])
            {
                LocationModel * model = [[LocationModel alloc] initWithDataDict:dict[@"result"]];
                self.defLoactionModel = model;
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return LOCATION_CELL_HEIGHT * 3 + KKFitScreen(120);
    }
    return KKFitScreen(200);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KKFitScreen(0.0001);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"ShopInfoCell";
        ShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ShopInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        cell.model = self.detailModel;
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellID = @"ModifyLocationCell";
        ModifyLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ModifyLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;

        }
        [cell updateUIWithModel:self.defLoactionModel];
        return cell;
    }
    static NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"1";
    return cell;
}

#pragma mark - 兑换
-(void)ShopInfoCell:(ShopInfoCell *)cell action:(id)action
{
    if ([action isKindOfClass:[GoodsModel class]]) {
        GoodsModel *model = (GoodsModel *)action;
        NSArray *arr = [self.payitemsArray copy];
        [self.alertView showInPresentedViewController:self paymentItems:arr userDataInfo:model];
        WS(weakSelf)
        [self.alertView didSureBuy:^(NSString *numbers, NSString *type) {
            weakSelf.orderNumber = numbers;
            weakSelf.orderType = type;
            [weakSelf orderProduct];
        }];
    }
}

#pragma mark - 商品兑换下单

- (void)orderProduct
{
    [SVProgressHUD showWithStatus:@"兑换中..." maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5],@"tid":[NSString stringWithFormat:@"%@",self.model.itemID],@"num":self.orderNumber,@"type":self.orderType};
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestBuy" params:paramDict success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            if ([dict isKindOfClass:[NSError class]]) {
                NSError *error = (NSError *)dict;
                [ToolControl showHudWithResult:NO andTip:error.localizedDescription];
            }
            return ;
        }
        if (![dict[RequestResponseCodeKey] isEqualToString:RequestResponseCodeValue]) {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            return ;
        }
        if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
        {
            [ToolControl showHudWithResult:NO andTip:@"兑换成功!"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
    
}


#pragma mark - webview delegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.detailWebView evaluateJavaScript:@"document.body.offsetHeight"completionHandler:^(id result,NSError * error) {
        //获取页面高度，并重置webview的frame
       CGFloat _webViewHeight = [result doubleValue];
        CGRect frame =self.detailWebView.frame;
        frame.size.height =_webViewHeight + KKFitScreen(60);
        self.detailWebView.frame = frame;
        [self.tableView setTableFooterView:self.detailWebView];
    }];
    
}

//- (void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    
////        if (context && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
////            CGSize fittingSize = [self.detailWebView sizeThatFits:CGSizeZero];
////            self.detailWebView.frame = CGRectMake(0, 0, fittingSize.width, fittingSize.height);
////            [self.tableView beginUpdates];
////            [self.tableView setTableFooterView:self.detailWebView];
////            [self.tableView endUpdates];
////          
////        }
//}



#pragma mark - 浏览选择图片

-(void)TapAtIndex:(NSInteger)index{
    [self showPhotoBrowser:self.pitureUrls index:index];
}
-(void)showPhotoBrowser:(NSArray*)imageArray index:(NSInteger)currentIndex{
    
    [self.photoes removeAllObjects];
    NSMutableArray *showArray = [NSMutableArray array];
    [showArray addObjectsFromArray:imageArray];
    for (id object in showArray) {
        MWPhoto *photo;
        if ([object isKindOfClass:[UIImage class]]) {
            photo = [MWPhoto photoWithImage:object];
        }
        else if ([object isKindOfClass:[NSURL class]]) {
            photo = [MWPhoto photoWithURL:object];
        } else if ([object isKindOfClass:[NSString class]]) {
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:object]];
        }
        [self.photoes addObject:photo];
    }
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.displayActionButton = YES;
    photoBrowser.displayNavArrows = NO;
    photoBrowser.displaySelectionButtons = NO;
    photoBrowser.alwaysShowControls = NO;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableGrid = YES;
    photoBrowser.startOnGrid = NO;
    photoBrowser.enableSwipeToDismiss = YES;
    photoBrowser.isOpen = YES;
    [photoBrowser setCurrentPhotoIndex:currentIndex];
    [self.navigationController pushViewController:photoBrowser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.photoes.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.photoes.count) {
        return self.photoes[index];
    }
    return nil;
}

#pragma mark - 修改收获地址

- (void)ModifyLocationCell:(ModifyLocationCell *)cell clickAciton:(id)action
{
    AddressListVC *listVC = [[AddressListVC alloc] init];
    WS(weakSelf)
    [listVC didChooseAddressBlock:^(id object) {
        if (![weakSelf.defLoactionModel.itemID isEqualToString:[(LocationModel *)object itemID]] ) {
            //修改默认地址展示：
            
            [weakSelf updateDefaultAddressWithModel:(LocationModel *)object];
        }
        
    }];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)updateDefaultAddressWithModel:(LocationModel *)model
{
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
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
            self.defLoactionModel = model;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];


}


- (void)dealloc
{

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
