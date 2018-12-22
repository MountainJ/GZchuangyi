//
//  TopView.m
//  left
//
//  Created by yes on 14-11-6.
//  Copyright (c) 2014年 lh2424. All rights reserved.
//

#import "TopView.h"
#define kBtnW 40
#define kBorderW 0
#define kTitleFont 17
#define kIndicatorW 30


@implementation TopView
{
    UIActivityIndicatorView *_indicatorView;

}

@synthesize titileTx,buttonLB,buttonRB,imgLeft,imgRight,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT+ APP_STATUS_BAR_HEIGHT);
        self.leftB=[[UIButton alloc]init];
        self.rightB=[[UIButton alloc]init];
        titleCenter= [[UILabel alloc]init];
        
    }
    return self;
}



-(void)setTopView
{
    UIView *toptopview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20+JF_TOP_ACTIVE_SPACE)];
    toptopview.backgroundColor = COLOR_STATUS_NAV_BAR_BACK;
    [self addSubview:toptopview];
    
    UIImageView *toorview=[[UIImageView alloc] initWithFrame:CGRectMake(0, toptopview.frame.size.height, SCREEN_WIDTH, NAV_BAR_HEIGHT)];
    toorview.backgroundColor=COLOR_STATUS_NAV_BAR_BACK;
    toorview.userInteractionEnabled=YES;
    [self addSubview:toorview];
    titleCenter.textColor=[UIColor whiteColor];
    
    //重新根据字体宽度居中显示
    CGSize size;
    titleCenter.frame=CGRectMake(SCREEN_WIDTH*0.15, 25+JF_TOP_ACTIVE_SPACE,SCREEN_WIDTH*0.7, 35);
    titleCenter.font=[UIFont systemFontOfSize:KKFitScreen(40)];
    titleCenter.textAlignment=NSTextAlignmentCenter;
    titleCenter.adjustsFontSizeToFitWidth=YES;
    titleCenter.backgroundColor=[UIColor clearColor];
    self.backgroundColor= [UIColor clearColor];//topBack;
    [titleCenter setText:titileTx];
    [self addSubview:titleCenter];
    [self addSubview:_indicatorView];
    //  左键
    if (imgLeft.length>0)      //  左侧图片侧边栏菜单
    {
        self.leftB.frame=CGRectMake(0, 23+JF_TOP_ACTIVE_SPACE, 41, 40);
        self.leftB.showsTouchWhenHighlighted = YES;
        [self.leftB addTarget:self action:@selector(toLeft:) forControlEvents:UIControlEventTouchDown];
        [self.leftB setBackgroundImage:[UIImage imageNamed:imgLeft] forState:UIControlStateNormal];
        [self.leftB setBackgroundImage:[UIImage imageNamed:imgLeft] forState:UIControlStateHighlighted];
        [self addSubview:self.leftB];
    }
    else if (buttonLB.length >0)
    {
       self.leftB.titleLabel.text=buttonLB;
       [self.leftB.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
       NSDictionary *attribute = @{NSFontAttributeName: self.leftB.titleLabel.font};
       size = [self.leftB.titleLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 20) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
       self.leftB.frame=CGRectMake(10, 25+JF_TOP_ACTIVE_SPACE, size.width+20, 30);
       [self.leftB setBackgroundColor:[UIColor clearColor] ];
       [self.leftB setTitle:buttonLB forState:UIControlStateNormal];
       self.leftB.showsTouchWhenHighlighted = YES;
       [self.leftB addTarget:self action:@selector(toLeft:) forControlEvents:UIControlEventTouchDown];
        [self.leftB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.leftB];
        if (size.width==0) {
            [self.leftB removeFromSuperview];
        }
    }
    else if (imgLeft.length>0)      //  左侧图片侧边栏菜单
    {
        self.leftB.frame=CGRectMake(0, 24+JF_TOP_ACTIVE_SPACE, 40, 39);
        self.leftB.showsTouchWhenHighlighted = YES;
        [self.leftB addTarget:self action:@selector(toLeft:) forControlEvents:UIControlEventTouchDown];
        [self.leftB setBackgroundImage:[UIImage imageNamed:imgLeft] forState:UIControlStateNormal];
        [self.leftB setBackgroundImage:[UIImage imageNamed:imgLeft] forState:UIControlStateHighlighted];
        [self addSubview:self.leftB];
    }
    
    if(buttonRB.length>0)      //右键
    {
        self.rightB.titleLabel.text=buttonRB;
        [self.rightB setBackgroundColor:[UIColor clearColor]];
        [self.rightB setTitle:buttonRB forState:UIControlStateNormal];
        [self.rightB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightB.titleLabel setFont:[UIFont boldSystemFontOfSize:KKFitScreen(28)]];
        NSDictionary *attribute = @{NSFontAttributeName: self.rightB.titleLabel.font};
        size = [self.rightB.titleLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 20) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        self.rightB.frame=CGRectMake(SCREEN_WIDTH-size.width-20-5, 30+JF_TOP_ACTIVE_SPACE, size.width+20, 30);
        self.rightB.showsTouchWhenHighlighted = YES;
        [self.rightB addTarget:self action:@selector(toRight:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.rightB];
        if (size.width==0) {
            [self.rightB removeFromSuperview];
        }
    }
    else if(imgRight.length>0)      //右键
    {
        CGFloat imgWidth = 30;
        self.rightB.frame=CGRectMake(SCREEN_WIDTH - imgWidth - 10, 20 + NAV_BAR_HEIGHT * 0.5 - imgWidth * 0.5+JF_TOP_ACTIVE_SPACE, imgWidth, imgWidth);
        self.rightB.showsTouchWhenHighlighted = YES;
        [self.rightB addTarget:self action:@selector(toRight:) forControlEvents:UIControlEventTouchDown];
        [self.rightB setBackgroundImage:[UIImage imageNamed:imgRight] forState:UIControlStateNormal];
        [self.rightB setBackgroundImage:[UIImage imageNamed:imgRight] forState:UIControlStateHighlighted];
        [self addSubview:self.rightB];
    }

}
//第一步：在info.plist中添加一个字段：view controller -base status bar 设置为NO
//第二步：在一个所有界面都继承的父类里添加：
//if (IOS7_OR_LATER) { // 判断是否是IOS7
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//}
-(void)toLeft:(id)sender{
    
//    UIButton *tempB = (UIButton *)sender;
    [delegate actionLeft];
    
}

-(void)toRight:(id)sender{
    
//    UIButton *tempB = (UIButton *)sender;
    [self.delegate actionRight];
    
}

-(void)setTitile:(NSString *)titileText
{
    titleCenter.text=titileText;
    CGSize size;
    NSDictionary *attribute = @{NSFontAttributeName: titleCenter.font};
    size = [titleCenter.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 20) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    titleCenter.frame=CGRectMake((SCREEN_WIDTH-size.width-20)/2, 20+JF_TOP_ACTIVE_SPACE, size.width+20, 40);
    titleCenter.textColor=[UIColor whiteColor];
    titleCenter.backgroundColor=[UIColor clearColor];
}
-(void)start
{
    [_indicatorView startAnimating];
}
-(void)stop
{
    [_indicatorView stopAnimating];

}
@end
