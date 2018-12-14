//
//  KKSelectionCollectionCell.m
//  NB2
//
//  Created by Jayzy on 2018/2/28.
//  Copyright © 2018年 Kohn. All rights reserved.
//

#import "KKSelectionCollectionCell.h"

@interface KKSelectionCollectionCell ()

@property (nonatomic,strong) UIImageView *circleView;
@property (nonatomic,strong) UILabel *contentLabel;

@end

@implementation KKSelectionCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addChildView];
    }
    return self;
}

- (void)addChildView
{
    //
    self.contentLabel  = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkTextColor] textFont:[UIFont systemFontOfSize:KKFitScreen(26.0)] addToView:self.contentView labelText:@""];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    WS(weakSelf)
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(weakSelf.contentView);
    make.width.mas_equalTo(weakSelf.contentView.mas_width).multipliedBy(0.7);
    }];
    
    self.circleView = [[UIImageView alloc] init];
    self.circleView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.circleView];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(5);
        make.right.mas_equalTo(weakSelf.contentLabel.mas_left);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.height.with.mas_equalTo(KKFitScreen(40));
    }];
    self.circleView.image = [UIImage imageNamed:@"normal"];

    
    [self frameConfig];
    
}

- (void)frameConfig
{
    
}


- (void)updateCellWithTitle:(NSString *)title
{
    self.contentLabel.text = title;
}

- (void)updateCellStateSeleted:(BOOL)selected
{
    if (selected) {
        self.circleView.image = [UIImage imageNamed:@"selected"];
    }else{
        self.circleView.image = [UIImage imageNamed:@"normal"];
    }

}

@end
