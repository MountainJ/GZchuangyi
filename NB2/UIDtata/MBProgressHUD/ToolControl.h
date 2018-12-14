//
//  ToolControl.h
//  GlobalPay
//
//  Created by star on 13-3-27.
//  Copyright (c) 2013年 LINDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ToolControl : NSObject<MBProgressHUDDelegate>
//获取当前ViewController
+ (UIViewController *)currentViewController;

+ (MBProgressHUD *)sharedHud;
//默认动画形式，菊花
+ (void)showHudWithTip:(NSString *)tip;
//关闭HUD
+ (void)hideHud;
//设置HUD的打开或关闭
+ (void)setHudShowing:(BOOL)willShow withTip:(NSString *)tip;
//显示用来表达结果的HUD,有两种形式，分别是√YES，和×NO，注意这个函数已被加上阻塞，阻塞时间在1.0s+0.3s左右。
//当你希望在HUD消失后才执行某些操作（比如登录成功弹出提示后才销毁窗口)，可以用这个，不需要用delegate。
//这个HUD会自动消失，不需要自己控制
+ (void)showBlockHudWithResult:(BOOL)isSuccess andTip:(NSString *)tip;
//和上面那个几乎一样，只是这个不会阻塞。
+ (void)showHudWithResult:(BOOL)isSuccess andTip:(NSString *)tip;

+ (void)showHudWithCustomView:(UIView *)view;
//设置上面那种HUD的显示时间（默认1s，另外0.3s是HUD消失动画的时间).
+ (void)setHudDelayTime:(CGFloat)time;
//隐藏HUD
+ (void)hideHudAfterDelay:(CGFloat)delay;

+ (void)setSeparatorWithTableView:(UITableView *)tableView;


@end

//--------------------
//1.生成此类的目的是为了更简单的使用HUD。
//2.不需要指定view，大多数情况下，也不需要自己隐藏HUD。
//3.按照设计，其实最常使用的是showHudWithTip 和 showHudWithResult,流程就是先显示正在加载，然后显示结果，显示结果后，HUD会自动消失
//4.每次HUD消失，都会重置DelayTime
//--------------------
