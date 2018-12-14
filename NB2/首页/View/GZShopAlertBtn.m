//
//  GZShopAlertBtn.m
//  NB2
//
//  Created by Jayzy on 2018/11/25.
//  Copyright © 2018年 Kohn. All rights reserved.
//

#import "GZShopAlertBtn.h"

@implementation GZShopAlertBtn

- (instancetype)initWithTitle:(NSString *)title
{
    if (self == [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:KKFitScreen(26)];
        [self setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    }
    return self;
}

+ (instancetype)shopAlertBtnToView:(UIView *)superView normalTitle:(nonnull NSString *)title
{
    GZShopAlertBtn *alertbtn = [[GZShopAlertBtn alloc] initWithTitle:title];
    [superView addSubview:alertbtn];
    return alertbtn;
}





@end
