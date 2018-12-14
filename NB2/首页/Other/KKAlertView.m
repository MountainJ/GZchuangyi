//
//  KKAlertView.m
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "KKAlertView.h"
#import "GoodsModel.h"
#import "ZhongchouModel.h"

#define SILVER_BUTTON_WIDTH     KKFitScreen(170)


@interface KKAlertView ()

@property (nonatomic,strong) UILabel *navLabel;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *maxLimitLabel;

@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIButton *plusButton;
@property (nonatomic,strong) UIButton *minusButton;
@property (nonatomic,strong) UIButton *goldButton;
@property (nonatomic,strong) UIButton *silverButton;
@property (nonatomic,strong) UIButton *zhonggouButton;

@property (nonatomic,strong) UIButton *sureButton;

@property (nonatomic,strong) UIView *maskBackView;
@property (nonatomic,strong) id model;

@property (nonatomic,copy) NSString *navTitle;
@property (nonatomic,copy) NSString *tipsTitle;
@property (nonatomic,copy) NSString *numberShowTitle;
@property (nonatomic,copy) NSString *maxlimitTips;
@end

@implementation KKAlertView

- (UIView *)maskBackView
{
    if (!_maskBackView) {
        _maskBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskBackView.backgroundColor = [[UIColor darkTextColor] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handldMaskTap:)];
        [_maskBackView addGestureRecognizer:tap];
        
    }
    return _maskBackView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:[UIColor whiteColor] textColor:nil clickAction:@selector(closeBackMask) clickTarget:self addToView:self.maskBackView buttonText:@""];
        _closeButton.layer.cornerRadius = KKFitScreen(30);
        _closeButton.layer.masksToBounds = YES;
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"alert_close"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        
        [self addChildView];
    }
    return self;
}

- (void)addChildView
{
    //
    
    self.navLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:COLOR_STATUS_NAV_BAR_BACK textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:KKFitScreen(34)] addToView:self labelText:@"兑换商品"];
    self.navLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tipLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor orangeColor] textFont:[UIFont systemFontOfSize:KKFitScreen(30)] addToView:self labelText:@"兑换数量"];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    
    self.numberLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:COLOR_RGB(243, 243, 243) textColor:[UIColor darkTextColor] textFont:[UIFont boldSystemFontOfSize:KKFitScreen(30)] addToView:self labelText:@"1"];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;

    self.typeLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor redColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:self labelText:@"请选择支付类型:"];
    self.typeLabel.textAlignment = NSTextAlignmentRight;

    self.maxLimitLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor redColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:self labelText:nil];
    self.maxLimitLabel.textAlignment = NSTextAlignmentCenter;

    self.plusButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:COLOR_STATUS_NAV_BAR_BACK textColor:[UIColor whiteColor] clickAction:@selector(plusOrMinus:) clickTarget:self addToView:self buttonText:@"+"];

    self.minusButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:COLOR_STATUS_NAV_BAR_BACK textColor:[UIColor whiteColor] clickAction:@selector(plusOrMinus:) clickTarget:self addToView:self buttonText:@"-"];

    
    self.goldButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] clickAction:@selector(clidktype:) clickTarget:self addToView:self buttonText:@"创益金币"];
    self.goldButton.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(26)];
    self.goldButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.goldButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.goldButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self.goldButton setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [self.goldButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    
    self.silverButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] clickAction:@selector(clidktype:) clickTarget:self addToView:self buttonText:@"创益银币"];
    self.silverButton.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(26)];
    [self.silverButton setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    self.silverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.silverButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self.silverButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.silverButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    self.silverButton.selected = YES;

    
    self.zhonggouButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] clickAction:@selector(clidktype:) clickTarget:self addToView:self buttonText:@"众购钱包"];
    self.zhonggouButton.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(26)];
    [self.zhonggouButton setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    self.zhonggouButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.zhonggouButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self.zhonggouButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.zhonggouButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    
    
    self.sureButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:COLOR_STATUS_NAV_BAR_BACK cornerRadius:6.0 textColor:[UIColor whiteColor] clickAction:@selector(userClickSure) clickTarget:self addToView:self buttonText:@"确定"];

    
}

- (void)frameConfig
{
    
    WS(weakSelf)
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_top);
        make.centerX.mas_equalTo(weakSelf.mas_right);
        make.width.height.mas_equalTo(KKFitScreen(60));
    }];
    
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf);
        make.height.mas_equalTo(KKFitScreen(80));
    }];
    
    [self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right).offset(-KKFitScreen(60));
        make.top.mas_equalTo(weakSelf.navLabel.mas_bottom).offset(KKFitScreen(40));
        make.width.height.mas_equalTo(KKFitScreen(60));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.plusButton.mas_left);
        make.top.bottom.mas_equalTo(weakSelf.plusButton);
        make.width.mas_equalTo(SILVER_BUTTON_WIDTH * 2 - 2*KKFitScreen(60));
    }];
    [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.numberLabel.mas_left);
        make.top.bottom.mas_equalTo(weakSelf.plusButton);
        make.width.mas_equalTo(weakSelf.plusButton.mas_width);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.minusButton.mas_left);
        make.top.bottom.mas_equalTo(weakSelf.minusButton);
        make.left.mas_equalTo(weakSelf.mas_left);
    }];
    

    [self.silverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.plusButton.mas_right).with.offset(-KKFitScreen(0));
        make.width.mas_equalTo(SILVER_BUTTON_WIDTH);
        make.height.mas_equalTo(KKFitScreen(70));
        make.top.mas_equalTo(weakSelf.plusButton.mas_bottom).with.offset(KKFitScreen(20));
    }];
    
    [self.goldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.silverButton.mas_left);
        make.top.bottom.mas_equalTo(weakSelf.silverButton);
        make.width.mas_equalTo(weakSelf.silverButton.mas_width);
    }];
    
  
    
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.goldButton.mas_left);
        make.left.mas_equalTo(weakSelf.mas_left);
        make.top.bottom.mas_equalTo(weakSelf.goldButton);
    }];
    
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(KKFitScreen(60));
        make.right.mas_equalTo(weakSelf.mas_right).offset(-KKFitScreen(60));
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-KKFitScreen(30));
        make.height.mas_equalTo(KKFitScreen(70));
    }];
    
    [self.maxLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.sureButton.mas_top).with.offset(-KKFitScreen(20));
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(KKFitScreen(40));
    }];
    
    [self.zhonggouButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.goldButton);
        make.top.mas_equalTo(weakSelf.goldButton.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.maxLimitLabel.mas_top);
    }];
    self.zhonggouButton.hidden = YES;
    
    
}

#pragma mark - 

- (void)clidktype:(UIButton *)btn
{
    if ([self.model isKindOfClass:[GoodsModel class]] && [[(GoodsModel *)self.model type] integerValue] == 1) {
        if (btn == self.goldButton) {
            self.goldButton.selected = YES;
            self.silverButton.selected =  self.zhonggouButton.selected = NO;
        }else if (btn == self.silverButton){
            self.silverButton.selected = YES;
            self.goldButton.selected =  self.zhonggouButton.selected = NO;
        }else if (btn == self.zhonggouButton){
            self.zhonggouButton.selected = YES;
            self.goldButton.selected =  self.silverButton.selected = NO;
        }
        return;
    }
    if (btn == self.goldButton) {
        self.goldButton.selected = YES;
        self.silverButton.selected = NO;
    }else if (btn == self.silverButton){
        self.silverButton.selected = YES;
        self.goldButton.selected = NO;
    }
}


#pragma mark - 添加到背景上面去
- (void)showInPresentedViewController:(UIViewController *)currentController userDataInfo:(id)userData
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskBackView];
    [self.maskBackView addSubview:self];
    [self.maskBackView addSubview:self.closeButton];
    _maskBackView.transform = CGAffineTransformMakeScale(1.0, 0.000001);

    [self frameConfig];
    
    [self updateDataUIWithModel:userData];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.maskBackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView commitAnimations];

}

- (void)updateDataUIWithModel:(id)modelObject
{
    if ([modelObject isKindOfClass:[GoodsModel class]]) {
        self.model = (GoodsModel *)modelObject;
        self.numberLabel.text  = @"1";
        
        self.silverButton.selected  = YES;
        self.goldButton.selected  = NO;
        if ([[(GoodsModel *)modelObject type] integerValue] == 1) {
            [self.goldButton setTitle:@"负数钱包" forState:UIControlStateNormal];
            [self.silverButton setTitle:@"理财钱包" forState:UIControlStateNormal];
            self.zhonggouButton.selected =  self.zhonggouButton.hidden =NO;
            self.goldButton.selected = YES;
            self.silverButton.selected = NO;
        }
        //
        self.navLabel.text = @"兑换商品";
        self.tipLabel.text = @"兑换数量";
        self.maxLimitLabel.text = nil;

        self.maxlimitTips = [NSString stringWithFormat:@"最多兑换:%ld件",[[(GoodsModel *)self.model xiangou] integerValue]];
        
    }else if ([modelObject isKindOfClass:[ZhongchouModel class]])
    {
        self.model = (ZhongchouModel *)modelObject;
        self.numberLabel.text  = @"1";
        self.silverButton.selected  = YES;
        self.goldButton.selected  = NO;
        //
        self.navLabel.text = @"我要跟投";
        self.tipLabel.text = @"跟投数量";
        self.maxLimitLabel.text = nil;

        self.maxlimitTips = [NSString stringWithFormat:@"最多跟投:%ld份",[[(GoodsModel *)self.model xiangou] integerValue]];

    }
}

- (void)userClickSure
{
    [self dismissAlertViewAnimated:NO];
    if (self.block && [self.model isKindOfClass:[GoodsModel class]]) {
        NSString *type = @"3";
        if (self.goldButton.selected) {
            type = @"3";
        }else if (self.silverButton.selected){
            type = @"2";
        }else if (self.zhonggouButton.selected){
            type = @"4";
        }
        self.block(self.numberLabel.text, type);
        return;
    }
    if (self.block) {
        self.block(self.numberLabel.text, self.silverButton.selected ? @"0":@"1");
    }
}

- (void)plusOrMinus:(UIButton *)btn
{
    NSInteger currentNumber = [self.numberLabel.text integerValue];
    if (btn == self.plusButton) {
        currentNumber ++ ;
        if (currentNumber <= [[(GoodsModel *)self.model xiangou] integerValue]) {
            self.maxLimitLabel.text = nil;
            self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)currentNumber];
        }else{
              //弹出提示;
            self.maxLimitLabel.text = self.maxlimitTips;
        }
    }else if (btn == self.minusButton) {
        currentNumber -- ;
        self.maxLimitLabel.text = nil;
        if (currentNumber >= 1) {
            self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)currentNumber];
        }else{
            //弹出提示;
        }
    }

}

#pragma mark -
- (void)closeBackMask
{
    [self dismissAlertViewAnimated:YES];
}

- (void)handldMaskTap:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.maskBackView];
    CGRect frame = self.frame;
    if (CGRectContainsPoint(frame, point)) {
        return;
    }
    [self dismissAlertViewAnimated:YES];
}


- (void)dismissAlertViewAnimated:(BOOL)animated
{
    if (animated) {
        WS(weakSelf)
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.maskBackView.transform = CGAffineTransformMakeScale(1.0, 0.0001);
        } completion:^(BOOL finished) {
            [weakSelf.maskBackView removeFromSuperview];
        }];
        
    }else{
        [self.maskBackView removeFromSuperview];
      
    }
    
}

- (void)didSureBuy:(SureBuyProductBlock)sureBuyBlock
{
    _block = sureBuyBlock;
}


@end
