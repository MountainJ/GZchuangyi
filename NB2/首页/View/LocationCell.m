//
//  LocationCell.m
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "LocationCell.h"

@interface LocationCell ()



@end

@implementation LocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.nameLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:self.contentView labelText:@""];
    self.phoneLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:self.contentView labelText:@""];
    self.locationLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:self.contentView labelText:@""];
    self.locationLabel.numberOfLines = 2;

    [self frameConfig];
}

- (void)frameConfig
{
    WS(weakSelf)
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(KKFitScreen(30));
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(0);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(KKFitScreen(10));
        make.height.mas_equalTo(LOCATION_CELL_HEIGHT);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameLabel);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom);
        make.height.mas_equalTo(weakSelf.nameLabel.mas_height);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameLabel);
        make.top.mas_equalTo(weakSelf.phoneLabel.mas_bottom);
        make.height.mas_equalTo(weakSelf.nameLabel.mas_height);
    }];
}

- (void)setModel:(LocationModel *)model
{
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"收件人：%@",model.name];
    self.phoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",model.phone];
    self.locationLabel.text = [NSString stringWithFormat:@"收货地址：%@",model.dizhi];
}


@end
