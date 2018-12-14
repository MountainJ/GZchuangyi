//
//  ModifyLocationCell.m
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ModifyLocationCell.h"

@interface ModifyLocationCell ()

@property (nonatomic,copy) NSString *buttonText;
@property (nonatomic,strong) UIButton *modifyButton;

@end

@implementation ModifyLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configModifyUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier buttonText:(NSString *)buttonText
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.buttonText = buttonText;
        [self configModifyUI];
    }
    return self;
}

- (void)configModifyUI
{

    WS(weakSelf)
    if ([self.buttonText length] > 0) {
        self.modifyButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:COLOR_STATUS_NAV_BAR_BACK cornerRadius:KKFitScreen(30) textColor:[UIColor whiteColor] clickAction:@selector(changeDefault:) clickTarget:self addToView:self.contentView buttonText:@"设为默认地址"];
        self.modifyButton.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(28)];
        [self.modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-KKFitScreen(30));
            make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(KKFitScreen(20));
            make.width.mas_equalTo(KKFitScreen(240));
            make.height.mas_equalTo(KKFitScreen(60));
        }];
    
    }else{
    
        self.modifyButton = [UIButton buttonWithFrame:CGRectZero backGroundColor:[UIColor orangeColor] cornerRadius:5.0 textColor:[UIColor whiteColor] clickAction:@selector(modifyLocation) clickTarget:self addToView:self.contentView buttonText:@"变更收货人信息"];
        self.modifyButton.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(28)];
        [self.modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-KKFitScreen(30));
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-KKFitScreen(30));
            make.width.mas_equalTo(KKFitScreen(280));
            make.height.mas_equalTo(KKFitScreen(60));
        }];
    }
  
    

    
}

- (void)modifyLocation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ModifyLocationCell:clickAciton:)]) {
        [self.delegate ModifyLocationCell:self clickAciton:nil];
    }

}

- (void)changeDefault:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ModifyLocationCell:clickAciton:)]) {
        [self.delegate ModifyLocationCell:self clickAciton:self.model];
    }
}

- (void)updateUIWithModel:(LocationModel *)model
{
    self.model = model;
    if ([self.buttonText length] > 0 && [model.type integerValue]) {
        self.modifyButton .hidden = YES;
    }else{
        self.modifyButton.hidden = NO;
    }
    self.nameLabel.text = [NSString stringWithFormat:@"收件人：%@",model.name?model.name:@"--"];
    self.phoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",model.phone?model.phone:@"--"];
    self.locationLabel.text = [NSString stringWithFormat:@"收货地址：%@",model.dizhi?model.dizhi:@"--"];
}

@end
