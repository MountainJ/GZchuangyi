//
//  GZCoinHistoryListCell.m
//  NB2
//
//  Created by 张毅 on 2018/12/21.
//  Copyright © 2018年 MoutainJay. All rights reserved.
//

#import "GZCoinHistoryListCell.h"


@interface GZCoinHistoryListCell ()

@property (nonatomic,strong) UILabel  *userLabel;
@property (nonatomic,strong) UILabel  *phoneLabel;
@property (nonatomic,strong) UILabel  *nameLabel;
@property (nonatomic,strong) UILabel  *numberLabel;
@property (nonatomic,strong) UILabel  *dateLabel;


@end

@implementation GZCoinHistoryListCell


- (UILabel *)userLabel
{
    if (!_userLabel) {
        _userLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28.)] addToView:self.contentView labelText:@""];
        _userLabel.numberOfLines = 2;
    }
    return _userLabel ;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28.)] addToView:self.contentView labelText:@""];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel ;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28.)] addToView:self.contentView labelText:@""];
    }
    return _numberLabel ;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28.)] addToView:self.contentView labelText:@""];
    }
    return _phoneLabel ;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28.)] addToView:self.contentView labelText:@""];
    }
    return _dateLabel ;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    [self.contentView addSubview:self.userLabel];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.dateLabel];
    
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(5.);
        make.top.mas_equalTo(self.contentView.mas_top).offset(0.);
        make.width.mas_equalTo(self.bounds.size.width).multipliedBy(0.6);
        make.height.mas_equalTo(KKFitScreen(50));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userLabel.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.bottom.equalTo(self.userLabel);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userLabel);
        make.top.mas_equalTo(self.userLabel.mas_bottom);
        make.height.mas_equalTo(self.userLabel.mas_height);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.height.mas_equalTo(self.nameLabel.mas_height);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userLabel);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.top.mas_equalTo(self.phoneLabel.mas_bottom);
        make.right.mas_equalTo(self.contentView);
    }];
    
    
    
}

- (void)setModel:(GZChuangyebiModel *)model
{
    _model = model;
    if (model.isDetailInfo) {
        self.userLabel.text = [NSString stringWithFormat:@"金额:%@",model.num];
        self.nameLabel.text = [NSString stringWithFormat:@"操作前金额:%@",model.oldnum];
        self.phoneLabel.text = [NSString stringWithFormat:@"备注:%@",model.beizhu];
        self.numberLabel.text = [NSString stringWithFormat:@"操作后金额:%@",model.nownum];
        self.dateLabel.text = [NSString stringWithFormat:@"时间:%@",model.shijian];
        return;
    }
    self.userLabel.text = [NSString stringWithFormat:@"转让账号:%@",model.user];
    self.nameLabel.text = [NSString stringWithFormat:@"转让姓名:%@",model.name];
    self.phoneLabel.text = [NSString stringWithFormat:@"转让手机号:%@",model.phone];
    self.numberLabel.text = [NSString stringWithFormat:@"数量:%@",model.num];
    self.dateLabel.text = [NSString stringWithFormat:@"时间:%@",model.shijian];

}

@end
