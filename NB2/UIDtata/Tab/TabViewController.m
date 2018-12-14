//
//  TabViewController.m
//  NB2
//
//  Created by zcc on 16/2/19.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "TabViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"

#define SELECT_TAB_TAG  238923

@interface TabViewController ()
{
    NSMutableArray *arrimg;
    NSMutableArray *arrtext;
    NSMutableArray *arrselet;
    NSArray *views;
    UIView *tabbarView;
    
}

@property (nonatomic,strong) NSArray *tabTexts;

@end

@implementation TabViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setHidden:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [self _initViewController];
        [self _initTabbarViw];
    }
    return self;
}


- (NSArray *)tabTexts
{
    if (!_tabTexts) {
        _tabTexts = @[@"首页",@"系统公告",@"系统设置",@"会员中心"];
    }
    return _tabTexts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden=YES;
//    arrtext= [NSMutableArray arrayWithObjects:@"timelineIcon.png",@"mentionsIcon.png",@"searchIcon.png",@"searchIconss.png", nil];//item 正常状态下的背景图片
//    arrselet= [NSMutableArray arrayWithObjects:@"timelineIconHighlighted.png",@"mentionsIconHighlighted.png",@"searchIconHighlighted.png",@"searchIconHighlighteds.png",nil];//item被选中时的图片名称
    
    
    arrtext= [NSMutableArray arrayWithObjects:@"home",@"notice",@"set",@"user", nil];//item 正常状态下的背景图片
    arrselet= [NSMutableArray arrayWithObjects:@"home_sel",@"notice_sel",@"set_sel",@"user_sel",nil];//item被选中时的图片名称
    self.delegate=self;
    
    
    
    
}
//初始化子控制器
-(void)_initViewController{
    
    OneViewController *_home = [[OneViewController alloc] init];
    TwoViewController *_service=[[TwoViewController alloc] init];
    FourViewController *_four=[[FourViewController alloc] init];
    FiveViewController *_five=[[FiveViewController alloc] init];
    views = @[_home,_service,_four,_five];
    self.viewControllers = views;
}
//自定义tabbar
//-(void)_initTabbarViw{
//    
//    tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT/13.34, SCREEN_WIDTH, SCREEN_HEIGHT/13.34)];
//    tabbarView.backgroundColor=[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
//    [self.view addSubview:tabbarView];
//    
//    NSInteger count = 0;
//    NSInteger buttonSize = floor(SCREEN_WIDTH / [views count]);
//    for (int i=0;i<views.count; i++) {
//
//        NSInteger buttonX = (count * buttonSize) +count;
//        
//        UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [tabbarView addSubview:tabButton];
//        tabButton.frame  = CGRectMake(buttonX, 0, buttonSize , SCREEN_HEIGHT/14.57);
//        
//        UIImage * normalImage = [UIImage imageNamed:[arrtext objectAtIndex:i]];
//        UIImage * highlightImage = [UIImage imageNamed:[arrselet objectAtIndex:i]];
//        
//        tabButton.tag=i+1;
//        
////        [tabButton setBackgroundImage:normalImage forState:UIControlStateNormal];
////        [tabButton setBackgroundImage:highlightImage forState:UIControlStateSelected];
//        [tabButton setImage:normalImage forState:UIControlStateNormal];
//        [tabButton setImage:highlightImage forState:UIControlStateSelected];
//        
//        [tabButton addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
//        count++;
//        
//    }
//    UIButton *button1=(UIButton *)[tabbarView viewWithTag:1];
//    button1.selected=YES;
//    //shangsend=button1;
//    //
//    //    UILabel *lable1=(UILabel *)[_tabbarView viewWithTag:5];
//    //    lable1.textColor=[UIColor colorWithRed:222 green:255 blue:0 alpha:1];
//    //    labletext=lable1;
//    
//    
//    
//    
//    
//    
//    
//    
//}

-(void)_initTabbarViw{
    tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - TAB_BAR_HEIGHT - JF_BOTTOM_SPACE, SCREEN_WIDTH, TAB_BAR_HEIGHT)];
    tabbarView.backgroundColor=[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
    [self.view addSubview:tabbarView];
    
    NSInteger count = 0;
    NSInteger buttonSize = floor(SCREEN_WIDTH / [self.tabTexts count]);
    for (int i=0;i< self.tabTexts.count; i++) {
        
        NSInteger buttonX = (count * buttonSize) +count;
        UIButton *tabButton = [UIButton buttonWithImageFrame:CGRectMake(buttonX, KKFitScreen(4), buttonSize , TAB_BAR_HEIGHT - KKFitScreen(10)) headImg:[arrtext objectAtIndex:i] fontSize:KKFitScreen(26) clickAction:@selector(selectedTab:) clickTarget:self addToView:tabbarView buttonText:self.tabTexts[i]];
        UIImage * normalImage = [UIImage imageNamed:[arrtext objectAtIndex:i]];
        UIImage * highlightImage = [UIImage imageNamed:[arrselet objectAtIndex:i]];
        tabButton.tag= i + SELECT_TAB_TAG ;
        [tabButton setImage:normalImage forState:UIControlStateNormal];
        [tabButton setImage:highlightImage forState:UIControlStateSelected];
        [tabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tabButton setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [tabButton addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        count++;
        
    }
    UIButton *button1=(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG];
    button1.selected=YES;
}


- (void)selectedTab:(UIButton *)sender{

    self.selectedIndex=sender.tag - SELECT_TAB_TAG;
    sender.selected=YES;
    if (sender.tag==SELECT_TAB_TAG)
    {
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG + 1] setSelected:NO];
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG + 2] setSelected:NO];
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG + 3] setSelected:NO];
        
    }else if (sender.tag==SELECT_TAB_TAG + 1)
    {
        //[self.view.window showHUDWithText:@"加载中..." Type:ShowLoading Enabled:YES];
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG] setSelected:NO];
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG+2] setSelected:NO];
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG+3] setSelected:NO];
    }
    else if (sender.tag==SELECT_TAB_TAG + 2)
    {
        //[self.view.window showHUDWithText:@"加载中..." Type:ShowLoading Enabled:YES];
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG] setSelected:NO];
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG+1] setSelected:NO];
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG+3] setSelected:NO];
    }else
    {
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG] setSelected:NO];
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG+1] setSelected:NO];
        [(UIButton *)[tabbarView viewWithTag:SELECT_TAB_TAG+2] setSelected:NO];
//        [(UIButton *)[tabbarView viewWithTag:4] setSelected:NO];
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
