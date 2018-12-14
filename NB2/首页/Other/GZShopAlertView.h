//
//  GZShopAlertView.h
//  NB2
//
//  Created by Jayzy on 2018/11/25.
//  Copyright © 2018年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


static NSString *kPayitemNameKey = @"kPayitemNameKey";
static NSString *kPayitemTypeKey = @"kPayitemTypeKey";

typedef void(^SureBuyProductBlock)(NSString *numbers,NSString *type);

@interface GZShopAlertView : UIView

@property (nonatomic,copy) SureBuyProductBlock  block;

- (void)didSureBuy:(SureBuyProductBlock)sureBuyBlock;

- (void)showInPresentedViewController:(UIViewController *)currentController paymentItems:(NSArray *)array userDataInfo:(id)userData;

- (void)dismissAlertViewAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
