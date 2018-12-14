//
//  ThreeViewController.m
//  NB2
//
//  Created by zcc on 16/2/18.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "ThreeViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ThreeViewController ()
{
    TopView *topView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
    CGFloat _celheigh;
    NSArray *array;
    NSArray *arrayTime;

}

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopView];
    self.view.backgroundColor = [UIColor whiteColor];
    arrayData=[[NSMutableArray alloc] init];
    [self initData];
    
    
    // Do any additional setup after loading the view.
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"系统消息";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
    
}
-(void)initUI
{
    [self.mTableView removeFromSuperview];
    self.mTableView = [[TQMultistageTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-SCREEN_HEIGHT/13.34)];
    self.mTableView.dataSource = self;
    self.mTableView.delegate   = self;
    self.mTableView.backgroundColor = [UIColor clearColor];
    self.mTableView.tableView.pullDelegate=self;
    //self.mTableView.tableView.canPullUp=self;
    self.mTableView.tableView.canPullDown=self;
    [self.view addSubview:self.mTableView];
    [self.view bringSubviewToFront:topView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self initUI];
}
-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",1],@"page",[NSString stringWithFormat:@"%d",2],@"type",[NSString stringWithFormat:@"%d",1000],@"num",nil];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestGonggaolist" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            [workTableView stopLoadWithState:PullDownLoadState];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                //[arrayData removeAllObjects];
                arrayData=[[dict objectForKey:@"result"] mutableCopy];
//                if ([arrayData count]>0) {
                    [self initUI];
//                }
                
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
#pragma mark - TQTableViewDataSource

- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TQMultistageTableViewCell";
    //    UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //    if (cell == nil)
    //    {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    //    }
    NSDictionary *diction=[arrayData objectAtIndex:indexPath.section];
    UILabel *timelable=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH, 20)];
    timelable.text=[NSString stringWithFormat:@"%@",[diction objectForKey:@"shijian"]];
    CGSize textsize=[timelable.text sizeWithFont:[UIFont systemFontOfSize:14]];
    timelable.frame=CGRectMake(5, 5, textsize.width+40,textsize.height);
    timelable.textColor=[UIColor whiteColor];
    [cell.contentView addSubview:timelable];
    
    UIWebView *label = [[UIWebView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, 180)];
    NSLog(@"%ld",(long)indexPath.row);
    [label loadHTMLString:[diction objectForKey:@"content"] baseURL:nil];
    //label.text =[NSString stringWithFormat:@"%@",[diction objectForKey:@"content"]];
    //清空背景颜色
    label.backgroundColor = [UIColor clearColor];
    //设置字体颜色为白色
    //label.textColor = [UIColor whiteColor];
    //设置label的背景色为黑色
    label.backgroundColor = [UIColor clearColor];
    //文字居中显示
    //label.textAlignment = NSTextAlignmentLeft;
    //自动折行设置
    //    label.lineBreakMode = NSLineBreakByWordWrapping;
    //    label.numberOfLines = 0;
    //    CGSize rect=[ConvertValue sizeWithString:label.text font:[UIFont systemFontOfSize:13]];
    //    label.frame = CGRectMake(5, CGRectGetMaxY(timelable.frame),SCREEN_WIDTH-10, rect.height+105);
    _celheigh=150;
    [cell.contentView addSubview:label];
    
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds] ;
    view.layer.backgroundColor  = [UIColor whiteColor].CGColor;
    view.layer.masksToBounds    = YES;
    view.layer.borderWidth      = 0.0;
    view.layer.borderColor      = [UIColor colorWithRed:250/255.0 green:77/255.0 blue:83/255.0 alpha:1].CGColor;
    
    cell.backgroundView = view;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bounds=label.frame;
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
    NSLog(@"%f",_celheigh);
    return _celheigh;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForAtomAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForHeaderInSection:(NSInteger)section;
{
    
    NSArray *array1=arrayData;
    UIView *header = [[UIView alloc] init];
    
    UILabel *mylable=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 44)];
    mylable.font=[UIFont systemFontOfSize:14];
    mylable.text=[[array1 objectAtIndex:section] objectForKey:@"title"];
    
    [header addSubview:mylable];
    
    header.layer.backgroundColor    = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    header.layer.masksToBounds      = YES;
    header.layer.borderWidth        = 0.5;
    header.layer.borderColor        = [UIColor colorWithRed:179/255.0 green:143/255.0 blue:195/255.0 alpha:1].CGColor;
    
    return header;
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
-(void)scrollView:(UIScrollView *)scrollView loadWithState:(LoadState)state
{
    if (state == PullDownLoadState)
    {
        [self initData];
    }
    else//加载更多
    {
        int tempPage=[ConvertValue getPageNum:[arrayData count] :10];
        if (tempPage<=0) {
            
            [ToolControl showHudWithResult:NO andTip:@"暂无更多数据！"];
            [workTableView stopLoadWithState:PullUpLoadState];
            return;
        }
        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",tempPage],@"page",[NSString stringWithFormat:@"%d",2],@"type",[NSString stringWithFormat:@"%d",10],@"num",nil];
        
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
        
        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestGonggaolist" params:dicton success:^(NSDictionary *dict) {
            @try
            {
                [SVProgressHUD dismiss];
                [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
                [workTableView stopLoadWithState:PullDownLoadState];
                if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
                {
                    //[arrayData removeAllObjects];
                    arrayData=[[dict objectForKey:@"result"] mutableCopy];
                    //if ([arrayData count]>0) {
                    [self initUI];
                    //}
                    
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
