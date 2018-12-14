//
//  ShopInfoCell.m
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ShopInfoCell.h"

@interface ShopInfoCell()

@property (nonatomic,strong) UILabel *xingouLabel;
@property (nonatomic,strong) UIButton *changeButton;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *goldLabel;
@property (nonatomic,strong) UILabel *silverLabel;
@property (nonatomic,strong) UILabel *zhonggouLabel;

@end

@implementation ShopInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.xingouLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor orangeColor] textFont:[UIFont systemFontOfSize:KKFitScreen(24)] addToView:self.contentView labelText:@""];
    self.xingouLabel.textAlignment = NSTextAlignmentCenter;

    self.nameLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont boldSystemFontOfSize:KKFitScreen(30)] addToView:self.contentView labelText:@""];

    self.goldLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor orangeColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:self.contentView labelText:@""];
    self.goldLabel.numberOfLines = 2;

    self.silverLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor orangeColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:self.contentView labelText:@""];
    
    self.zhonggouLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor orangeColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:self.contentView labelText:@""];

    
    self.changeButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:COLOR_STATUS_NAV_BAR_BACK cornerRadius:5.0 textColor:[UIColor whiteColor] clickAction:@selector(changeProduct) clickTarget:self addToView:self.contentView buttonText:@"兑换"];
    self.changeButton.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(26)];

    self.lineView = [[UIView alloc] init];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = COLOR_LIGHTGRAY_BACK;
    
    [self frameConfig];
}

- (void)frameConfig
{
    WS(weakSelf)
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-KKFitScreen(30));
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-KKFitScreen(30));
        make.width.mas_equalTo(KKFitScreen(140));
        make.height.mas_equalTo(KKFitScreen(60));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf.contentView);
        make.right.mas_equalTo(weakSelf.changeButton.mas_left).with.offset(-KKFitScreen(60));
        make.width.mas_equalTo(2);
    }];
    
    [self.xingouLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.bottom.mas_equalTo(weakSelf.changeButton.mas_top);
        make.top.mas_equalTo(weakSelf.contentView.mas_top);
        make.left.mas_equalTo(weakSelf.lineView.mas_right);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.lineView.mas_left);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(KKFitScreen(30));
        make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(KKFitScreen(10));
        make.height.mas_equalTo(KKFitScreen(60));
    }];
    
    [self.zhonggouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameLabel);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset( - KKFitScreen(2));
        make.height.mas_equalTo(0.00001);
    }];
    
    [self.silverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameLabel);
        make.bottom.mas_equalTo(weakSelf.zhonggouLabel.mas_top).with.offset( - KKFitScreen(0));
        make.height.mas_equalTo(weakSelf.nameLabel.mas_height);
    }];
    
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameLabel);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.silverLabel.mas_top);
    }];
    
}


- (void)changeProduct
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShopInfoCell:action:)]) {
        [self.delegate ShopInfoCell:self action:self.model];
    }
}

- (void)setModel:(GoodsModel *)model
{
    _model = model;
    self.nameLabel.text = model.title;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(KKFitScreen(46));
    }];
    self.xingouLabel.text = [NSString stringWithFormat:@"每个ID限购：%@",model.xiangou];

    //修改显示 2018.11.25 jay
    NSString *lineStr = @"<br>";
    if ([model.price hasSuffix:lineStr] && model.price.length > lineStr.length + 1) {
        model.price = [ model.price substringToIndex:model.price.length - lineStr.length];
    }
    model.price = [model.price stringByReplacingOccurrencesOfString:lineStr withString:@"\n"];
    self.goldLabel.text = [NSString stringWithFormat:@"%@",model.price];
    self.silverLabel.text = [NSString stringWithFormat:@"库存：%@",model.kucun];

    if ([model.type integerValue] == 1) {
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KKFitScreen(46));
        }];
        [self.zhonggouLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KKFitScreen(46));
        }];
        self.goldLabel.text = [NSString stringWithFormat:@"负数钱包：%@    负数钱包库存：%@",model.fushujiage,model.fushukucun];
        self.silverLabel.text = [NSString stringWithFormat:@"理财钱包：%@    理财钱包库存：%@",model.licaijiage,model.licaikucun];
        self.zhonggouLabel.text = [NSString stringWithFormat:@"众购钱包：%@    众购钱包库存：%@",model.zhonggoujiage,model.zhonggoukucun];
    }
}



@end
