//
//  NavViewController.m
//  NB2
//
//  Created by zcc on 16/2/19.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "NavViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "TabViewController.h"
@interface NavViewController ()

@end

@implementation NavViewController

+(NavViewController *) mangerNavController
{
    
    static NavViewController *_sharedInstance=nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance=[[NavViewController alloc] init];
    });
    return _sharedInstance;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* UINavigationControllerDelegate */
    self.delegate = self;
    
    // swipe gesture /
    __weak typeof (self)weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    // Do any additional setup after loading the view.
}
//在滑动过程中你会发现如果在pushViewController的动画过程中激活滑动手势会导致crash, 解决方案
// set gesture no when pushViewController /
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}
//自然, 在当你加载完成下一个viewController之后需要激活滑动手势：
// set gesture yes when showViewController /
//- (void)navigationController:(UINavigationController )navigationController didShowViewController:(UIViewController )viewController animated:(BOOL)animated
//{
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}
//当然, 你还会发现一个问题：在rootController下滑动的时候, 在想push到下一个页面会没有反应, 界面卡死在那了, 所以还需要在上述方法中加入以下代码：

// set gesture yes when showViewController /
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    // if rootViewController, set delegate nil /
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    if (navigationController.viewControllers.count == 2) {
        if ([[navigationController.viewControllers objectAtIndex:1] isKindOfClass:[TabViewController class]])
        {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
            navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
        
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
