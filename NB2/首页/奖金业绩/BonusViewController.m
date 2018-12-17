//
//  BonusViewController.m
//  NB2
//
//  Created by zcc on 16/2/20.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "BonusViewController.h"
#import "DetailsViewController.h"
#import "ZhiXiaoViewController.h"
#import "KKSelectionCollectionCell.h"


static NSString *collectionCellid = @"collectionCellid";
@interface BonusViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    TopView *topView;
    UITableView *workTableView;
    int sign;
    NSInteger _indexPage;
    CGFloat _selectionHieght;
}

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *colleDataSource;
@property (nonatomic,copy) NSString *changeType;
@end

@implementation BonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _indexPage = 1;
    _dataSource = [NSMutableArray array];
//    _colleDataSource = @[@"本金钱包",@"红利钱包",@"众购钱包",@"天使资本"];
    _colleDataSource = @[@"本金钱包",@"红利钱包",@"众购钱包"];

    _selectionHieght = 40.f;
    self.changeType = @"2";

    
    
    sign=100;
    [self initTopView];
    
    [self initData];
    // Do any additional setup after loading the view.
}


-(void)actionRight
{
    ZhiXiaoViewController *zhixiao=[[ZhiXiaoViewController alloc]init];
    [self.navigationController pushViewController:zhixiao animated:YES];
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"业绩分红";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    topView.buttonRB=@"直推动态";
    [self.view addSubview:topView];
    [topView setTopView];
    
    NSArray *arraycolcor=[[NSArray alloc] initWithObjects:@"工资奖励",@"钱包明细",@"解冻记录", nil];
    for (int i=0; i<arraycolcor.count; i++)
    {
        UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
        but.frame=CGRectMake(SCREEN_WIDTH/3.0*i, CGRectGetMaxY(topView.frame), SCREEN_WIDTH/3.0, 40);
        but.tag=100+i;
        [but addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
        but.titleLabel.font=[UIFont systemFontOfSize:14];
        if (i==0)
        {
            but.selected=YES;
            [but setBackgroundImage:[UIImage imageNamed:@"licai_sel_bg"] forState:UIControlStateSelected];
            [but setBackgroundImage:[UIImage imageNamed:@"licai_normal_bg"] forState:UIControlStateNormal];
            
        }else if(i==1)
        {
            [but setBackgroundImage:[UIImage imageNamed:@"two"] forState:UIControlStateSelected];
            [but setBackgroundImage:[UIImage imageNamed:@"butnooselect"] forState:UIControlStateNormal];
        }else
        {
            [but setBackgroundImage:[UIImage imageNamed:@"three"] forState:UIControlStateSelected];
            [but setBackgroundImage:[UIImage imageNamed:@"butnooselectbule"] forState:UIControlStateNormal];
        }
        
        [but setTitle:[arraycolcor objectAtIndex:i] forState:UIControlStateNormal];
        [self.view addSubview:but];
    }
    
    [self initTableviewconfig];
    
}
-(void)clickBut:(UIButton *)sneder
{
    _indexPage = 1;
    [self.dataSource removeAllObjects];
    [self colletionViewStateChangeAndChangeFrameState:NO];
    if (sneder.tag==100)
    {
        sneder.selected=YES;
        UIButton *but1=[self.view viewWithTag:101];
        UIButton *but2=[self.view viewWithTag:102];
        but1.selected=NO;
        but2.selected=NO;
        //detalis.namestring=@"分红记录";
        sign=100;
    }
    if (sneder.tag==101)
    {
        [self colletionViewStateChangeAndChangeFrameState:YES];

        sneder.selected=YES;
        UIButton *but1=[self.view viewWithTag:100];
        UIButton *but2=[self.view viewWithTag:102];
        but1.selected=NO;
        but2.selected=NO;
        //detalis.namestring=@"奖金总额";
        sign=101;
    }
    if (sneder.tag==102)
    {
        sneder.selected=YES;
        UIButton *but1=[self.view viewWithTag:100];
        UIButton *but2=[self.view viewWithTag:101];
        but1.selected=NO;
        but2.selected=NO;
        //detalis.namestring=@"解冻记录";
        sign=102;
        
    }
//        [workTableView removeFromSuperview];
//        workTableView=nil;
        [self initData];
    //[self.navigationController pushViewController:detalis animated:YES];
}
-(void)initData
{
    if (_indexPage == 1) {
        [self.dataSource removeAllObjects];
    }
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%ld",(long)_indexPage],@"page",[NSString stringWithFormat:@"%d",10],@"num",nil];
    NSString *urlString=nil;
    if (sign==100) {
//        urlString=@"/api/requestLicaiFenghong";
        urlString=@"/api/requestTuiguang";//2018.12·18修改为推广工资
    }else if (sign==101)
    {
        urlString=@"/api/requestQianbao";
        [dicton setValue:self.changeType forKey:@"type"];
    }else
    {
        urlString=@"/api/requestDongjie";
    }
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:urlString params:dicton success:^(NSDictionary *dict) {
      
            [workTableView.mj_header endRefreshing];
            [workTableView.mj_footer endRefreshing];
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
//            [workTableView stopLoadWithState:PullDownLoadState];
//            [workTableView stopLoadWithState:PullUpLoadState];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                NSArray * arr  = [[dict objectForKey:@"result"] mutableCopy];
                if (!arr.count && _indexPage != 1) {
                    [ToolControl showHudWithResult:NO andTip:@"没有更多数据了"];
                    return ;
                }
                [self.dataSource addObjectsFromArray:arr];
                
            }
            [workTableView reloadData];
            NSLog(@"%@",dict);
     
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        [workTableView.mj_header endRefreshing];
        [workTableView.mj_footer endRefreshing];
    }];
    
    
}
-(void)initTableviewconfig
{
//    [workTableView removeFromSuperview];
    CGFloat tableOriginY = topView.frame.origin.y  +topView.frame.size.height+45;
    workTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,tableOriginY ,SCREEN_WIDTH ,SCREEN_HEIGHT-tableOriginY)];
    workTableView.backgroundColor = [UIColor clearColor];
    workTableView.delegate = self;
    workTableView.dataSource = self;
    workTableView.tableFooterView=[[UIView alloc] init];
//    workTableView.scrollEnabled=YES;
//    workTableView.pullDelegate = self;
//    workTableView.canPullUp = YES;
//    workTableView.canPullDown=YES;
    workTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:workTableView];
    
    workTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _indexPage = 1;
        [self initData];
    }];
    workTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _indexPage++;
        [self initData];
    }];
    
    
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, tableOriginY, SCREEN_WIDTH, _selectionHieght) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[KKSelectionCollectionCell class] forCellWithReuseIdentifier:collectionCellid];
    [self.view  addSubview:_collectionView];
    _collectionView.hidden = YES;

}

- (void)colletionViewStateChangeAndChangeFrameState:(BOOL)showCollectionView
{
    self.collectionView.hidden = !showCollectionView;
    CGRect frame = workTableView.frame;
    if (showCollectionView) {
        frame.origin.y +=  _selectionHieght;
        frame.size.height -= _selectionHieght;
        workTableView.frame = frame;
    }else{
    CGFloat tableOriginY = topView.frame.origin.y  +topView.frame.size.height+45;
    workTableView.frame =CGRectMake(0 ,tableOriginY ,SCREEN_WIDTH ,SCREEN_HEIGHT-tableOriginY);
    }
    
}

- (void)refreshData
{
        _indexPage = 1;
        [self initData];
}

- (void)loadMoreData
{
    _indexPage++;
    [self initData];
}

#pragma mark - TableView
//tab数量1
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//tab一页多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
//tab每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 94;
    
}

-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellId = @"simpleId";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dictTable = nil;
    if (self.dataSource.count > 0) {
      dictTable  = [self.dataSource objectAtIndex:indexPath.row];
    }

    for (UIView *subView in [cell.contentView subviews]) {
        [subView removeFromSuperview];
    }
//    [cell.contentView remove];
    UILabel *tempL11=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH*0.5, 15)];
    tempL11.text= @"订单号：";
    tempL11.textColor=[UIColor grayColor];
    [tempL11 setFont:[UIFont systemFontOfSize:12]];
    tempL11.adjustsFontSizeToFitWidth=YES;
    [cell.contentView addSubview:tempL11];
    
    UILabel *tempL0=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL11.frame), SCREEN_WIDTH*0.5, 20)];
    tempL0.text= [NSString stringWithFormat:@"%@",[dictTable objectForKey:@"orderid"]];
    tempL0.textColor=[UIColor grayColor];
    [tempL0 setFont:[UIFont systemFontOfSize:14]];
    tempL0.adjustsFontSizeToFitWidth=YES;
    [cell.contentView addSubview:tempL0];
    
    UILabel *tempL1=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+15, 3, SCREEN_WIDTH*0.5, 16)];
    tempL1.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    tempL1.text= [NSString stringWithFormat:@"时间：%@",[dictTable objectForKey:@"shijian"]];
    [tempL1 setFont:[UIFont systemFontOfSize:12]];
    [cell.contentView addSubview:tempL1];
    
    
    if (sign==102) {
        
        //金额
        UILabel *tempL3=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL11.frame)+20, SCREEN_WIDTH*0.4, 16)];
        tempL3.textAlignment = NSTextAlignmentLeft;
        tempL3.text=[NSString stringWithFormat:@"金额：%@",[dictTable objectForKey:@"jine"]];
        [tempL3 setFont:[UIFont systemFontOfSize:12]];
        [tempL3 setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:tempL3];
        
        //冻结日期
        UILabel *tempL4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+15, CGRectGetMaxY(tempL1.frame) + 16, SCREEN_WIDTH*0.45, 16)];
        tempL4.textAlignment = NSTextAlignmentLeft;
        tempL4.textColor=[UIColor orangeColor];
        tempL4.text=[NSString stringWithFormat:@"冻结日期：%@",[dictTable objectForKey:@"djshijian"]];
        [tempL4 setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:tempL4];
        
        //解冻日期
        UILabel *tempL5=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL3.frame) + 12, SCREEN_WIDTH*0.4, 16)];
        tempL5.textAlignment = NSTextAlignmentLeft;
        tempL5.text=[NSString stringWithFormat:@"解冻日期：%@",[dictTable objectForKey:@"cjshijian"]];
        [tempL5 setFont:[UIFont systemFontOfSize:12]];
        [tempL5 setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:tempL5];
        
        //周期
        UILabel *tempL6=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+15, CGRectGetMaxY(tempL4.frame) + 15, SCREEN_WIDTH*0.4, 20)];
        tempL6.textAlignment = NSTextAlignmentLeft;
        tempL6.text=[NSString stringWithFormat:@"周期 %@天",[dictTable objectForKey:@"typeid"]];
        [tempL6 setFont:[UIFont boldSystemFontOfSize:14]];
        tempL6.adjustsFontSizeToFitWidth=YES;
        tempL6.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
        [cell.contentView addSubview:tempL6];

    }else if (sign==100)
    {
        tempL11.text = @"序列号";
        tempL0.text = [dictTable objectForKey:@"id"];
        //金额
        UILabel *tempL3=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL11.frame)+30, SCREEN_WIDTH*0.4, 16)];
        tempL3.textAlignment = NSTextAlignmentLeft;
        tempL3.text=[NSString stringWithFormat:@"金额：%@",[dictTable objectForKey:@"jine"]];
        [tempL3 setFont:[UIFont systemFontOfSize:14]];
        [tempL3 setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:tempL3];
        
        
        
        //周期
        UILabel *tempL6=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+15, CGRectGetMaxY(tempL3.frame) - 16, SCREEN_WIDTH*0.4, 20)];
        tempL6.textAlignment = NSTextAlignmentLeft;
        tempL6.text=[NSString stringWithFormat:@"备注 %@",[dictTable objectForKey:@"beizhu"]];
        [tempL6 setFont:[UIFont boldSystemFontOfSize:14]];
        tempL6.adjustsFontSizeToFitWidth=YES;
        tempL6.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
        [cell.contentView addSubview:tempL6];

    }else
    {
        tempL11.text = @"序列号";
        tempL0.text = [dictTable objectForKey:@"id"];
        
        //金额
        UILabel *tempL3=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL11.frame)+20, SCREEN_WIDTH*0.4, 16)];
        tempL3.textAlignment = NSTextAlignmentLeft;
        tempL3.text=[NSString stringWithFormat:@"金额：%@",[dictTable objectForKey:@"num"]];
        [tempL3 setFont:[UIFont systemFontOfSize:12]];
        [tempL3 setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:tempL3];
        
        //冻结日期
        UILabel *tempL4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+15, CGRectGetMaxY(tempL1.frame) + 16, SCREEN_WIDTH*0.45, 16)];
        tempL4.textAlignment = NSTextAlignmentLeft;
        tempL4.textColor=[UIColor orangeColor];
        tempL4.text=[NSString stringWithFormat:@"操作后金额：%@",[dictTable objectForKey:@"nownum"]];
        [tempL4 setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:tempL4];
        
        //解冻日期
        UILabel *tempL5=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL3.frame) + 12, SCREEN_WIDTH*0.4, 16)];
        tempL5.textAlignment = NSTextAlignmentLeft;
        tempL5.text=[NSString stringWithFormat:@"操作前金额：%@",[dictTable objectForKey:@"oldnum"]];
        [tempL5 setFont:[UIFont systemFontOfSize:12]];
        [tempL5 setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:tempL5];
        
        //备注
        UILabel *tempL6=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+15, CGRectGetMaxY(tempL4.frame) + 15, SCREEN_WIDTH*0.4, 20)];
        tempL6.textAlignment = NSTextAlignmentLeft;
        tempL6.text=[NSString stringWithFormat:@"备注：%@",[dictTable objectForKey:@"beizhu"]];
        [tempL6 setFont:[UIFont boldSystemFontOfSize:14]];
        tempL6.adjustsFontSizeToFitWidth=YES;
        tempL6.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
        [cell.contentView addSubview:tempL6];
    }
    
    
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 40)];
    if ([[dictTable objectForKey:@"station"] integerValue]==1) {
        imgview.image=[UIImage imageNamed:@"yidu"];
    }
    [cell.contentView addSubview:imgview];

    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,94-5 , SCREEN_WIDTH, 5)];
    view.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:view];
    
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    cell.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1];
    return cell;
}
//- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state
//{
//    if (state == PullDownLoadState)
//    {
//        _indexPage = 1;
//        [self initData];
//    }
//    else//加载更多
//    {
//        _indexPage++;
//        [self initData];
//        return;
//
////        int tempPage=[ConvertValue getPageNum:[arrayData count] :10];
////        if (tempPage<=0) {
////            [ToolControl showHudWithResult:NO andTip:@"暂无更多数据！"];
////            [workTableView stopLoadWithState:PullUpLoadState];
////            return;
////        }
////        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",tempPage],@"page",[NSString stringWithFormat:@"%d",10],@"num",nil];
////        NSString *urlString=nil;
////        if (sign==100) {
////            urlString=@"/api/requestShishijiangjin";
////        }else if (sign==101)
////        {
////            urlString=@"/api/requestJiangjinzonge";
////
////        }else
////        {
////            urlString=@"/api/requestDongjie";
////        }
////        [SVProgressHUD showWithStatus:@"加载更多中..." maskType:SVProgressHUDMaskTypeBlack];
////        [HttpTool postWithBaseURL:kBaseURL path:urlString params:dicton success:^(NSDictionary *dict) {
////            @try
////            {
////                [SVProgressHUD dismiss];
////                [workTableView stopLoadWithState:PullUpLoadState];
////
////                if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
////                {
////                    NSMutableArray *newarray=[NSMutableArray arrayWithArray:arrayData];
////                    [newarray addObjectsFromArray:[dict objectForKey:@"result"]];
////                    arrayData=newarray;
////                    [self initUI];
////
////                }
////                [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
////                NSLog(@"%@",dict);
////
////            }
////            @catch (NSException *exception)
////            {
////                [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
////
////            }
////            @finally {
////
////            }
////        } failure:^(NSError *error) {
////            [SVProgressHUD dismiss];
////            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
////        }];
////
//    }
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
////    DetailsViewController *detalis=[[DetailsViewController alloc] init];
////    if (sign==100)
////    {
////        detalis.sign=100;
////        detalis.namestring=@"预存分红";
////    }
////    else if (sign==101)
////    {
////        detalis.sign=101;
////        detalis.namestring=@"钱包明细";
////
////    }
////    else
////    {
////        detalis.sign=102;
////        detalis.namestring=@"解冻记录";
////    }
////
////    NSDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
////    detalis.diction=[[NSMutableDictionary alloc] initWithDictionary:dictTable];
////    [self.navigationController pushViewController:detalis animated:YES];
//}


#pragma mark - 选择

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colleDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KKSelectionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
    [cell updateCellWithTitle:self.colleDataSource[indexPath.item]];
    if (indexPath.item == 0) {
        [cell updateCellStateSeleted:YES];
    }else{
        [cell updateCellStateSeleted:NO];
    }
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = SCREEN_WIDTH / self.colleDataSource.count - 10.f;
    return CGSizeMake(width, collectionView.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.000001, 0.000001,0.000001, 0.000001);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.000001;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSInteger i = 0; i < self.colleDataSource.count; i++) {
        NSIndexPath *allIndext = [NSIndexPath indexPathForItem:i inSection:0];
        KKSelectionCollectionCell * cell =   (KKSelectionCollectionCell *) [collectionView cellForItemAtIndexPath:allIndext];
        [cell updateCellStateSeleted:NO];
    }
   KKSelectionCollectionCell * cell =   (KKSelectionCollectionCell *) [collectionView cellForItemAtIndexPath:indexPath];
    [cell updateCellStateSeleted:YES];
    if (indexPath.item == 0) {
        self.changeType = @"2";
    }
    if (indexPath.item == 1) {
        self.changeType = @"3";
    }
    if (indexPath.item == 2) {
        self.changeType = @"4";
    }
//    if (indexPath.item == 3) {
//        self.changeType = @"1";
//    }
    _indexPage = 1;
    [self initData];
   
    
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
