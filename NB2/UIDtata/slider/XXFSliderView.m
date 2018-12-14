//
//  XXFSliderView.m
//  KKOL
//
//  Created by My!ove灬丿南美鹰 on 15-6-15.
//  Copyright (c) 2015年 2291108617@qq.com. All rights reserved.
//

#import "XXFSliderView.h"

@interface XXFSliderView ()
{
    CGFloat height,width,x;
    int count;
    UIButton * oldbtn;
    NSMutableArray * btnArr;
    CGFloat _bottomLineHeight;

}


@property (nonatomic,strong)UIView * lineView;
@end


@implementation XXFSliderView


//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        
//    }
//    return self;
//}


/**
 *  滑块
 *
 *  @param sliderTextArr 每个滑块的名字
 *  @param color         滑块下边的滑块颜色
 */
- (void)sliderTextArr:(NSArray*)sliderTextArr sliderLineColor:(UIColor*)color;
{
    btnArr = [NSMutableArray array];
    self.backgroundColor = [UIColor whiteColor];
    width = self.frame.size.width;
    height = self.frame.size.height;
    count = width/sliderTextArr.count;
    for (int i = 0; i < sliderTextArr.count; i++)
    {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(count*i, 0, count, height)];
        [btn setTitle:sliderTextArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:color forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(30)];
        [btn addTarget:self action:@selector(sliderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self addSubview:btn];
        [btnArr addObject:btn];
        if (i == 0)
        {
            btn.selected = YES;
            oldbtn = btn;
        }
    }
    //
    if (!_lineView)
    {
        _bottomLineHeight = self.bottomLineHeight > 0 ? self.bottomLineHeight : 2;
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, height-_bottomLineHeight, count, _bottomLineHeight)];
        _lineView.backgroundColor = color;
        [self addSubview:_lineView];
    }
    //
    if (self.showMiddleLine) {
        UIView *middleLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.frame), KKFitScreen(4), KKFitScreen(2), self.bounds.size.height - KKFitScreen(6))];
        middleLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        [self addSubview:middleLine];
    }
}

// 点击事件
- (void)sliderBtnClick:(UIButton*)btn
{
    if (oldbtn!=btn) {
        btn.selected=YES;
        [UIView animateWithDuration:0.25 animations:^{
            if (self.customLineWidth) {
                CGRect frame = _lineView.frame;
                frame.origin.x = btn.tag*count+(count-self.customLineWidth)*0.5;
                _lineView.frame = frame;
                
            }else{
                CGRect frame = _lineView.frame;
                frame.origin.x = btn.tag*count;
                _lineView.frame = frame;
            }
        }];
        oldbtn.selected=NO;
        oldbtn=btn;
        [oldbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        if (_delegate)
        {
            [_delegate seletIndex:btn.tag];
        }

    }
}

// 选中的滑块
- (void)selectBtn:(NSInteger)seletIndex
{
    for (UIButton * selectBtn in btnArr)
    {

        selectBtn.selected  =NO;
        if (seletIndex == selectBtn.tag)
        {
            selectBtn.selected = YES;
            oldbtn = selectBtn;
            [UIView animateWithDuration:0.25 animations:^{
                if (self.customLineWidth) {
                    CGRect frame = _lineView.frame;
                    frame.origin.x = selectBtn.tag*count+(count-self.customLineWidth)*0.5;
                    _lineView.frame = frame;
                    
                }else{
                    CGRect frame = _lineView.frame;
                    frame.origin.x = selectBtn.tag*count;
                    _lineView.frame = frame;
                }
            }];
        }
    }
}

- (void)setSliderBackgroundColor:(UIColor *)backColor
{
    for (UIButton *sliderBtn in btnArr) {
        sliderBtn.backgroundColor = backColor;
    }
}


- (void)setSliderLineViewWidth:(CGFloat)lineWidth
{
    self.customLineWidth = lineWidth;
    _bottomLineHeight = self.bottomLineHeight > 0 ? self.bottomLineHeight : 2;
    _lineView.frame = CGRectMake((count-lineWidth)*0.5, height-_bottomLineHeight, self.customLineWidth, _bottomLineHeight);
}


- (NSUInteger)selectedIndex{
    return oldbtn.tag;
}


@end
