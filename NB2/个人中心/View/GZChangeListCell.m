//
//  GZChangeListCell.m
//  NB2
//
//  Created by 张毅 on 2018/12/22.
//  Copyright © 2018年 MoutainJay. All rights reserved.
//

#import "GZChangeListCell.h"

@interface GZChangeListCell ()

@property (nonatomic,strong) UILabel  *userLabel;
@property (nonatomic,strong) UILabel  *phoneLabel;
@property (nonatomic,strong) UILabel  *nameLabel;
@property (nonatomic,strong) UILabel  *numberLabel;
@property (nonatomic,strong) UILabel  *dateLabel;

@property (nonatomic,strong) UIButton  *changeBtn;

@end

@implementation GZChangeListCell

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

- (UIButton *)changeBtn
{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithFrame:CGRectZero backGroundColor:COLOR_STATUS_NAV_BAR_BACK textColor:[UIColor whiteColor] clickAction:@selector(changeOrder) clickTarget:self addToView:self.contentView buttonText:@"转换"];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(28.)];
        _changeBtn.layer.cornerRadius = KKFitScreen(30.);
        _changeBtn.layer.masksToBounds = YES;
    }
    return _changeBtn;
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
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.6);
        make.height.mas_equalTo(KKFitScreen(80));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userLabel.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.bottom.equalTo(self.userLabel);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userLabel);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.7);
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
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10.);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(KKFitScreen(60.));
        make.width.mas_equalTo(KKFitScreen(140.));
    }];
    
    
    
}

- (void)setModel:(GZChangeOrderModel *)model
{
    _model = model;
    if (model.recordFlag) {//这里显示的历史记录页面
        [self.userLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KKFitScreen(80));
        }];
        self.userLabel.text = [NSString stringWithFormat:@"订单号:%@",model.orderid];
        self.nameLabel.text = [NSString stringWithFormat:@"提交金额:%@",model.jine];
        self.phoneLabel.text = [NSString stringWithFormat:@"转换时间:%@",model.shijian];
        self.numberLabel.text  = [NSString stringWithFormat:@"转换金额:%@",model.num];
        return;
    }
    //这里显示转换记录
    if (model.station.integerValue  == 1) {//已经转换
        [self.changeBtn setTitle:@"已转换" forState:UIControlStateNormal];
        [self.changeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.changeBtn setBackgroundColor:COLOR_LIGHTGRAY_BACK];
        self.changeBtn.enabled = NO;
    }else if (!model.station.integerValue)//未转换，可以转换
    {
        [self.changeBtn setTitle:@"转换" forState:UIControlStateNormal];
        [self.changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.changeBtn setBackgroundColor:COLOR_STATUS_NAV_BAR_BACK];
        self.changeBtn.enabled = YES;
    }
    self.userLabel.text = [NSString stringWithFormat:@"商品订单号:%@",model.orderid];
    self.nameLabel.text = [NSString stringWithFormat:@"金额:%@",model.jine];
    self.phoneLabel.text = [NSString stringWithFormat:@"商品下单时间:%@",model.shijian];
    self.dateLabel.text = [NSString stringWithFormat:@"确认收货时间:%@",model.endtime];
}

- (void)changeOrder
{
    if ([_delegate respondsToSelector:@selector(GZChangeListCell:changeModel:)]) {
        [_delegate GZChangeListCell:self changeModel:self.model];
    }
}

- (void)setActionBtnHidden:(BOOL)actionBtnHidden
{
    _actionBtnHidden = actionBtnHidden;
    self.changeBtn.hidden = actionBtnHidden;
}

@end
