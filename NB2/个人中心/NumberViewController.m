//
//  NumberViewController.m
//  NB2
//
//  Created by zcc on 16/2/19.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "NumberViewController.h"
#import "CopyLable.h"
#import "NumberListViewController.h"
@interface NumberViewController ()
{
    TopView *topView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
    int tempPage;
    UIAlertView *customAlertView;
}
@end

@implementation NumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTopView];
    tempPage=1;
    arrayData=[[NSMutableArray alloc] init];
    [self initTopView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
    
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"我的激活码";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
    
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(SCREEN_WIDTH-50, 35+JF_TOP_ACTIVE_SPACE, 40, 20)];
    [button2 setBackgroundColor:[UIColor clearColor]];
    [button2 setTitle:@"更多" forState:UIControlStateNormal];
    button2.titleLabel.font=[UIFont systemFontOfSize:14];
    [button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
}
-(void)buttonClicked:(UIButton *)sender
{
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"转让" otherButtonTitles:@"转让记录", nil];
    [action showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        if (customAlertView==nil) {
            customAlertView = [[UIAlertView alloc] initWithTitle:@"转让信息" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil,nil];
        }
        [customAlertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        
        UITextField *nameField = [customAlertView textFieldAtIndex:0];
        nameField.placeholder = @"请输入接受者的账户";
        
        UITextField *urlField = [customAlertView textFieldAtIndex:1];
        [urlField setSecureTextEntry:NO];
        urlField.keyboardType=UIKeyboardTypeNumberPad;
        urlField.placeholder = @"请输入转让数量";
        
        [customAlertView show];
        
    }else if(buttonIndex==1)
    {
        NumberListViewController *numlist=[[NumberListViewController alloc] init];
        [self.navigationController pushViewController:numlist animated:YES];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        UITextField *urlField = [alertView textFieldAtIndex:1];
        if (nameField.text.length==0||urlField.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"转让信息不能为空" duration:1.5];
            return;
        }
        [self transferable:nameField.text :urlField.text];
        //TODO
    }
}
-(void)transferable:(NSString *)user  :(NSString *)num
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",user,@"user",num,@"num",nil];
    
    [SVProgressHUD showWithStatus:@"转让中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestZhuanrangjihuoma" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                
            }
        }
        @catch (NSException *exception)
        {
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];
}
-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",1],@"page",[NSString stringWithFormat:@"%d",10],@"num",nil];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestJihuoma" params:dicton success:^(NSDictionary *dict) {
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
    
    return 113;
    
}

//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
    
    UILabel *tempL0=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH*0.5, 20)];
    tempL0.text= [NSString stringWithFormat:@"第%@号",[dictTable objectForKey:@"id"]];
    tempL0.textColor=[UIColor grayColor];
    [tempL0 setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:tempL0];
    
    UILabel *tempL1=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL0.frame), SCREEN_WIDTH*0.5, 20)];
    tempL1.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    tempL1.text= [dictTable objectForKey:@"sqshijian"];
    [tempL1 setFont:[UIFont systemFontOfSize:12]];
    [cell addSubview:tempL1];
    
    
    UILabel *tempL2=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL1.frame)+20, SCREEN_WIDTH*0.1, 20)];
    tempL2.textAlignment = NSTextAlignmentLeft;
    tempL2.text=@"姓名：";
    tempL2.adjustsFontSizeToFitWidth=YES;
    [tempL2 setFont:[UIFont boldSystemFontOfSize:13]];
    [tempL2 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL2];
    
    UILabel *tempL22=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tempL2.frame), CGRectGetMaxY(tempL1.frame)+20, SCREEN_WIDTH*0.22, 20)];
    tempL22.textAlignment = NSTextAlignmentLeft;
    tempL22.text=[dictTable objectForKey:@"user"];
    [tempL22 setFont:[UIFont systemFontOfSize:13]];
    tempL22.adjustsFontSizeToFitWidth=YES;
    [tempL22 setTextColor:[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1]];
    [cell addSubview:tempL22];
    
    //金额
    UILabel *tempL3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.45, 5, SCREEN_WIDTH*0.4, 20)];
    tempL3.textAlignment = NSTextAlignmentLeft;
    tempL3.text=@"激活码编号：";
    [tempL3 setFont:[UIFont systemFontOfSize:12]];
    [tempL3 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL3];
    
    //金额
    UILabel *tempL4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.45, CGRectGetMaxY(tempL3.frame), SCREEN_WIDTH*0.46, 30)];
    tempL4.textAlignment = NSTextAlignmentLeft;
    tempL4.text=[NSString stringWithFormat:@"%@",[dictTable objectForKey:@"id"]];
    [tempL4 setFont:[UIFont systemFontOfSize:14]];
    tempL4.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
    [cell addSubview:tempL4];
    
    //金额
    UILabel *tempL5=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.45, CGRectGetMaxY(tempL4.frame), SCREEN_WIDTH*0.4, 18)];
    tempL5.textAlignment = NSTextAlignmentLeft;
    tempL5.text=@"激活码：";
    [tempL5 setFont:[UIFont systemFontOfSize:12]];
    [tempL5 setTextColor:[UIColor grayColor]];
    [cell addSubview:tempL5];
    
    //金额
    CopyLable *tempL6=[[CopyLable alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.45, CGRectGetMaxY(tempL5.frame), SCREEN_WIDTH*0.45, 30)];
    tempL6.textAlignment = NSTextAlignmentLeft;
    tempL6.text=[dictTable objectForKey:@"pin"];
    [tempL6 setFont:[UIFont boldSystemFontOfSize:12]];
    //tempL6.adjustsFontSizeToFitWidth=YES;
    tempL6.numberOfLines=2;
    tempL6.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
    [cell addSubview:tempL6];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,113-5 , SCREEN_WIDTH, 5)];
    view.backgroundColor=[UIColor whiteColor];
    [cell addSubview:view];
    
    
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 40)];
    imgview.backgroundColor=[UIColor clearColor];
    if ([[dictTable objectForKey:@"station"] integerValue]==1)
    {
        imgview.image=[UIImage imageNamed:@"yijihuo"];
    }else if ([[dictTable objectForKey:@"station"] integerValue]==2)
    {
        imgview.image=[UIImage imageNamed:@"ic_shixiao.png"];
    }
    else
    {
        imgview.image=[UIImage imageNamed:@"weijihuo"];
    
    }
    [cell addSubview:imgview];
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    cell.backgroundColor = [UIColor colorWithRed:222./255. green:222./255. blue:221./255. alpha:1.];
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
        tempPage=[ConvertValue getPageNum:[arrayData count] :10];
        if (tempPage<=0) {
            
            [ToolControl showHudWithResult:NO andTip:@"暂无更多数据！"];
            [workTableView stopLoadWithState:PullUpLoadState];
            return;
        }
        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",tempPage],@"page",[NSString stringWithFormat:@"%d",10],@"num",nil];
        
        [ToolControl showHudWithTip:@"加载更多中..."];
        
        //        NSMutableString *post2 = nil;
        //        post2=[HttpTool getDataString:dicton];
        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestJihuojilu" params:dicton success:^(NSDictionary *dict) {
            @try
            {
                
                [workTableView stopLoadWithState:PullUpLoadState];
                
                if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
                {
                    NSMutableArray *newarray=[NSMutableArray arrayWithArray:arrayData];
                    [newarray addObjectsFromArray:[dict objectForKey:@"result"]];
                    arrayData=newarray;
                    [self initUI];
                    
                }
                [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
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
