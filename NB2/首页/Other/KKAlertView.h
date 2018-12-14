//
//  KKAlertView.h
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureBuyProductBlock)(NSString *numbers,NSString *type);

@interface KKAlertView : UIView

@property (nonatomic,copy) SureBuyProductBlock  block;

- (void)didSureBuy:(SureBuyProductBlock)sureBuyBlock;

- (void)showInPresentedViewController:(UIViewController *)currentController userDataInfo:(id)userData;

- (void)dismissAlertViewAnimated:(BOOL)animated;

@end

