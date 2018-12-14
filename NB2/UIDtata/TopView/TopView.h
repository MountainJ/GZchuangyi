//
//  TopView.h
//  left
//
//  Created by yes on 14-11-6.
//  Copyright (c) 2014年 lh2424. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopViewDelegate<NSObject>

@optional
-(void)actionLeft;
-(void)actionRight;
@end


@interface TopView : UIView
{
    UILabel *titleCenter;
    NSString *titileTx,*buttonLB,*buttonRB,*imgLeft,*imgRight;
}
@property (nonatomic,strong) UIButton *leftB;
@property (nonatomic,strong) UIButton *rightB;
@property (nonatomic,copy) NSString *titileTx,*buttonLB,*buttonRB,*imgLeft,*imgRight;
@property (nonatomic, weak) id<TopViewDelegate> delegate;
@property (nonatomic, assign) int sign;

-(void)setTopView;
-(void)start;
-(void)stop;


@end
