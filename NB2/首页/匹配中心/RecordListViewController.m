//
//  RecordListViewController.m
//  NB2
//
//  Created by zcc on 16/2/23.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "RecordListViewController.h"
#import "EnquiriesViewController.h"
#import "AgreeViewController.h"
#import "NoAgreeViewController.h"
@interface RecordListViewController ()
{
    NSMutableArray *arrayData;
    UITableView *workTableView;
    TopView *topView;
    NSMutableArray *array;
    NSMutableArray *idArrayData;
}

#define ZHUANGU_TAG  13451
#define ZHUANLICAI_TAG 923993

@property (nonatomic,assign) BOOL  didChangeState;


@end

@implementation RecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.sign==100)
    {
        array=[[NSMutableArray alloc] initWithObjects:@"帮助金额：",@"剩余金额：",@"下单时间：",@"冻结时间：",@"完成状态：", nil];
        arrayData=[[NSMutableArray alloc] initWithObjects:[self.diction objectForKey:@"jine"],[self.diction objectForKey:@"shengyu"],[self.diction objectForKey:@"shijian"],[self.diction objectForKey:@"djshijian"],[self.diction objectForKey:@"station"], nil];
        
    }else
    {
        array=[[NSMutableArray alloc] initWithObjects:@"求助金额：",@"剩余金额：",@"下单时间：",@"完成状态：", nil];
        arrayData=[[NSMutableArray alloc] initWithObjects:[self.diction objectForKey:@"jine"],[self.diction objectForKey:@"shengyu"],[self.diction objectForKey:@"shijian"],[self.diction objectForKey:@"station"], nil];
    }
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTopView];
    idArrayData=[[NSMutableArray alloc] init];
    [self initUI];
    
    
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
    topView.titileTx=self.strtitle;
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    //topView.buttonRB=@"查询";
    [self.view addSubview:topView];
    [topView setTopView];
}
-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",1],@"page",[self.diction objectForKey:@"orderid"],@"orderid",[NSString stringWithFormat:@"%d",100],@"num",nil];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestOrderlist" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            [workTableView stopLoadWithState:PullDownLoadState];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                //[arrayData removeAllObjects];
                idArrayData=[[dict objectForKey:@"result"] mutableCopy];
                [workTableView reloadData];
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
    workTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,topView.frame.origin.y+topView.frame.size.height ,SCREEN_WIDTH ,SCREEN_HEIGHT-CGRectGetMaxY(topView.frame))];
    workTableView.backgroundColor = [UIColor clearColor];
    workTableView.delegate = self;
    workTableView.dataSource = self;
    workTableView.tableFooterView=[[UIView alloc] init];
    workTableView.scrollEnabled=YES;
    //设置分割线起始位置
    workTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:workTableView];
    
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
    
    return arrayData.count+1+idArrayData.count;
}
//tab每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return 94;
    }if (indexPath.row<=arrayData.count) {
        return 47;
    }
    return 94;
    
}


//tab每行的赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==0)
        {
            UILabel *tempL0=[[UILabel alloc]init];
            tempL0.font = [UIFont systemFontOfSize:15];
            tempL0.numberOfLines=2;
            tempL0.textColor=[UIColor grayColor];
            tempL0.textAlignment=NSTextAlignmentCenter;
            tempL0.text=[NSString stringWithFormat:@"订单号：%@",[self.diction objectForKey:@"orderid"]];
            tempL0.backgroundColor=[UIColor clearColor];
            tempL0.frame=CGRectMake(0, 20,SCREEN_WIDTH, 40);
            [cell addSubview:tempL0];
            
            UILabel *tempL2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tempL0.frame), SCREEN_WIDTH*0.52, 20)];
            tempL2.textAlignment = NSTextAlignmentRight;
            tempL2.text=@"匹配人数 ";
            tempL2.adjustsFontSizeToFitWidth=YES;
            [tempL2 setFont:[UIFont boldSystemFontOfSize:12]];
            [tempL2 setTextColor:[UIColor grayColor]];
            [cell addSubview:tempL2];
            
            UILabel *tempL22=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tempL2.frame)+5, CGRectGetMaxY(tempL0.frame), SCREEN_WIDTH*0.5, 20)];
            tempL22.textAlignment = NSTextAlignmentLeft;
            tempL22.text=[NSString stringWithFormat:@"%@人",[self.diction objectForKey:@"renshu"]];
            [tempL22 setFont:[UIFont systemFontOfSize:12]];
            tempL22.adjustsFontSizeToFitWidth=YES;
            tempL22.textColor=[UIColor orangeColor];
            [cell addSubview:tempL22];
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            //2018.10.20 jay 根据station判断是添加一个转股按钮，还是添加一个转股+转理财按钮，还是啥都不添加
//            if ([self.diction[@"station"] integerValue] == 4 && !self.didChangeState) {//冻结期,添加一个转股按钮
//                UIButton *zhuanguBtn = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(tempL2.frame)+35, CGRectGetMaxY(tempL0.frame), 50.f, CGRectGetHeight(tempL2.frame)) backGroundColor:COLOR_STATUS_NAV_BAR_BACK textColor:[UIColor whiteColor] clickAction:@selector(startZhuanguAction) clickTarget:self addToView:cell buttonText:@"转股"];
//                zhuanguBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
//                zhuanguBtn.layer.cornerRadius = 10.f;
//                zhuanguBtn.layer.masksToBounds = YES;
//                zhuanguBtn.tag = ZHUANGU_TAG;
//
//            }else if ([self.diction[@"station"] integerValue] == 10 && !self.didChangeState )//冻结中，转股+转理财两个按钮
//            {
//                UIButton *zhuanguBtn = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(tempL2.frame)+35, CGRectGetMaxY(tempL0.frame), 50.f, CGRectGetHeight(tempL2.frame)) backGroundColor:COLOR_STATUS_NAV_BAR_BACK textColor:[UIColor whiteColor] clickAction:@selector(startZhuanguAction) clickTarget:self addToView:cell buttonText:@"转股"];
//                zhuanguBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
//                zhuanguBtn.layer.cornerRadius = 10.f;
//                zhuanguBtn.layer.masksToBounds = YES;
//                zhuanguBtn.tag = ZHUANGU_TAG;
//
//                UIButton *zhuanlicaiBtn = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(zhuanguBtn.frame)+10, CGRectGetMinY(zhuanguBtn.frame), CGRectGetWidth(zhuanguBtn.frame)+10., CGRectGetHeight(zhuanguBtn.frame)) backGroundColor:COLOR_STATUS_NAV_BAR_BACK textColor:[UIColor whiteColor] clickAction:@selector(startZhuanlicaiAction) clickTarget:self addToView:cell buttonText:@"转理财"];
//                zhuanlicaiBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
//                zhuanlicaiBtn.layer.cornerRadius = 10.f;
//                zhuanlicaiBtn.layer.masksToBounds = YES;
//                zhuanlicaiBtn.tag = ZHUANLICAI_TAG;
//
//
//            }
        }else if(indexPath.row<=arrayData.count&&indexPath.row>0){
            UILabel *tempL0=[[UILabel alloc]init];
            tempL0.text=[array objectAtIndex:indexPath.row-1];
            tempL0.font = [UIFont systemFontOfSize:14];
            tempL0.textColor=[UIColor grayColor];
            tempL0.adjustsFontSizeToFitWidth=YES;
            tempL0.backgroundColor=[UIColor clearColor];
            tempL0.frame=CGRectMake(20, 10,(SCREEN_WIDTH/2), 20);
            [cell addSubview:tempL0];
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            
            
            UILabel *tempL1=[[UILabel alloc]init];
            tempL1.adjustsFontSizeToFitWidth=YES;
            if(indexPath.row==1)
            {
                tempL1.textColor=[UIColor orangeColor];
                tempL1.text=[NSString stringWithFormat:@"%@元",[arrayData objectAtIndex:indexPath.row-1]];
            
            }else if(indexPath.row==2)
            {
                tempL1.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
                tempL1.text=[NSString stringWithFormat:@"%@元",[arrayData objectAtIndex:indexPath.row-1]];
            }else if(indexPath.row==arrayData.count)
            {
                NSLog(@"%ld",(long)[[arrayData objectAtIndex:indexPath.row-1] integerValue]);
                if ([[arrayData objectAtIndex:indexPath.row-1] integerValue]==2)
                {
                   tempL1.text=@"付款中";
                }
                else if ([[arrayData objectAtIndex:indexPath.row-1] integerValue]==3)
                {
                    tempL1.text=@"未付款";
                }
                else if ([[arrayData objectAtIndex:indexPath.row-1] integerValue]==4)
                {
                    tempL1.text=@"冻结期";
                }
                else if ([[arrayData objectAtIndex:indexPath.row-1] integerValue]==5)
                {
                    tempL1.text=@"完成";
                }else if ([[arrayData objectAtIndex:indexPath.row-1] integerValue]==9)
                {
                    tempL1.text=@"已转股";
                }else if ([[arrayData objectAtIndex:indexPath.row-1] integerValue]==10)
                {
                    tempL1.text=@"冻结中";
                }else if ([[arrayData objectAtIndex:indexPath.row-1] integerValue]==11)
                {
                    tempL1.text=@"转理财";
                }
                
            }else
            {
                tempL1.text=[NSString stringWithFormat:@"%@",[arrayData objectAtIndex:indexPath.row-1]];
            
            }
            tempL1.font = [UIFont systemFontOfSize:14];
            tempL1.backgroundColor=[UIColor clearColor];
            tempL1.textAlignment=NSTextAlignmentRight;
            tempL1.frame=CGRectMake(CGRectGetMaxX(tempL0.frame), 10,(SCREEN_WIDTH/2)-30, 20);
            [cell addSubview:tempL1];
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            
        }else if(indexPath.row>arrayData.count)
        {
            
            NSDictionary *dictTable=[idArrayData objectAtIndex:indexPath.row-arrayData.count-1];
            
            UILabel *tempL0=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH*0.5, 20)];
            tempL0.text= @"订单号：";
            tempL0.textColor=[UIColor grayColor];
            [tempL0 setFont:[UIFont systemFontOfSize:14]];
            [cell addSubview:tempL0];
            
            UILabel *tempL1=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL0.frame), SCREEN_WIDTH*0.5,30)];
            tempL1.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];
            tempL1.text= [dictTable objectForKey:@"orderid"];
            tempL1.numberOfLines=2;
            [tempL1 setFont:[UIFont systemFontOfSize:12]];
            [cell addSubview:tempL1];
            
            
            UILabel *tempL2=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tempL1.frame)+10, SCREEN_WIDTH*0.4, 20)];
            tempL2.textAlignment = NSTextAlignmentLeft;
            tempL2.text=[dictTable objectForKey:@"shijian"];
            tempL2.adjustsFontSizeToFitWidth=YES;
            [tempL2 setFont:[UIFont boldSystemFontOfSize:13]];
            [tempL2 setTextColor:[UIColor grayColor]];
            [cell addSubview:tempL2];
            
            
            //金额
            UILabel *tempL3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+5,10, SCREEN_WIDTH*0.4, 18)];
            tempL3.textAlignment = NSTextAlignmentLeft;
            if(self.sign!=100)
            {
                tempL3.text=@"求助金额：";
            }else
            {
                tempL3.text=@"帮助金额：";
            }
            [tempL3 setFont:[UIFont systemFontOfSize:12]];
            [tempL3 setTextColor:[UIColor grayColor]];
            [cell addSubview:tempL3];
            
            //金额
            UILabel *tempL4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+5, CGRectGetMaxY(tempL3.frame), SCREEN_WIDTH*0.45, 18)];
            tempL4.textAlignment = NSTextAlignmentLeft;
            tempL4.textColor=[UIColor orangeColor];
            tempL4.text=[NSString stringWithFormat:@"%@元",[dictTable objectForKey:@"jine"]];
            [tempL4 setFont:[UIFont systemFontOfSize:12]];
            [cell addSubview:tempL4];
            
            //金额
            UILabel *tempL5=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+5, CGRectGetMaxY(tempL4.frame)+8, SCREEN_WIDTH*0.45, 16)];
            tempL5.textAlignment = NSTextAlignmentLeft;
            tempL5.textColor=[UIColor orangeColor];
            tempL5.text=@"备注：";
            [tempL5 setFont:[UIFont systemFontOfSize:12]];
            [cell addSubview:tempL5];
            //金额
            UILabel *tempL6=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+5, CGRectGetMaxY(tempL5.frame), SCREEN_WIDTH*0.45, 16)];
            tempL6.textAlignment = NSTextAlignmentLeft;
            tempL6.textColor=[UIColor colorWithRed:57/255.0 green:155/255.0 blue:208/255.0 alpha:1];;
            tempL6.text=[NSString stringWithFormat:@"%@",[dictTable objectForKey:@"beizhu"]];
            tempL6.adjustsFontSizeToFitWidth=YES;
            [tempL6 setFont:[UIFont systemFontOfSize:12]];
            [cell addSubview:tempL6];
            
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,94-5 , SCREEN_WIDTH, 5)];
            view.backgroundColor=[UIColor whiteColor];
            [cell addSubview:view];
            
            
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 0, 50, 50)];
            imgview.backgroundColor=[UIColor clearColor];
            //station
            //0排队中
            //1匹配中
            //2付款中
            
            if ([[dictTable objectForKey:@"paystation"] integerValue]==0)
            {
                imgview.image=[UIImage imageNamed:@"weipay"];
                
            }else if ([[dictTable objectForKey:@"paystation"] integerValue]==1)
            {
                imgview.image=[UIImage imageNamed:@"payed"];
                
            }
            else if ([[dictTable objectForKey:@"paystation"] integerValue]==2)
            {
                imgview.image=[UIImage imageNamed:@"shoukaun"];
                
            }

            [cell addSubview:imgview];
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
            cell.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1];
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        }
    
    //cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 50)];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row>arrayData.count)
    {
        NSDictionary *dictTable=[idArrayData objectAtIndex:indexPath.row-arrayData.count-1];
        EnquiriesViewController *enque=[[EnquiriesViewController alloc] init];
        enque.sign=self.sign;
        enque.diction=dictTable;
        [self.navigationController pushViewController:enque animated:YES];
        
    }
}


//转股操作
- (void)startZhuanguAction
{
//    //提示语句更改
//    NSString *message = nil;
//    if ([self.diction[@"station"] integerValue] == 10)//冻结中，转股+转理财两个按钮
//    {
//        message = @"" ;
//    }else if ([self.diction[@"station"] integerValue] == 4){ //冻结期
//        message = @"转股后,该订单将无法分红和解冻,无法还原,请谨慎操作!" ;
//    }
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定对该订单转股吗?" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    [alert addAction:cancel];
//    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self requestNetWorkDataWiNetHostType:@"requestZhuangu"];
//    }];
//    [alert addAction:sure];
//    
//    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
//    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, message.length)];
//    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.] range:NSMakeRange(0, message.length)];
//    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
//
//    [self presentViewController:alert animated:YES completion:nil];
    
}
//转理财操作
- (void)startZhuanlicaiAction
{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定对该订单转理财吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    [alert addAction:cancel];
//    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self requestNetWorkDataWiNetHostType:@"requestZhuanlicai"];
//    }];
//    [alert addAction:sure];
//
//    [self presentViewController:alert animated:YES completion:nil];
}

- (void)requestNetWorkDataWiNetHostType:(NSString *)hostType
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[self.diction objectForKey:@"orderid"],@"orderid",nil];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpTool postWithBaseURL:kBaseURL path:[NSString stringWithFormat:@"/api/%@",hostType] params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                [ToolControl showHudWithResult:YES andTip:[dict objectForKey:@"msg"]];
                if (self.changeBlock) {
                    self.changeBlock();
                }
                //
                self.didChangeState = YES;
                //删除掉界面的转股转理财按钮
                UIButton *zhuanguBtn  = [workTableView viewWithTag:ZHUANGU_TAG];
                UIButton *zhuanLicaiBtn  = [workTableView viewWithTag:ZHUANLICAI_TAG];
                if (zhuanguBtn) {
                    [zhuanguBtn removeFromSuperview];
                }
                if (zhuanLicaiBtn) {
                    [zhuanLicaiBtn removeFromSuperview];
                }
                
            }
            
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
-(void)actionRight
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
