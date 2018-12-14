//
//  ZhougchouListCell.m
//  NB2
//
//  Created by Jayzy on 2017/9/3.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ZhougchouListCell.h"

#import "UIImageView+WebCache.h"

@interface ZhougchouListCell  ()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *contentLabel;


@end

@implementation ZhougchouListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = COLOR_LIGHTGRAY_BACK;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
 
   
   
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.iconView.backgroundColor = [UIColor whiteColor];
    self.iconView.contentMode= UIViewContentModeScaleAspectFit;
    [self.backView addSubview:self.iconView];
 
    //
    self.nameLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor whiteColor] textColor:[UIColor darkTextColor] textFont:[UIFont boldSystemFontOfSize:KKFitScreen(34)] addToView:self.backView labelText:@""];
    self.contentLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor whiteColor] textColor:[UIColor lightGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self.backView labelText:@""];
    self.contentLabel.numberOfLines = 0;

    
    [self frameConfig];
}

- (void)frameConfig
{
    WS(weakSelf)
    CGFloat margin = KKFitScreen(30);
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(margin);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-margin);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(margin);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
    }];
    //900* 330
    CGFloat imgMargin = KKFitScreen(20);
    CGFloat imgHeight = (SCREEN_WIDTH - margin * 2 - imgMargin * 2) * (330.0/900.0);
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.backView.mas_left).with.offset(imgMargin);
        make.right.mas_equalTo(weakSelf.backView.mas_right).with.offset(-imgMargin);
        make.top.mas_equalTo(weakSelf.backView.mas_top).with.offset(imgMargin);
        make.height.mas_equalTo(imgHeight);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.iconView);
        make.top.mas_equalTo(weakSelf.iconView.mas_bottom);
        make.height.mas_equalTo(KKFitScreen(70));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameLabel);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.backView.mas_bottom).with.offset(-KKFitScreen(20));
    }];
}
- (void)setModel:(ZhongchouModel *)model
{
    if (!model) {
        return;
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:nil];
    //
    self.nameLabel.text = model.title;
    model.intro = [model.intro stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    self.contentLabel.text = model.intro;
    
}

@end
