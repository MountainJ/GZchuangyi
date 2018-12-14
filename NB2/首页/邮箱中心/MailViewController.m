//
//  MailViewController.m
//  NB2
//
//  Created by zcc on 16/2/20.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "MailViewController.h"
#import "MeilDetailsViewController.h"

@interface MailViewController ()
{
    TopView *topView;
    UITableView *workTableView;
    NSMutableArray *arrayData;
    int sign;
    int tempPage;
    //写邮件
    UITextView *textview;
    UIView *top;
    UILabel *lab;
    UITextField *keywordNoTF;
    UIView *thread;
    UILabel *lab1;
    UITextField *sendmeil;
    UIView *thread1;
    UILabel *lab2;
    UITextField *subject;
    UIView *thread2;
}
@end

@implementation MailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    sign=2;
    tempPage=1;
    arrayData =[[NSMutableArray alloc] init];
    [self initTopView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (sign==1||sign==2)
    {
        [self initData];
    }
    
}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"邮件中心";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    //topView.buttonRB=@"奖金详情";
    [self.view addSubview:topView];
    [topView setTopView];
    
    NSArray *arraycolcor=[[NSArray alloc] initWithObjects:@"收件箱",@"发件箱",@"写邮件", nil];
    for (int i=0; i<arraycolcor.count; i++)
    {
        UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
        but.frame=CGRectMake(SCREEN_WIDTH/3.0*i, CGRectGetMaxY(topView.frame), SCREEN_WIDTH/3.0, 40);
        but.tag=100+i;
        [but addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
        but.titleLabel.font=[UIFont systemFontOfSize:14];
        if (i==0)
        {
            but.selected=YES;
            [but setBackgroundImage:[UIImage imageNamed:@"frist"] forState:UIControlStateSelected];
            [but setBackgroundImage:[UIImage imageNamed:@"butnooselectgreen"] forState:UIControlStateNormal];
            
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
    
}
//-(void)clickTag:(UIButton*)sender
//{
//    
//}
-(void)GetupKey
{
    [self.view endEditing:NO];
}
-(void)removeView
{
    [top removeFromSuperview];
    top=nil;
    [lab removeFromSuperview];
    lab=nil;
    [keywordNoTF removeFromSuperview];
    keywordNoTF=nil;
    [thread removeFromSuperview];
    thread=nil;
    [lab1 removeFromSuperview];
    lab1=nil;
    [sendmeil removeFromSuperview];
    sendmeil=nil;
    [thread1 removeFromSuperview];
    thread1=nil;
    [subject removeFromSuperview];
    subject=nil;
    [lab2 removeFromSuperview];
    lab2=nil;
    [thread2 removeFromSuperview];
    thread2=nil;
    [textview removeFromSuperview];
    textview=nil;
}
-(void)clickTag:(UIButton *)sender
{
    if (sender.tag==100)
    {
        sender.selected=YES;
        UIButton *but1=[self.view viewWithTag:101];
        UIButton *but2=[self.view viewWithTag:102];
        but1.selected=NO;
        but2.selected=NO;
        [self GetupKey];
        [self removeView];
        sign=2;
        [self initData];
    }
    else if (sender.tag==101)
    {
        sender.selected=YES;
        UIButton *but1=[self.view viewWithTag:100];
        UIButton *but2=[self.view viewWithTag:102];
        but1.selected=NO;
        but2.selected=NO;
        [self GetupKey];
        [self removeView];
        sign=1;
        [self initData];
    }else
    {
        sender.selected=YES;
        UIButton *but1=[self.view viewWithTag:100];
        UIButton *but2=[self.view viewWithTag:101];
        but1.selected=NO;
        but2.selected=NO;
        if (top==nil) {
            //画新的ui
            [workTableView removeFromSuperview];
            [self writeView];
        }
        

    }
}
-(void)writeView
{
    [top removeFromSuperview];
    top=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)+45, SCREEN_WIDTH, 40)];
    top.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:top];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(SCREEN_WIDTH*0.1, 0, 40, 40);
    button.backgroundColor=[UIColor clearColor];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    button.tag=200;
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickbut:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [top addSubview:button];
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH*0.1-40, 0, 40, 40);
    button1.backgroundColor=[UIColor clearColor];
    button1.titleLabel.font=[UIFont systemFontOfSize:15];
    [button1 setTitle:@"发送" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickbut:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag=201;
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [top addSubview:button1];
    
    [lab removeFromSuperview];
    lab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.05, CGRectGetMaxY(top.frame), SCREEN_WIDTH*0.2, 40)];
    lab.textAlignment=NSTextAlignmentRight;
    lab.font=[UIFont systemFontOfSize:13];
    lab.text=@"收件人：";
    [self.view addSubview:lab];
    
    [keywordNoTF removeFromSuperview];
    // 密码输入
    keywordNoTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.25, CGRectGetMaxY(top.frame), SCREEN_WIDTH*0.65, 40)];
    //keywordNoTF.secureTextEntry = YES;
    keywordNoTF.placeholder=@"收件人帐号或手机号";
    keywordNoTF.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
    [keywordNoTF setValue:[UIColor colorWithWhite:0.9 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    keywordNoTF.layer.masksToBounds=YES;
    keywordNoTF.returnKeyType =UIReturnKeyDone;
    keywordNoTF.layer.cornerRadius=3;
    keywordNoTF.textColor=[UIColor grayColor];
    keywordNoTF.backgroundColor=[UIColor clearColor];
    keywordNoTF.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
    keywordNoTF.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    keywordNoTF.delegate = self;
    [keywordNoTF setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:keywordNoTF];
    
    [thread removeFromSuperview];
    thread=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame)+1, SCREEN_WIDTH, 1)];
    thread.backgroundColor=[UIColor grayColor];
    [self.view addSubview:thread];

    [lab1 removeFromSuperview];
    lab1=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.05, CGRectGetMaxY(thread.frame), SCREEN_WIDTH*0.2, 40)];
    lab1.font=[UIFont systemFontOfSize:13];
    lab1.textAlignment=NSTextAlignmentRight;
    lab1.text=@"发件人：";
    [self.view addSubview:lab1];
    
    [sendmeil removeFromSuperview];
    // 密码输入
    sendmeil = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.25, CGRectGetMaxY(thread.frame), SCREEN_WIDTH*0.65, 40)];
    //sendmeil.secureTextEntry = YES;
    sendmeil.returnKeyType =UIReturnKeyDone;
    sendmeil.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
    //    [keywordNoTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    sendmeil.layer.masksToBounds=YES;
    sendmeil.layer.cornerRadius=3;
    sendmeil.textColor=[UIColor grayColor];
    sendmeil.backgroundColor=[UIColor clearColor];
    sendmeil.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
    sendmeil.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    sendmeil.delegate = self;
    [sendmeil setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:sendmeil];
    
    [thread1 removeFromSuperview];
    thread1=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame)+1, SCREEN_WIDTH, 1)];
    thread1.backgroundColor=[UIColor grayColor];
    [self.view addSubview:thread1];
    
    [lab2 removeFromSuperview];
    lab2=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.05, CGRectGetMaxY(thread1.frame), SCREEN_WIDTH*0.2, 40)];
    lab2.textAlignment=NSTextAlignmentRight;
    lab2.font=[UIFont systemFontOfSize:13];
    lab2.text=@"主题：";
    [self.view addSubview:lab2];
    
    [subject removeFromSuperview];
    // 密码输入
    subject = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.25, CGRectGetMaxY(thread1.frame), SCREEN_WIDTH*0.7, 40)];
    subject.returnKeyType =UIReturnKeyDone;
    subject.clearButtonMode = UITextFieldViewModeWhileEditing;//清除button
    //    [keywordNoTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    subject.layer.masksToBounds=YES;
    subject.layer.cornerRadius=3;
    subject.textColor=[UIColor grayColor];
    subject.backgroundColor=[UIColor clearColor];
    subject.autocapitalizationType = UITextAutocapitalizationTypeNone;//取消自动大小写
    subject.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    subject.delegate = self;
    [subject setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:subject];
    
    [thread2 removeFromSuperview];
    thread2=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab2.frame)+1, SCREEN_WIDTH, 1)];
    thread2.backgroundColor=[UIColor grayColor];
    [self.view addSubview:thread2];
    
    [textview removeFromSuperview];
    
    textview=[[UITextView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, CGRectGetMaxY(thread2.frame)+20, SCREEN_WIDTH*0.7, SCREEN_HEIGHT*0.5)];
    textview.returnKeyType =UIReturnKeyDone;
    textview.scrollEnabled=NO;
    textview.delegate=self;
    [self.view addSubview:textview];
    

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
//这个函数的最后一个参数text代表你每次输入的的那个字，所以：
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    { //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
-(void)clickbut:(UIButton *)sender
{
    if (sender.tag==200)
    {
        keywordNoTF.text=@"";
        sendmeil.text=@"";
        subject.text=@"";
        textview.text=@"";
        
    }else
    {
        if ([keywordNoTF.text isEqualToString:@""])
        {
            [ToolControl showHudWithResult:NO andTip:@"请填写收件人"];
            [keywordNoTF becomeFirstResponder];
            return;
        }
        if ([sendmeil.text isEqualToString:@""])
        {
            [ToolControl showHudWithResult:NO andTip:@"请填写发件人"];
            [sendmeil becomeFirstResponder];
            return;
        }
        if ([subject.text isEqualToString:@""])
        {
            [ToolControl showHudWithResult:NO andTip:@"请填写主题"];
            [subject becomeFirstResponder];
            return;
        }
        if ([textview.text isEqualToString:@""])
        {
            [ToolControl showHudWithResult:NO andTip:@"请填写邮件内容"];
            [textview becomeFirstResponder];
            return;
        }
        //发送邮件
        [self sendMeil];
        
    }
    

}
-(void)sendMeil
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%@",keywordNoTF.text],@"user",[NSString stringWithFormat:@"%@",subject.text],@"title",textview.text,@"content",nil];
    [SVProgressHUD showWithStatus:@"发送中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestWriteemail" params:dicton success:^(NSDictionary *dict){
        
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                keywordNoTF.text=@"";
                sendmeil.text=@"";
                subject.text=@"";
                textview.text=@"";
            }
        }
        @catch (NSException *exception) {
            [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
        }
        @finally {
            
        }
        // [ToolControl hideHud];
        
    } failure:^(NSError *error) {
        [ToolControl hideHud];
        [SVProgressHUD dismiss];
        [ToolControl showHudWithResult:NO andTip:ERRORTITLE];
    }];


}
-(void)initData
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",1],@"page",[NSString stringWithFormat:@"%d",sign],@"type",[NSString stringWithFormat:@"%d",10],@"num",nil];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestEmail" params:dicton success:^(NSDictionary *dict) {
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
    workTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,topView.frame.origin.y+topView.frame.size.height+45 ,SCREEN_WIDTH ,SCREEN_HEIGHT-CGRectGetMaxY(topView.frame)-40)];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dictTable=[arrayData objectAtIndex:indexPath.row];
    UIImageView *ivTemp= [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH*0.2-20, SCREEN_WIDTH*0.2-20)];
    ivTemp.clipsToBounds=YES;
    [ivTemp setContentMode:UIViewContentModeScaleAspectFill];
    ivTemp.layer.masksToBounds=YES;
    ivTemp.layer.cornerRadius=5;
    
    //使用异步方式加载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        UIImage *img=[HttpTool getUrlDataForm:[dictTable objectForKey:@"shijian"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ivTemp.image=img;
            if (img==nil) {
                [ivTemp setImage:[UIImage imageNamed:@"lognmo"]];
            }
        });
        
    });
    [cell addSubview:ivTemp];
    
    UILabel *tempL0=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.2, 5, SCREEN_WIDTH*0.5, 20)];
    tempL0.text= [dictTable objectForKey:@"shou"];
    [tempL0 setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:tempL0];
    
    UILabel *tempL1=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.2, CGRectGetMaxY(tempL0.frame), SCREEN_WIDTH*0.5, 20)];
    tempL1.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    tempL1.text= [dictTable objectForKey:@"shijian"];
    [tempL1 setFont:[UIFont systemFontOfSize:12]];
    [cell addSubview:tempL1];
    
    
    UILabel *tempL2=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.2, CGRectGetMaxY(tempL1.frame), SCREEN_WIDTH*0.5, 20)];
    tempL2.textAlignment = NSTextAlignmentLeft;
    tempL2.text=[dictTable objectForKey:@"fa"];
    [tempL2 setFont:[UIFont systemFontOfSize:12]];
    [tempL2 setTextColor:[UIColor blackColor]];
    [cell addSubview:tempL2];
    
    UILabel *tempL3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.2, CGRectGetMaxY(tempL2.frame), SCREEN_WIDTH*0.5, 40)];
    tempL3.textAlignment = NSTextAlignmentLeft;
    tempL3.text=[dictTable objectForKey:@"content"];
    [tempL3 setFont:[UIFont systemFontOfSize:12]];
    tempL3.numberOfLines=2;
    [tempL3 setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [cell addSubview:tempL3];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,103-5 , SCREEN_WIDTH, 5)];
    view.backgroundColor=[UIColor whiteColor];
    [cell addSubview:view];
    
    if (sign==2)
    {
        UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 40)];
        if ([[dictTable objectForKey:@"station"] integerValue]==1)
        {
            imgview.image=[UIImage imageNamed:@"yidu"];
            
        }else
        {
            imgview.image=[UIImage imageNamed:@"weidu"];
        }
        [cell addSubview:imgview];
        
    }
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    cell.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MeilDetailsViewController *meil=[[MeilDetailsViewController alloc] init];
    meil.meilid=[NSString stringWithFormat:@"%@",[[arrayData objectAtIndex:indexPath.row] objectForKey:@"tid"]];
    [self.navigationController pushViewController:meil animated:YES];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)deleteData:(NSString *)tid
{
    NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%@",tid],@"tid",nil];
    
    [SVProgressHUD showWithStatus:@"删除中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestEmaildel" params:dicton success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
//                //[arrayData removeAllObjects];
//                arrayData=[dict objectForKey:@"result"];
//                [self initUI];
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了删除");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteData:[[arrayData objectAtIndex:indexPath.row] objectForKey:@"tid"]];
        [arrayData removeObjectAtIndex:indexPath.row];
//        [self.infoItems removeObjectAtIndex:(indexPath.row*2)];
//        [self.infoItems removeObjectAtIndex:(indexPath.row*2)];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[self deleteData:[[arrayData objectAtIndex:indexPath.row] objectForKey:@"tid"]];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"手指撮动了");
    return UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
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
        NSMutableDictionary *dicton=[NSMutableDictionary dictionaryWithObjectsAndKeys:UID,@"id",MD5,@"md5",[NSString stringWithFormat:@"%d",tempPage],@"page",[NSString stringWithFormat:@"%d",sign],@"type",[NSString stringWithFormat:@"%d",10],@"num",nil];
        
        [ToolControl showHudWithTip:@"加载更多中..."];
        
//        NSMutableString *post2 = nil;
//        post2=[HttpTool getDataString:dicton];
        [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestEmail" params:dicton success:^(NSDictionary *dict) {
            @try
            {
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
