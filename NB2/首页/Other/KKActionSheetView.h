//
//  KKActionSheetView.h
//  KKOL
//
//  Created by Jayzy on 2017/8/10.
//  Copyright © 2017年 KKZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKActionSheetView;

@protocol KKActionSheetViewDelegate <NSObject>
@optional
//如果点击的是空白处，那么index的值设为－1
- (void)actionSheet:(KKActionSheetView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
//设计是点击cacel按钮会调用
- (void)actionSheetCancel:(KKActionSheetView *)actionSheet;

- (void)willPresentActionSheet:(KKActionSheetView *)actionSheet;

- (void)didPresentActionSheet:(KKActionSheetView *)actionSheet;

- (void)actionSheet:(KKActionSheetView *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;

- (void)actionSheet:(KKActionSheetView *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end


@interface KKActionSheetView : UIView <UITableViewDelegate,UITableViewDataSource>

- (UIView *)initWithTitle:(NSString *)title delegate:(id<KKActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:( NSString *)destructiveButtonTitle otherButtonTitles:( NSString *)otherButtonTitles, ...;

- (void)showInView:(UIView *)view;

@end
