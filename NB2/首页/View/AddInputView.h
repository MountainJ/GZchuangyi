//
//  AddInputView.h
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddInputView : UIView

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *textInputField;
@property (nonatomic,assign) BOOL disableInput;

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title;

@end
