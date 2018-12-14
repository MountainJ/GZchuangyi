//
//  XXFSliderView.h
//  KKOL
//
//  Created by My!ove灬丿南美鹰 on 15-6-15.
//  Copyright (c) 2015年 2291108617@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SLIDER_BG [UIColor colorWithRed:36/255.0f green:157/255.0f blue:216/255.0f alpha:1.0f]

@protocol XXFSliderViewDelegate <NSObject>

/**
 *  点击滑块
 *
 *  @param selectIndex 点击滑块
 */
- (void)seletIndex:(NSInteger)selectIndex;

@end


@interface XXFSliderView : UIView

@property(nonatomic,assign)id<XXFSliderViewDelegate>delegate;

@property (nonatomic,assign) NSUInteger selectedIndex;

@property (nonatomic,assign) CGFloat customLineWidth;
//滑动条的高度
@property (nonatomic,assign) CGFloat bottomLineHeight;


@property (nonatomic,assign) BOOL showMiddleLine;


/**
 *  滑块
 *
 *  @param sliderTextArr 每个滑块的名字
 *  @param color         滑块下边的滑块颜色
 */
- (void)sliderTextArr:(NSArray*)sliderTextArr sliderLineColor:(UIColor*)color;

// 选中的滑块
- (void)selectBtn:(NSInteger)seletIndex;

/**
 *  设置滑块背景显示颜色
 */
- (void)setSliderBackgroundColor:(UIColor *)backColor;
/**
 *  设置滑块下划线宽度
 *
 *  @param lineWidth
 */
- (void)setSliderLineViewWidth:(CGFloat)lineWidth;


@end
