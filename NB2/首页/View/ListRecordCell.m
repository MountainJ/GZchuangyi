//
//  ListRecordCell.m
//  NB2
//
//  Created by Jayzy on 2017/9/8.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ListRecordCell.h"

#define COLOR_LISTRECORD_CELL_BACK   [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]


@interface ListRecordCell ()

@property (nonatomic,strong) UILabel *orderLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *userLabel;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *typeLabel;



@end

@implementation ListRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.orderLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:COLOR_LISTRECORD_CELL_BACK textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(24)] addToView:self.contentView labelText:@""];
    
    self.userLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:COLOR_LISTRECORD_CELL_BACK textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(24)] addToView:self.contentView labelText:@""];
    self.moneyLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:COLOR_LISTRECORD_CELL_BACK textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self.contentView labelText:@""];
    self.dateLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:COLOR_LISTRECORD_CELL_BACK textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(24)] addToView:self.contentView labelText:@""];
    self.numberLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:COLOR_LISTRECORD_CELL_BACK textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26)] addToView:self.contentView labelText:@""];
    self.typeLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:COLOR_LISTRECORD_CELL_BACK textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self.contentView labelText:@""];


    [self frameConfig];
}

- (void)frameConfig
{
    WS(weakSelf)
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left);
        make.top.mas_equalTo(weakSelf.contentView.mas_top);
        make.right.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.height.mas_equalTo(LIST_CELL_HEIGHT);
    }];
    
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.orderLabel);
        make.top.mas_equalTo(weakSelf.orderLabel.mas_bottom);
        make.height.mas_equalTo(weakSelf.orderLabel.mas_height);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.orderLabel);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-KKFitScreen(10));
        make.height.mas_equalTo(weakSelf.orderLabel.mas_height);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.mas_equalTo(weakSelf.contentView.mas_top);
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(LIST_CELL_HEIGHT);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(weakSelf.dateLabel);
        make.top.mas_equalTo(weakSelf.dateLabel.mas_bottom);
        make.height.mas_equalTo(weakSelf.dateLabel.mas_height);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(weakSelf.dateLabel);
        make.bottom.mas_equalTo(weakSelf.moneyLabel.mas_bottom).with.offset(KKFitScreen(0));
        make.height.mas_equalTo(weakSelf.moneyLabel.mas_height);
    }];
    
}
- (void)setModel:(RecordListModel *)model
{
    _model = model;
    self.orderLabel.text = [NSString stringWithFormat:@"序号：%@",model.tid];
    self.userLabel.text = [NSString stringWithFormat:@"会员账号：%@",model.user];
       NSString * originMoney = [NSString stringWithFormat:@"认筹创益币：%@",model.jine];
    [self.moneyLabel setAttribute:originMoney ChangeStr:model.jine Color:COLOR_STATUS_NAV_BAR_BACK];
    
    self.dateLabel.text = [NSString stringWithFormat:@"时间：%@",model.shijian];
    NSString * origin  = [NSString stringWithFormat:@"认筹份数：%@",model.num];
    [self.numberLabel setAttribute:origin ChangeStr:model.num Color:[UIColor orangeColor]];
    NSString * originType = [NSString stringWithFormat:@"类型：%@",model.type];
    [self.typeLabel setAttribute:originType ChangeStr:model.type Color:COLOR_STATUS_NAV_BAR_BACK];
}

@end
