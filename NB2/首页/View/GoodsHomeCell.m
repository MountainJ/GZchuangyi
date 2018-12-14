//
//  GoodsHomeCell.m
//  NB2
//
//  Created by Jayzy on 2017/9/5.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "GoodsHomeCell.h"
#import "UIImageView+WebCache.h"

@interface GoodsHomeCell ()

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *goldLabel;
@property (nonatomic,strong) UILabel *silverLabel;
@property (nonatomic,strong) UIButton *changeButton;

@end

@implementation GoodsHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconView];
    
    self.nameLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont boldSystemFontOfSize:KKFitScreen(30)] addToView:self.contentView labelText:nil];
    
    self.goldLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor orangeColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:self.contentView labelText:nil];

    self.silverLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor orangeColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:self.contentView labelText:nil];

    self.changeButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:COLOR_STATUS_NAV_BAR_BACK cornerRadius:5.0f textColor:[UIColor whiteColor] clickAction:@selector(change) clickTarget:self addToView:self.contentView buttonText:@"兑换"];
    
    
    [self frameConfig];
}

- (void)frameConfig
{
    WS(weakSelf)
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(KKFitScreen(30));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(KKFitScreen(200));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconView.mas_right).with.offset(KKFitScreen(20));
        make.top.mas_equalTo(weakSelf.iconView.mas_top).with.offset(KKFitScreen(20));
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(KKFitScreen(60));
    }];
    
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.right.mas_equalTo(weakSelf.nameLabel.mas_right);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).with.offset(KKFitScreen(0));
        make.height.mas_equalTo(KKFitScreen(40));
    }];
    
    [self.silverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.goldLabel);
        make.top.mas_equalTo(weakSelf.goldLabel.mas_bottom);
        make.height.mas_equalTo(weakSelf.goldLabel.mas_height);
    }];
    
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-KKFitScreen(20));
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-KKFitScreen(20));
        make.width.mas_equalTo(KKFitScreen(200));
        make.height.mas_equalTo(KKFitScreen(60));
    }];
    //
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

- (void)change
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(GoodsHomeCell:model:)]) {
        [self.delegate GoodsHomeCell:self model:self.model];
    }

}

- (void)setModel:(GoodsModel *)model
{
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:nil];
    
    self.nameLabel.text = model.title;
    //显示价格的描述 2018.11.25
    self.goldLabel.text = [NSString stringWithFormat:@"%@",model.price];
    if ([model.type integerValue] == 1) {
        self.goldLabel.text = [NSString stringWithFormat:@"负数钱包：%@",model.fushujiage];
        self.silverLabel.text = [NSString stringWithFormat:@"理财钱包：%@",model.licaijiage];
    }
   
}

@end
