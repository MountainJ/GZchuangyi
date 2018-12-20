//
//  AtiinateViewController.m
//  NB2
//
//  Created by zcc on 16/2/20.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "AtiinateViewController.h"
#import "JMCell.h"

static NSString *identifier = @"JMCell";
@interface AtiinateViewController ()
{
    TopView *topView;
    UITableView *_tableView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
    NSString *user;
}

@property (nonatomic,strong) NSDictionary  *selectDict;

@end

@implementation AtiinateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTopView];
    [self initData];

    // Do any additional setup after loading the view.
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"消耗创业币激活";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
}
-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",1],@"page",[NSString stringWithFormat:@"%d",10],@"num",nil];
    
    [SVProgressHUD showWithStatus:@"获取中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestJihuouserlist" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            [workTableView stopLoadWithState:PullDownLoadState];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                //[arrayData removeAllObjects];
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
-(void)initUI
{
    [workTableView removeFromSuperview];
    workTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,topView.frame.origin.y+topView.frame.size.height+5 ,SCREEN_WIDTH ,SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-5)];
    workTableView.backgroundColor = [UIColor clearColor];
    workTableView.delegate = self;
    workTableView.dataSource = self;
    workTableView.tableFooterView=[[UIView alloc] init];
    workTableView.scrollEnabled=YES;
    workTableView.pullDelegate = self;
    workTableView.canPullUp = YES;
    workTableView.canPullDown=YES;
    workTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:workTableView];
    if ([arrayData count]>10)
    {
        [ConvertValue scrollTableToNum:YES :10 :workTableView];
    }

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
    return arrayData.count;
}
//tab每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 103;
    
}

//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *tempL0=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH*0.5, 20)];
    tempL0.text= [NSString stringWithFormat:@"%@",[dictTable objectForKey:@"user"]];
    tempL0.textColor=[UIColor grayColor];
    [tempL0 setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:tempL0];
    
    UILabel *tempL1=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL0.frame), SCREEN_WIDTH*0.5, 20)];
    tempL1.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    if ([dictTable[@"station"] integerValue] ==1 ) {//已经激活
        tempL1.text=[NSString stringWithFormat:@"激活时间:%@",dictTable[@"jhshijian"]];
    }else{//注册时间
        tempL1.text=[NSString stringWithFormat:@"注册时间:%@",dictTable[@"shijian"]];
    }
    [tempL1 setFont:[UIFont systemFontOfSize:12]];
    [cell addSubview:tempL1];
    
    
    UILabel *tempL2=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL1.frame)+20, SCREEN_WIDTH*0.18, 20)];
    tempL2.textAlignment = NSTextAlignmentLeft;
    tempL2.text=[dictTable objectForKey:@"name"];
    tempL2.adjustsFontSizeToFitWidth=YES;
    [tempL2 setFont:[UIFont boldSystemFontOfSize:14]];
    [tempL2 setTextColor:[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1]];
    [cell addSubview:tempL2];
    
    UILabel *tempL22=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tempL2.frame), CGRectGetMaxY(tempL1.frame)+20, SCREEN_WIDTH*0.2, 20)];
    tempL22.textAlignment = NSTextAlignmentLeft;
//    tempL22.text=@"普通会员";
    tempL22.text=@"";
    [tempL22 setFont:[UIFont systemFontOfSize:13]];
    [tempL22 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL22];
    
    
    //金额
    UILabel *tempL5=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+5, CGRectGetMaxY(tempL0.frame)+10, SCREEN_WIDTH*0.4, 18)];
    tempL5.textAlignment = NSTextAlignmentLeft;
    tempL5.text=@"手机：";
    [tempL5 setFont:[UIFont systemFontOfSize:12]];
    [tempL5 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL5];
    
    //金额
    UILabel *tempL6=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+5, CGRectGetMaxY(tempL5.frame), SCREEN_WIDTH*0.4, 20)];
    tempL6.textAlignment = NSTextAlignmentLeft;
    tempL6.text=[dictTable objectForKey:@"phone"];
    [tempL6 setFont:[UIFont boldSystemFontOfSize:14]];
    tempL6.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
    [cell addSubview:tempL6];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,103-5 , SCREEN_WIDTH, 5)];
    view.backgroundColor=[UIColor whiteColor];
    [cell addSubview:view];
    
    
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 40)];
    if ([[dictTable objectForKey:@"station"] integerValue]==1)
    {
        
        imgview.image=[UIImage imageNamed:@"yijihuo"];
    }else if([[dictTable objectForKey:@"station"] integerValue]==0)
    {
        imgview.image=[UIImage imageNamed:@"weijihuo"];
    }
    [cell addSubview:imgview];
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    cell.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1];
    return cell;
}
- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state
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
        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",tempPage],@"page",[NSString stringWithFormat:@"%d",10],@"num",nil];
        
        [SVProgressHUD showWithStatus:@"加载更多中..." maskType:SVProgressHUDMaskTypeBlack];
        
        //        NSMutableString *post2 = nil;
        //        post2=[HttpTool getDataString:dicton];
        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestJihuouserlist" params:dicton success:^(NSDictionary *dict) {
            @try
            {
                [SVProgressHUD dismiss];
                [workTableView stopLoadWithState:PullUpLoadState];
                [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
                if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
                {
                    NSMutableArray *newarray=[NSMutableArray arrayWithArray:arrayData];
                    [newarray addObjectsFromArray:[dict objectForKey:@"result"]];
                    arrayData=newarray;
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
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
    self.selectDict = dictTable;
    if ([[dictTable objectForKey:@"station"] integerValue]==0)
//    if ([[dictTable objectForKey:@"station"] integerValue]==1)
    {
        //这里弹出来一个提示，是否要进行激活
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要激活吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入激活码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
//        [alertView show];
//        UITextField *tf=[alertView textFieldAtIndex:0];
//        tf.keyboardType=UIKeyboardTypeDefault;
//        tf.placeholder=@"请输入激活码";
//        user=[dictTable objectForKey:@"user"];
       //

    }else
    {
        [ToolControl showHudWithResult:NO andTip:@"此会员已经激活"];
    }
    

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1)
    {
        //新接口只需要传一个会员id过去
        [self requestUserJihuo];
        return;
        
//        //以下是原接口需要的激活码
//        if([alertView textFieldAtIndex:0].text.length==0)
//        {
//            [ToolControl showHudWithResult:NO andTip:@"激活码为空"];
//            return;
//        }
//        //[SVProgressHUD showWithStatus:@"验证中..." maskType:SVProgressHUDMaskTypeBlack];
//        NSDictionary *param = @{@"title":[alertView textFieldAtIndex:0].text,@"type":@"3"};
//        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestCheckuserinfo" params:param success:^(NSDictionary *dict){
//
//            @try
//            {
//                //[SVProgressHUD dismiss];
//                [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
//                if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
//                {
//                    UITextField *tf=[alertView textFieldAtIndex:0];
//                    [self getJihuo:tf.text logn:user];
//                }else
//                {
//                    return ;
//                }
//            }
//            @catch (NSException *exception) {
//                [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
//                return ;
//            }
//            @finally {
//
//            }
//            // [ToolControl hideHud];
//
//        } failure:^(NSError *error) {
//            return ;
//            [ToolControl hideHud];
//            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
//        }];
        
    }


}


- (void)requestUserJihuo
{
    NSDictionary *paramDict =  @{ @"id":SAFE_STRING(UID),
                                  @"md5":SAFE_STRING(MD5),
                                  @"tid":SAFE_STRING(self.selectDict[@"id"])
                                  };
    [SVProgressHUD showWithStatus:@"激活中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestJihuo" params:paramDict success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                [self initData];
            }
            NSLog(@"%@",dict);
        }
        @catch (NSException *exception)
        {
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
}


-(void)getJihuo:(NSString *)jihuooma logn:(NSString *)zhanghao
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%@",zhanghao],@"user",[NSString stringWithFormat:@"%@",jihuooma],@"jihuoma",nil];
    
    [SVProgressHUD showWithStatus:@"激活中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestJihuo" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                [self initData];
                
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


-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
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
