//
//  AgreeViewController.m
//  NB2
//
//  Created by zcc on 16/4/27.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "AgreeViewController.h"
#import "ZHPickView.h"
@interface AgreeViewController ()<ZHPickViewDelegate>
{
    TopView *topView;
    UIScrollView *keyview;
    UILabel *daylable;
    NSString *aPath;
    NSData *ImgData;
    UIImageView *imgview;
    UITextView *textfied;
}
@property(nonatomic,strong)ZHPickView *pickview;
@end

@implementation AgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    [self initTopView];
    [self initUI];
    //[self initData];
        
        // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (keyBoardController==nil)
    {
        keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    }
    [keyBoardController addToolbarToKeyboard];

}
-(void)initTopView
{
    topView = [[TopView alloc]init];
    topView.titileTx=@"同意付款";
    topView.imgLeft=@"back_btn_n";
    topView.delegate=self;
    [self.view addSubview:topView];
    [topView setTopView];
}
-(void)initUI
{
    
    //主bodyview
    keyview=[[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(topView.frame) , SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topView.frame))];
    keyview.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    keyview.delegate=self;
    keyview.tag=101;
    
//    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH*0.5,20 )];
//    lable.text=@"请输入转账日期：";
//    lable.font=[UIFont systemFontOfSize:13];
//    lable.textColor=[UIColor grayColor];
//    [keyview addSubview:lable];
//    
//    daylable=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lable.frame)+2, SCREEN_WIDTH*0.6, 25)];
//    daylable.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
//    daylable.font=[UIFont systemFontOfSize:13];
//    daylable.text=@"";
//    daylable.userInteractionEnabled=YES;
//    [keyview addSubview:daylable];
    
//    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
//    but.frame=CGRectMake(SCREEN_WIDTH*0.6-20, 2, 20, 20);
//    [but setBackgroundImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
//    [but addTarget:self action:@selector(clickchooses) forControlEvents:UIControlEventTouchUpInside];
//    [daylable addSubview:but];
    
//    UILabel *daylable1=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(daylable.frame)+10, SCREEN_WIDTH*0.6, 25)];
//    daylable1.backgroundColor=[UIColor clearColor];
//    daylable1.text=@"请选择需要插入的图片：";
//    daylable1.font=[UIFont systemFontOfSize:13];
//    [keyview addSubview:daylable1];
    
//    UIButton *but1=[UIButton buttonWithType:UIButtonTypeCustom];
//    but1.frame=CGRectMake(15, CGRectGetMaxY(daylable1.frame)+2, 70, 20);
//    [but1 setBackgroundColor:[UIColor orangeColor]];
//    but1.titleLabel.font=[UIFont systemFontOfSize:13];
//    but1.layer.masksToBounds=YES;
//    but1.layer.cornerRadius=2;
//    [but1 setTitle:@"选择文件" forState:UIControlStateNormal];
//    [but1 addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    [but1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [keyview addSubview:but1];
//
//    UILabel *daylable2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(but1.frame)+5, CGRectGetMaxY(daylable1.frame)+2, SCREEN_WIDTH*0.35, 25)];
//    daylable2.backgroundColor=[UIColor clearColor];
//    daylable2.text=@"可以接受jpg,png,gie的文件格式，最大文件不能超过2Mb";
//    daylable2.numberOfLines=2;
//    daylable2.textColor=[UIColor redColor];
//    daylable2.font=[UIFont systemFontOfSize:9];
//    [keyview addSubview:daylable2];
//    
//    
//    imgview=[[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(daylable2.frame)+10, 60, 60)];
//    imgview.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
//    [keyview addSubview:imgview];
//    
//    UIButton *but2=[UIButton buttonWithType:UIButtonTypeCustom];
//    but2.frame=CGRectMake(15, CGRectGetMaxY(imgview.frame)+10, 40, 20);
//    [but2 setBackgroundColor:[UIColor greenColor]];
//    [but2 setTitle:@"删除" forState:UIControlStateNormal];
//    but2.titleLabel.font=[UIFont systemFontOfSize:13];
//    but2.layer.masksToBounds=YES;
//    but2.layer.cornerRadius=2;
//    [but2 addTarget:self action:@selector(clickdelde) forControlEvents:UIControlEventTouchUpInside];
//    [but2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [keyview addSubview:but2];
    
    UILabel *lablebei=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH*0.5,20 )];
    lablebei.text=@"请输入备注信息：";
    lablebei.font=[UIFont systemFontOfSize:15];
    lablebei.textColor=[UIColor grayColor];
    [keyview addSubview:lablebei];
    
    textfied=[[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lablebei.frame)+2, SCREEN_WIDTH-30, 60)];
    textfied.layer.borderWidth=1;
    textfied.layer.borderColor=[UIColor grayColor].CGColor;
    textfied.backgroundColor=[UIColor whiteColor];
    [keyview addSubview:textfied];
    
    UIButton *buts=[UIButton buttonWithType:UIButtonTypeCustom];
    buts.backgroundColor=[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
    buts.frame=CGRectMake(15, CGRectGetMaxY(textfied.frame)+10, SCREEN_WIDTH-30, 30);
    [buts setTitle:@"提交保存" forState:UIControlStateNormal];
    [buts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buts addTarget:self action:@selector(clicksubmit) forControlEvents:UIControlEventTouchUpInside];
    [keyview addSubview:buts];
    keyview.contentSize=CGSizeMake(0,CGRectGetMaxY(buts.frame)+5);
    [self.view addSubview:keyview];
    [self.view bringSubviewToFront:topView];

}
-(void)clickdelde
{

    imgview.image=[UIImage imageNamed:@""];
    aPath=@"";
    
}
-(void)clickchooses
{
    [_pickview remove];
    NSDate *date=[NSDate date];
    _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    
    _pickview.delegate=self;
    
    [_pickview show];
    
}
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    NSLog(@"%@",resultString);
    daylable.text=resultString;
   // UITextField *intput15=[keyview viewWithTag:117];
    //intput15.text=[NSString stringWithFormat:@"%@%@",profive,city];
    
}
-(void)click
{
    //[self clickreturn];
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"本地上传" otherButtonTitles:@"拍照上传", nil];
    [action showInView:self.view];
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (buttonIndex==0)
    {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        NSLog(@"本地上传");
    }
    if (buttonIndex==1)
    {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        NSLog(@"拍照上传");
    }
    
}
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    UIImage *theImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(300, 200)];

    if (UIImagePNGRepresentation(image))
    {
        //返回为png图像。
        ImgData = UIImagePNGRepresentation(theImage);
    }else
    {
        //返回为JPEG图像。
        ImgData = UIImageJPEGRepresentation(theImage, 1.0);
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    aPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"shang.png"]];
    imgview.image=theImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
    // Do any additional setup after loading the view.
-(void)actionLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clicksubmit
{
//    if (aPath==nil||[aPath isEqualToString:@""])
//    {
//        [ToolControl showHudWithResult:NO andTip:@"请选择上传的图片"];
//        return;
//    }
    
    
//    if ([daylable.text isEqualToString:@""])
//    {
//        [ToolControl showHudWithResult:NO andTip:@"请选择时间"];
//        return;
//    }
//    if ([textfied.text isEqualToString:@""])
//    {
//        [ToolControl showHudWithResult:NO andTip:@"请输入备注信息"];
//        return;
//    }
    [SVProgressHUD showWithStatus:@"请求中..." maskType:SVProgressHUDMaskTypeBlack];
    NSDate * senddate=[NSDate date];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString * locationString=[dateformatter stringFromDate:senddate];
    
    NSDictionary *diction=@{@"id":UID,@"md5":MD5,@"tid":self.tid,@"beizhu":textfied.text,@"paytime":locationString};
    [HttpTool postWithBaseURL:kBaseURL path:@"/api/requestTongyifukuan" params:diction success:^(NSDictionary *dict) {
        @try
        {
            [SVProgressHUD dismiss];
            [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
            if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
            {
                [self.navigationController popViewControllerAnimated:YES];
                //                      [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
                
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
        [SVProgressHUD showErrorWithStatus:@"网络较差，请稍候重试！" duration:1.5];
    }];
    
//    [HttpTool uploadImage:[NSString stringWithFormat:@"%@%@",kBaseURL,@"/api/requestTongyifukuan"] postParems:[NSString stringWithFormat:@"%@",UID] postParemd:MD5
//              picFileName:aPath index:[NSString stringWithFormat:@"%@",self.tid] beizhu:textfied.text data:NULL success:^(NSDictionary *dict){
//                  [SVProgressHUD dismiss];
//                  [ToolControl showHudWithResult:NO andTip:[dict objectForKey:@"msg"]];
//                  if ([[dict objectForKey:@"station"] isEqualToString:@"success"])
//                  {
//                      
//                      [self.navigationController popViewControllerAnimated:YES];
////                      [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
//                      NSLog(@"%@",self.navigationController.viewControllers);
//
//                  }
//                  
//              } failure:^(NSError *error) {
//                  [SVProgressHUD dismiss];
//                  [SVProgressHUD showErrorWithStatus:@"网络较差，请稍候重试！" duration:1.5];
//              }];
    
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
