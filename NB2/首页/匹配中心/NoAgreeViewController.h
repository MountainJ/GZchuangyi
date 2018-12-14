//
//  NoAgreeViewController.h
//  NB2
//
//  Created by zcc on 16/4/27.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
@interface NoAgreeViewController : UIViewController<TopViewDelegate,RadioButtonDelegate>
@property(nonatomic,strong) NSString *tid;
@end
