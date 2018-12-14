//
//  ShopHistoryCell.m
//  NB2
//
//  Created by Jayzy on 2017/9/10.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ShopHistoryCell.h"

@interface ShopHistoryCell ()

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *stateLabel;

@end

@implementation ShopHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.nameLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont boldSystemFontOfSize:KKFitScreen(30)] addToView:self.contentView labelText:nil];
    self.numLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self.contentView labelText:nil];
    self.priceLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self.contentView labelText:nil];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    self.typeLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self.contentView labelText:nil];
    self.stateLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self.contentView labelText:nil];
    self.stateLabel.textAlignment = NSTextAlignmentRight;

    
    
    
    [self frameConfig];
}

- (void)frameConfig
{
    WS(weakSelf)
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(KKFitScreen(30));
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(KKFitScreen(20));
        make.height.mas_equalTo(KKFitScreen(60));
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.right.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom);
        make.height.mas_equalTo(weakSelf.nameLabel.mas_height);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.right.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.mas_equalTo(weakSelf.numLabel.mas_bottom);
        make.height.mas_equalTo(weakSelf.nameLabel.mas_height);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.numLabel.mas_right);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-KKFitScreen(30));
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom);
        make.height.mas_equalTo(weakSelf.nameLabel.mas_height);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.priceLabel);
        make.top.bottom.mas_equalTo(weakSelf.typeLabel);
    }];
    
    
}

- (void)setModel:(GoodsModel *)model
{
    _model = model;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.title];
    self.numLabel.text = [NSString stringWithFormat:@"%@%@",model.numDescrip,model.num];
    self.typeLabel.text = [NSString stringWithFormat:@"支付类型：%@",model.type];
    self.priceLabel.text = [NSString stringWithFormat:@"总价：%@",model.jine];
    self.stateLabel.text = [NSString stringWithFormat:@"状态：%@",model.station];

}

@end
