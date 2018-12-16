//
//  TwoViewController.m
//  NB2
//
//  Created by zcc on 16/2/18.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "TwoViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface TwoViewController ()
{
    TopView *topView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
    CGFloat _celheigh;
    NSArray *array;
    NSArray *arrayTime;
}
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopView];
    self.view.backgroundColor = [UIColor whiteColor];
    arrayData=[[NSMutableArray alloc] init];
    [self initData];
    //[self initUI];

    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)initUI
{
    [self.mTableView removeFromSuperview];
    self.mTableView = [[TQMultistageTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-SCREEN_HEIGHT/13.34)];
    self.mTableView.dataSource = self;
    self.mTableView.delegate   = self;
    self.mTableView.backgroundColor = [UIColor clearColor];
    self.mTableView.tableView.pullDelegate=self;
    self.mTableView.tableView.canPullDown=self;
    [self.view addSubview:self.mTableView];
}


-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",1],@"page",[NSString stringWithFormat:@"%d",1],@"type",[NSString stringWithFormat:@"%d",1000],@"num",nil];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestGonggaolist" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            [workTableView stopLoadWithState:PullDownLoadState];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                arrayData=[[dict objectForKey:@"result"] mutableCopy];
                [self initUI];
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
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
    
    
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"系统公告";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
    
}
#pragma mark - TQTableViewDataSource

- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TQMultistageTableViewCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    NSDictionary *diction=[arrayData objectAtIndex:indexPath.section];
    UIWebView *label = [[UIWebView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, 180)];
    label.backgroundColor=[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    NSLog(@"%ld",(long)indexPath.row);
    [label loadHTMLString:[diction objectForKey:@"content"] baseURL:nil];
    [cell addSubview:label];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView
{
    return [arrayData count];
}

#pragma mark - Table view delegate

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

//- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForAtomAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}

- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    NSArray *array1=arrayData;
    
    UILabel *mylable=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 44)];
    
    mylable.text=[[array1 objectAtIndex:section] objectForKey:@"title"];
    mylable.font=[UIFont systemFontOfSize:14];
    [header addSubview:mylable];
    return header;
}
-(void)scrollView:(UIScrollView *)scrollView loadWithState:(LoadState)state
{
    if (state == PullDownLoadState)
    {
        [self initData];
    }
    else//加载更多
    {
//        int tempPage=[ConvertValue getPageNum:[arrayData count] :18];
////        if (tempPage<=0) {
////            
////            [ToolControl showHudWithResult:NO andTip:@"暂无更多数据！"];
////            [workTableView stopLoadWithState:PullUpLoadState];
////            [workTableView reloadData];
////            return;
////        }
//        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",tempPage==0?1000:tempPage],@"page",@"1",@"type",[NSString stringWithFormat:@"%d",18],@"num",nil];
//        
//        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
//        //[ToolControl showHudWithTip:@"加载中..."];
//        
//        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestGonggaolist" params:dicton success:^(NSDictionary *dict) {
//            @try
//            {
//                [SVProgressHUD dismiss];
//                [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
//                [workTableView stopLoadWithState:PullUpLoadState];
//                if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
//                {
//                    NSMutableArray *newarray=[NSMutableArray arrayWithArray:arrayData];
//                    [newarray addObjectsFromArray:[dict objectForKey:@"result"]];
//                    arrayData=newarray;
//                    [self initUI];
//                    
//                }
//                
//                NSLog(@"%@",dict);
//            }
//            @catch (NSException *exception)
//            {
//                [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
//            }
//            @finally {
//                
//            }
//        } failure:^(NSError *error) {
//            NSLog(@"%@",error);
//            [self showError:error];
//        }];
        
    }
}
- (void)mTableView:(TQMultistageTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow ----%ld",(long)indexPath.row);
}

#pragma mark - Header Open Or Close

- (void)mTableView:(TQMultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section
{
    NSLog(@"Open Header ----%ld",(long)section);
}

- (void)mTableView:(TQMultistageTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section
{
    NSLog(@"Close Header ---%ld",(long)section);
}

#pragma mark - Row Open Or Close

- (void)mTableView:(TQMultistageTableView *)mTableView willOpenRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Open Row ----%ld",(long)indexPath.row);
}

- (void)mTableView:(TQMultistageTableView *)mTableView willCloseRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Close Row ----%ld",(long)indexPath.row);
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
