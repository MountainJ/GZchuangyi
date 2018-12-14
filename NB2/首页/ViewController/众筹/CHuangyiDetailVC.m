//
//  CHuangyiDetailVC.m
//  NB2
//
//  Created by Jayzy on 2017/9/3.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "CHuangyiDetailVC.h"
#import <WebKit/WebKit.h>

#import "XXFSliderView.h"
#import "ZhongchouDetailCell.h"

#import "ListRecordCell.h"

#import "CBAdvertisementView.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "KKAlertView.h"

#define SLIDER_HEIGHT   KKFitScreen(60)
#define INFO_HEIGHT     KKFitScreen(230)

#define MARGIN          KKFitScreen(20)
#define ADBANNER_VIEW_WIDTH     (SCREEN_WIDTH - 2 * MARGIN - 2 * MARGIN)
#define ADBANNER_VIEW_HEIGHT    (ADBANNER_VIEW_WIDTH * (210.0/432.0))

#define ORDER_BUTTON_HEIGHT     KKFitScreen(80)


@interface CHuangyiDetailVC ()<WKUIDelegate,WKNavigationDelegate,XXFSliderViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MWPhotoBrowserDelegate,CBAdvertisementViewDelegate>
{
    CGFloat _lastSetPoint;
 }

@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) CBAdvertisementView *adView;
@property (nonatomic,strong) XXFSliderView *sliderView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIProgressView *progressShow;

@property (nonatomic,strong) UILabel *processLabel;
@property (nonatomic,strong) UILabel *goldLabel;
@property (nonatomic,strong) UILabel *silverLabel;
@property (nonatomic,strong) UILabel *personLabel;



@property (nonatomic,strong) WKWebView *detailWebView;
//@property (nonatomic,strong) UIProgressView *progressView;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *pitures;
@property (nonatomic,strong) NSMutableArray *pitureUrls;

@property (nonatomic,strong) NSMutableArray *recordListArr;


@property (nonatomic,strong) ZhongchouModel *detailModel;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger selectedIndex;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UIButton *orderButton;
@property (nonatomic,strong) NSMutableArray *photoes;

@property (nonatomic,strong) KKAlertView *alertView;
@property (nonatomic,copy) NSString *orderNumber;
@property (nonatomic,copy) NSString *orderType;
@end

@implementation CHuangyiDetailVC

- (NSMutableArray *)photoes
{
    if (!_photoes) {
        _photoes = [NSMutableArray array];
    }
    return _photoes;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)recordListArr
{
    if (!_recordListArr) {
        _recordListArr = [NSMutableArray array];
    }
    return _recordListArr;
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

- (KKAlertView *)alertView
{
    if (!_alertView) {
        CGFloat width = SCREEN_WIDTH  - 2 * KKFitScreen(60);
        CGFloat height = KKFitScreen(440);
        _alertView = [[KKAlertView alloc] initWithFrame:CGRectMake(KKFitScreen(60), SCREEN_HEIGHT*0.5 - height * 0.5, width, height)];
    }
    return _alertView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat originY =CGRectGetMaxY(self.headerView.frame);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(MARGIN ,originY , SCREEN_WIDTH - 2 *MARGIN, self.containerView.bounds.size.height - originY) style:UITableViewStylePlain];
        [self setSeparatorWithTableView:_tableView];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.backgroundColor = [UIColor whiteColor];
      
    }
    return _tableView;
    
}

-(UIView *)containerView{
    if(!_containerView){
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE, SCREEN_WIDTH, SCREEN_HEIGHT - (20 + NAV_BAR_HEIGHT+JF_TOP_ACTIVE_SPACE))];
    }
    return _containerView;
}

- (UIView *)headerView
{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, 10, SCREEN_WIDTH -2 * MARGIN, ADBANNER_VIEW_HEIGHT + INFO_HEIGHT + SLIDER_HEIGHT)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

-  (CBAdvertisementView *)adView
{
    if (!_adView) {
        //431*310图片
        //431*210图片
        _adView = [[CBAdvertisementView alloc] initWithFrame:CGRectMake(MARGIN * 2, 10, ADBANNER_VIEW_WIDTH - 2 * MARGIN, ADBANNER_VIEW_HEIGHT) AndUrlArray:self.pitures];
        _adView.dotPosition = PageControlPositionCenter;
        _adView.delegate = self;
    }
    return _adView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFrame:CGRectMake(MARGIN, 10 + ADBANNER_VIEW_HEIGHT, ADBANNER_VIEW_WIDTH, 30) backGroundColor:[UIColor whiteColor] textColor:[UIColor darkTextColor] textFont:[UIFont boldSystemFontOfSize:KKFitScreen(30)] addToView:nil labelText:nil];
    }
    return _nameLabel;
}

- (UIProgressView *)progressShow
{
    if (!_progressShow) {
        _progressShow= [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressShow.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame), CGRectGetWidth(self.nameLabel.frame), 2);
        _progressShow.progressTintColor = COLOR_STATUS_NAV_BAR_BACK;
        _progressShow.trackTintColor = [UIColor lightGrayColor];
//        [_progressShow setProgress:0.5 animated:YES];
    }
    return _progressShow;
}


- (UILabel *)processLabel
{
    if (!_processLabel) {
        _processLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.progressShow.frame), CGRectGetMidX(self.nameLabel.frame) - 40, KKFitScreen(100)) backGroundColor:[UIColor whiteColor] textColor:[UIColor lightGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:nil labelText:nil];
        _processLabel.numberOfLines = 2;
    }
    return _processLabel;
}

- (UILabel *)goldLabel
{
    if (!_goldLabel) {
        _goldLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.processLabel.frame), CGRectGetMinY(self.processLabel.frame), (CGRectGetWidth(self.nameLabel.frame) - CGRectGetWidth(self.processLabel.frame))* 0.5, CGRectGetHeight(self.processLabel.frame)) backGroundColor:[UIColor whiteColor] textColor:[UIColor lightGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:nil labelText:nil];
        _goldLabel.numberOfLines = 2;
        _goldLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goldLabel;
}

- (UILabel *)silverLabel
{
    if (!_silverLabel) {
        _silverLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.goldLabel.frame), CGRectGetMinY(self.processLabel.frame), CGRectGetWidth(self.goldLabel.frame), CGRectGetHeight(self.goldLabel.frame)) backGroundColor:[UIColor whiteColor] textColor:[UIColor lightGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:nil labelText:nil];
        _silverLabel.numberOfLines = 2;
        _silverLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _silverLabel;
}

- (UILabel *)personLabel
{
    if (!_personLabel) {
        _personLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.processLabel.frame), CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame) - SLIDER_HEIGHT - CGRectGetMaxY(self.processLabel.frame)) backGroundColor:COLOR_LIGHTGRAY_BACK textColor:[UIColor lightGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:nil labelText:nil];
    }
    return _personLabel;
}
- (XXFSliderView *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[XXFSliderView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.personLabel.frame),CGRectGetWidth(self.headerView.frame), SLIDER_HEIGHT)];
        _sliderView.delegate = self;
        [_sliderView sliderTextArr:@[@"项目概况",@"众筹方案",@"认筹情况"] sliderLineColor:COLOR_STATUS_NAV_BAR_BACK];
    }
    return _sliderView;
}

- (UIButton *)orderButton
{
    if (!_orderButton) {
        _orderButton = [UIButton buttonWithFrame:CGRectMake(0, self.containerView.bounds.size.height - ORDER_BUTTON_HEIGHT - JF_BOTTOM_SPACE, SCREEN_WIDTH, ORDER_BUTTON_HEIGHT) backGroundColor:COLOR_STATUS_NAV_BAR_BACK textColor:[UIColor whiteColor] clickAction:@selector(buyOrder) clickTarget:self addToView:nil buttonText:@"我要跟投"];
    }
    return _orderButton;
}

-(WKWebView *)detailWebView{
    if(!_detailWebView){
         NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        CGFloat orignY = CGRectGetMaxY(self.headerView.frame);
        _detailWebView =  [[WKWebView alloc] initWithFrame:CGRectMake(MARGIN, orignY, SCREEN_WIDTH -2 * MARGIN, self.containerView.bounds.size.height - orignY) configuration:wkWebConfig];
        _detailWebView.UIDelegate = self;
        _detailWebView.navigationDelegate = self;
        _detailWebView.scrollView.delegate = self;
//        [_detailWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:nil];
//        [_detailWebView.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew||NSKeyValueChangeOldKey context:nil];

    }
    return _detailWebView;
}

//- (UIProgressView *)progressView
//{
//    if (!_progressView) {
//        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.topView.bounds.size.height - 2, SCREEN_WIDTH, 2)];
//        _progressView.trackTintColor = COLOR_STATUS_NAV_BAR_BACK;
//        _progressView.progressTintColor = PROGRESS_COLOR;
//        [self.topView addSubview:_progressView];
//    }
//    return _progressView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.topView.titileTx = self.model.title;
     [self.topView setTopView];
    
     self.page = 1;

     [self initUI];
    
    [self dataRequest];
    
}

-(void)initUI{
    
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.headerView];
    
    [self.headerView addSubview:self.nameLabel];
    [self.headerView addSubview:self.progressShow];
    [self.headerView addSubview:self.processLabel];
    [self.headerView addSubview:self.goldLabel];
    [self.headerView addSubview:self.silverLabel];
    [self.headerView addSubview:self.personLabel];
    [self.headerView addSubview:self.sliderView];
    //
    [self.containerView addSubview:self.detailWebView];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.orderButton];
    
    
    
    WS(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1 ;
        [weakSelf requestListRecord];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requestListRecord];
    }];
    
    //    [self.containerView addSubview:self.detailWebView];
    
}

- (void)dataRequest
{
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5],@"tid":[NSString stringWithFormat:@"%@",self.model.itemID]};
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestZhongchoudetail" params:paramDict success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if (![dict[RequestResponseCodeKey] isEqualToString:RequestResponseCodeValue]) {
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            return ;
        }
        
        if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
        {
            if ([dict[@"result"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dataDict in dict[@"result"]) {
                    ZhongchouModel *model = [[ZhongchouModel alloc] initWithDataDict:dataDict];
                    [self.dataSource addObject:model];
                }
            }else if ([dict[@"result"] isKindOfClass:[NSDictionary class]])
            {
                ZhongchouModel *model = [[ZhongchouModel alloc] initWithDataDict:dict[@"result"]];
                [self.dataSource addObject:model];
            }
            if (self.dataSource.count > 0) {
                self.detailModel  = [self.dataSource firstObject];
                self.detailModel.intro = [self.detailModel.intro stringByReplacingOccurrencesOfString:@"#a#" withString:@"\""];
                self.detailModel.fangan = [self.detailModel.fangan stringByReplacingOccurrencesOfString:@"#a#" withString:@"\""];

//                [self.tableView reloadData];
                [self.detailWebView loadHTMLString:self.detailModel.intro baseURL:nil];
                NSArray * pics = [self.detailModel.pic componentsSeparatedByString:@"|"];
                if (pics.count > 0) {
                    [self.pitures addObjectsFromArray:pics];
                    [self.headerView addSubview:self.adView];
                    for (NSString *str in pics) {
                        NSURL *url = [NSURL URLWithString:str];
                        [self.pitureUrls addObject:url];
                    }
                }
                [self updateIntroduceInfo];
            }
            [self requestListRecord];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
}

- (void)requestListRecord
{
    if (self.page == 1) {
        [self.recordListArr removeAllObjects];
    }
    
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5],@"tid":[NSString stringWithFormat:@"%@",self.model.itemID],@"num":[NSString stringWithFormat:@"%d",10],@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestToubiaolist" params:paramDict success:^(NSDictionary *dict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
                    
                    RecordListModel * model = [[RecordListModel alloc] initWithDataDict:dataDict];
                    [self.recordListArr addObject:model];
                }
            }else if ([dict[@"result"] isKindOfClass:[NSDictionary class]])
            {
                RecordListModel * model = [[RecordListModel alloc] initWithDataDict:dict[@"result"]];
                [self.recordListArr addObject:model];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
}


- (void)updateIntroduceInfo
{
    self.nameLabel.text = self.detailModel.title;
    
    CGFloat progress = [self.detailModel.yitou floatValue] / [self.detailModel.totel floatValue];
    [self.progressShow setProgress:progress animated:YES];
    if (progress   == 1) {
        [self.orderButton removeFromSuperview];
    }
    
    NSString *proceOrigin = [NSString stringWithFormat:@"众筹创益币\n%.0f/%.0f",[self.detailModel.yitou floatValue],[self.detailModel.totel floatValue]];
    NSString *changeProcess = [NSString stringWithFormat:@"%.0f/%.0f",[self.detailModel.yitou floatValue],[self.detailModel.totel floatValue]];
    [self.processLabel setAttribute:proceOrigin ChangeStr:changeProcess Color:[UIColor orangeColor]];
    
    NSString *goldOrigin = [NSString stringWithFormat:@"每份所需金币\n%@",self.detailModel.jinbi];
    NSString *changegold = [NSString stringWithFormat:@"%@",self.detailModel.jinbi];
    [self.goldLabel setAttribute:goldOrigin ChangeStr:changegold Color:[UIColor orangeColor]];

    NSString *silverOrigin = [NSString stringWithFormat:@"每份所需银币\n%@",self.detailModel.yinbi];
    NSString *changeSilver = [NSString stringWithFormat:@"%@",self.detailModel.yinbi];
    [self.silverLabel setAttribute:silverOrigin ChangeStr:changeSilver Color:[UIColor orangeColor]];
    
    self.personLabel.text = [NSString stringWithFormat:@"   发起人：%@",self.detailModel.faqi];
    
}




#ifdef NSFoundationVersionNumber_iOS_9_x_Max
- (void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
//        if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]) {
//            [self.progressView setProgress:self.detailWebView.estimatedProgress animated:YES];
//            if (self.detailWebView.estimatedProgress == 1.0) {
//                [self.progressView removeFromSuperview];
//                self.progressView = nil;
//            }
//        }
    
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
//        CGPoint newPoint = (CGPoint )[change objectForKey:NSKeyValueChangeNewKey];
//        CGPoint oldPoint =   (CGPoint )[change objectForKey:NSKeyValueChangeOldKey] ;
//        CGFloat newValue = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
//        CGFloat oldValue = [[change objectForKey:NSKeyValueChangeOldKey] floatValue];
//        if (newValue  < 0 && (fabs(newValue) - fabs(oldValue)) > 0) {
//            //向上滑动，值越来越大，在浏览
//            self.orderButton.transform = CGAffineTransformMakeTranslation(0, ORDER_BUTTON_HEIGHT);
//        }else{
//            self.orderButton.transform = CGAffineTransformIdentity;
//
//        }
//    }
}
#endif


#pragma mark - WKWebview delegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    NSString *requestString =  [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark - 滑块滑动
- (void)seletIndex:(NSInteger)selectIndex
{
    self.selectedIndex = selectIndex;
    
    if (selectIndex == 0) {
        
        self.tableView.hidden = YES;
        self.detailWebView.hidden = NO;
        [self.detailWebView loadHTMLString:self.detailModel.intro baseURL:nil];
        
    }else if (selectIndex == 1){
        self.tableView.hidden = YES;
        self.detailWebView.hidden = NO;
        [self.detailWebView loadHTMLString:self.detailModel.fangan baseURL:nil];
    }else if (selectIndex == 2){
       //展示项目详情
        self.detailWebView.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (scrollView == self.detailWebView.scrollView) {
        CGFloat  offSet = scrollView.contentOffset.y;
        if (offSet > 0 && ((fabs(offSet) - fabs(_lastSetPoint) > 0 ))) {
            [UIView animateWithDuration:0.5 animations:^{
                self.orderButton.transform = CGAffineTransformMakeTranslation(0, ORDER_BUTTON_HEIGHT + JF_BOTTOM_SPACE);
            }];
//            self.containerView.transform = CGAffineTransformMakeTranslation(0, - ADBANNER_VIEW_HEIGHT - KKFitScreen(100));
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                self.orderButton.transform = CGAffineTransformIdentity;
            }];
        }
        _lastSetPoint = offSet;
        
//    }
}


#pragma mark - delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LIST_CELL_HEIGHT * 3 + KKFitScreen(10);
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedIndex == 0 || self.selectedIndex == 1) {
        return 1;
    }
    return  self.recordListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == 0 || self.selectedIndex == 1) {
        static NSString *cellID = @"ZhongchouDetailCell";
        ZhongchouDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ZhongchouDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        self.selectedIndex == 1 ?  [cell loadHtmlString:self.detailModel.fangan] : [cell loadHtmlString:self.detailModel.intro];
        return cell;
    }
    
    static NSString *cellID = @"ListRecordCell";
    ListRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ListRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    RecordListModel * model = [self.recordListArr objectAtCheckIndex:indexPath.row];
    cell.model = model;
    return cell;
}



#pragma mark -  我要跟投
- (void)buyOrder
{
    [self.alertView showInPresentedViewController:self userDataInfo:self.detailModel];
    WS(weakSelf)
    [self.alertView didSureBuy:^(NSString *numbers, NSString *type) {
        weakSelf.orderNumber = numbers;
        weakSelf.orderType = type;
        [weakSelf dealFollowData];
    }];
}

#pragma mark - 商品兑换下单

- (void)dealFollowData;
{
    [SVProgressHUD showWithStatus:@"跟投中..." maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *paramDict = @{@"id":[NSString stringWithFormat:@"%@",UID],@"md5":[NSString stringWithFormat:@"%@",MD5],@"tid":[NSString stringWithFormat:@"%@",self.model.itemID],@"num":self.orderNumber,@"type":self.orderType};
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestToubiao" params:paramDict success:^(NSDictionary *dict) {
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
            [ToolControl showHudWithResult:NO andTip:@"跟投成功!"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
    
}




- (void)setSeparatorWithTableView:(UITableView *)tableView
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

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

- (void)dealloc
{
//            if(_detailWebView){
////                [self.detailWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
//                [self.detailWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
//            }
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
