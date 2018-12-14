//
//  ChuangyiHistoryCell.m
//  NB2
//
//  Created by Jayzy on 2017/9/10.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ChuangyiHistoryCell.h"

@interface ChuangyiHistoryCell ()

//@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UILabel *userLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *shijianLabel;


@end

@implementation ChuangyiHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.numLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont boldSystemFontOfSize:KKFitScreen(28)] addToView:self.contentView labelText:nil];
//    self.numLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self.contentView labelText:nil];
    self.userLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self.contentView labelText:nil];
    self.typeLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self.contentView labelText:nil];
    self.typeLabel.textAlignment = NSTextAlignmentRight;

    self.shijianLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(24)] addToView:self.contentView labelText:nil];
    self.shijianLabel.textAlignment = NSTextAlignmentRight;
    
    
    
    
    [self frameConfig];
}

- (void)frameConfig
{
    WS(weakSelf)
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(KKFitScreen(30));
        make.right.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(KKFitScreen(20));
        make.height.mas_equalTo(KKFitScreen(60));
    }];
    
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.numLabel.mas_left);
        make.right.mas_equalTo(weakSelf.numLabel.mas_right);
        make.top.mas_equalTo(weakSelf.numLabel.mas_bottom);
        make.height.mas_equalTo(weakSelf.numLabel.mas_height);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.numLabel.mas_right);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-KKFitScreen(30));
        make.top.mas_equalTo(weakSelf.numLabel.mas_top);
        make.bottom.mas_equalTo(weakSelf.numLabel.mas_bottom);
    }];
    
    [self.shijianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.typeLabel);
        make.left.mas_equalTo(weakSelf.contentView.mas_centerX).offset(- KKFitScreen(100));
        make.top.bottom.mas_equalTo(weakSelf.userLabel);
    }];
}

- (void)setModel:(HistoryModel *)model
{
    _model = model;
    NSString *origin = [NSString stringWithFormat:@"兑换数量：%@个",model.num];
    [self.numLabel setAttribute:origin ChangeStr:model.num Color:[UIColor orangeColor] Font:[UIFont boldSystemFontOfSize:KKFitScreen(36)]];
    self.userLabel.text = [NSString stringWithFormat:@"会员账号：%@",model.user];
    if ([model.type length]) {
        self.typeLabel.text = [NSString stringWithFormat:@"类型：%@",model.type];
    }
    self.shijianLabel.text = [NSString stringWithFormat:@"兑换时间：%@",model.shijian];
}


@end
