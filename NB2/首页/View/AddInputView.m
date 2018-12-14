//
//  AddInputView.m
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "AddInputView.h"

@interface AddInputView ()

@property (nonatomic,copy) NSString *nameTitle;

@end

@implementation AddInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addChildView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
         self.nameTitle = title;
        
        if (frame.size.width == 0 || frame.size.height == 0) {
            [self addChildViewLayout];
            
        }else{
            [self addChildView];

        }
        //
        
    }
    return self;

}

- (void)addChildView
{
    self.titleLabel = [UILabel labelWithFrame:CGRectMake(0, 0, self.bounds.size.width * 0.3, self.bounds.size.height) backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self labelText:self.nameTitle];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    
    self.textInputField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 0, self.bounds.size.width - CGRectGetWidth(self.titleLabel.frame) - 10, self.bounds.size.height)];
    self.textInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textInputField.backgroundColor = COLOR_INPUTVIEW_BACK;
    self.textInputField.font = [UIFont systemFontOfSize:KKFitScreen(28)];
    [self.textInputField setValue:[UIFont systemFontOfSize:KKFitScreen(28)] forKeyPath:@"_placeholderLabel.font"];
    [self addSubview:self.textInputField];
    
    
}

- (void)setDisableInput:(BOOL)disableInput
{
    _disableInput = disableInput;
    self.textInputField.enabled = !disableInput;
}


- (void)addChildViewLayout
{
    self.titleLabel = [UILabel labelWithFrame:CGRectZero backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] textFont:[UIFont systemFontOfSize:KKFitScreen(28)] addToView:self labelText:self.nameTitle];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    
    self.textInputField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.textInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textInputField.backgroundColor = COLOR_INPUTVIEW_BACK;
    self.textInputField.font = [UIFont systemFontOfSize:KKFitScreen(28)];
    [self.textInputField setValue:[UIFont systemFontOfSize:KKFitScreen(28)] forKeyPath:@"_placeholderLabel.font"];
    [self addSubview:self.textInputField];
    
    [self frameConfig];
}

- (void)frameConfig
{
    WS(weakSelf)
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left);
        make.width.mas_equalTo(weakSelf.mas_width).multipliedBy(0.4);
        make.top.bottom.mas_equalTo(weakSelf);
    }];
    [self.textInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLabel.mas_right).offset(10);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.top.mas_equalTo(weakSelf);
    }];
    
}
@end
