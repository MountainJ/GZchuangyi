//
//  ZhongchouHomeCell.m
//  NB2
//
//  Created by Jayzy on 2017/9/3.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ZhongchouHomeCell.h"
#import "UILabel+KLable_expend.h"
#import "UIImageView+WebCache.h"

@interface ZhongchouHomeCell  ()

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UIImageView *titleView;
@property (nonatomic,strong) UILabel *contenLabel;

@property (nonatomic,strong) UIImageView *leftView;

@property (nonatomic,strong) UIButton *goButton;
@property (nonatomic,strong) UILabel *tipsLabel;
@property (nonatomic,strong) UIImageView *arrowView;

@end

@implementation ZhongchouHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    //900* 330
    CGFloat imgHeight = SCREEN_WIDTH * (358.0/720.0);
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,imgHeight)];
    self.iconView.contentMode= UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconView];
    //
    CGFloat titleHeight = 90;
    self.contenLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - KKFitScreen(40), self.iconView.bounds.size.height * 0.5 - titleHeight * 0.5, SCREEN_WIDTH * 0.5 , titleHeight) backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] textFont:[UIFont boldSystemFontOfSize:KKFitScreen(60)] addToView:self.iconView labelText:@""];
    
    
//    CGFloat titleHeight = 60;
//    self.titleView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - 20, self.iconView.bounds.size.height * 0.5 - titleHeight * 0.5, 140,titleHeight)];
//    self.titleView.contentMode= UIViewContentModeScaleAspectFit;
//    [self.iconView addSubview:self.titleView];
    // 170 * 110
    CGFloat width = CGRectGetMinX(self.contenLabel.frame) - KKFitScreen(80);
    CGFloat leftHeight = width * (110.0/170.0);
    self.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.iconView.bounds.size.height * 0.5 - leftHeight * 0.5,width ,leftHeight)];
    self.leftView.contentMode= UIViewContentModeScaleAspectFit;
    [self.iconView addSubview:self.leftView];
    
    
    self.tipsLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconView.frame), SCREEN_WIDTH - KKFitScreen(70), ZHONGCHOU_CELL_HEIGHT - imgHeight) backGroundColor:[UIColor whiteColor] textColor:[UIColor lightGrayColor] textFont:[UIFont boldSystemFontOfSize:KKFitScreen(32)] addToView:self.contentView labelText:@"进入"];
    self.tipsLabel.textAlignment = NSTextAlignmentRight;
    
    self.arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tipsLabel.frame)+ 2, CGRectGetMidY(self.tipsLabel.frame) - 12,24,24)];
    self.arrowView.contentMode= UIViewContentModeScaleAspectFit;
    self.arrowView.image = [UIImage imageNamed:@"arrow"];
    [self.contentView addSubview:self.arrowView];
    

    [self frameConfig];
}

- (void)frameConfig
{
    
}
- (void)setModel:(ZhongchouModel *)model
{
    if (!model) {
        return;
    }
    self.iconView.image = [UIImage imageNamed:model.homeBackImg];
    self.contenLabel.text = model.title;
    self.leftView.image = [UIImage imageNamed:model.leftImg];
}

@end
