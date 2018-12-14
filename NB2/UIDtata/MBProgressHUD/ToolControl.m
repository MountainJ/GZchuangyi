//
//  ToolControl.m
//  GlobalPay
//
//  Created by Star on 13-3-27.
//  Copyright (c) 2013年 Linda. All rights reserved.
//

#import "ToolControl.h"
#import "AppDelegate.h"

static MBProgressHUD *_hud=nil;
static float _delayTime=2.0f;
static ToolControl *_sharedToolControl=nil;

@interface ToolControl ()

@property (nonatomic,assign) BOOL end;

@end

@implementation ToolControl
+ (UIViewController *)currentViewController{
    UIViewController *rootController=[UIApplication sharedApplication].keyWindow.rootViewController;
    while (rootController.presentedViewController!=nil){
        rootController=rootController.presentedViewController;
    }
    return rootController;
}

+ (UIView *)currentView{
    UIViewController *rootController=[UIApplication sharedApplication].keyWindow.rootViewController;
    NSArray *windows=[[UIApplication sharedApplication] windows];
    NSUInteger count=[windows count];
    if (count>1){
        for (int i=1; i<count; i++) {
            if ([[[windows[i] class] description] isEqualToString:@"UITextEffectsWindow"]){
                return windows[i];
            }
        }
    }
    while (rootController.presentedViewController!=nil){
        rootController=rootController.presentedViewController;
    }
    return rootController.view;
}

+ (MBProgressHUD *)sharedHud{
    @synchronized (self){
        if (!_hud){
            UIView *view=[ToolControl currentView];
            if (view==nil){
                return nil;
            }
            _hud=[[MBProgressHUD alloc] initWithView:[ToolControl currentView]];
            _hud.removeFromSuperViewOnHide=YES;
            _hud.delegate=[ToolControl sharedToolControll];
        }
    }
    return _hud;
}

+ (ToolControl *)sharedToolControll{
    @synchronized (self){
        if (!_sharedToolControl){
            _sharedToolControl=[ToolControl new];
        }
    }
    return _sharedToolControl;
}

+ (void)showHudWithTip:(NSString *)tip{
    [[self sharedHud] hide:NO];
    [[self currentView] addSubview:[self sharedHud]];
    [self sharedHud].labelText=tip;
    [[self sharedHud] show:YES];
}

+ (void)hideHudAfterDelay:(CGFloat)delay{
    [[self sharedHud] hide:YES afterDelay:delay];
}

+ (void)hideHud{
    [[self sharedHud] hide:YES];
}

+ (void)setHudShowing:(BOOL)willShow withTip:(NSString *)tip{
    if (willShow){
        [self showHudWithTip:tip];
    }else{
        [self hideHud];
    }
}

+ (void)showBlockHudWithResult:(BOOL)isSuccess andTip:(NSString *)tip{
    if (isSuccess){
        [[self sharedHud] setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark_icon.png"]]];
    }else{
        [[self sharedHud] setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete_icon.png"]]];
    }
    [self sharedHud].mode = MBProgressHUDModeCustomView;
    if (![self sharedHud].superview){
        [[self currentView] addSubview:[self sharedHud]];
    }
    [self sharedHud].labelText=tip;
    [[self sharedHud] show:YES];
    [NSThread detachNewThreadSelector:@selector(sleepForShow) toTarget:[ToolControl sharedToolControll] withObject:nil];
    while (![self sharedToolControll].end) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [[self sharedHud] hide:YES];
    while ([ToolControl sharedHud].superview) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [ToolControl resetHud];
    [ToolControl sharedToolControll].end=NO;
}

+ (void)showHudWithResult:(BOOL)isSuccess andTip:(NSString *)tip{
    if (tip==nil){
        tip=@"";
    }
    if (isSuccess){
        [[self sharedHud] setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark_icon.png"]]];
    }else{
        [[self sharedHud] setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete_icon.png"]]];
    }
    [self sharedHud].mode = MBProgressHUDModeCustomView;
    if (![self sharedHud].superview){
        [[self currentView] addSubview:[self sharedHud]];
    }
    [self sharedHud].labelText=tip;
    [[self sharedHud] show:YES];
    [[self sharedHud] hide:YES afterDelay:_delayTime];
    [ToolControl performSelector:@selector(resetHud) withObject:nil afterDelay:_delayTime+0.3f];
    [ToolControl sharedToolControll].end=NO;
}

+ (void)showHudWithCustomView:(UIView *)view{
    [[self sharedHud] setCustomView:view];
    [self sharedHud].mode = MBProgressHUDModeCustomView;
    if (![self sharedHud].superview){
        [[self currentView] addSubview:[self sharedHud]];
    }
    [self sharedHud].margin=5;
    [[self sharedHud] show:YES];
    [ToolControl sharedToolControll].end=YES;
}

+ (void)resetHud{
    [ToolControl sharedHud].mode=MBProgressHUDModeIndeterminate;
    [ToolControl sharedHud].labelText=@"";
    _delayTime=2.0f;
    [self sharedHud].margin=20;
}

- (void)sleepForShow{
    sleep(_delayTime);
    [self performSelectorOnMainThread:@selector(setOver) withObject:nil waitUntilDone:NO];
}

- (void)setOver{
    _end=YES;
}

+ (void)setHudDelayTime:(CGFloat)time{
    _delayTime=time;
}

#pragma mark -Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [ToolControl resetHud];
}

+ (void)setSeparatorWithTableView:(UITableView *)tableView
{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
