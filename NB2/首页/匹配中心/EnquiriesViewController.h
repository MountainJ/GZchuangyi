//
//  EnquiriesViewController.h
//  NB2
//
//  Created by zcc on 16/2/24.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnquiriesViewController : UIViewController<TopViewDelegate,UITextFieldDelegate>
@property(nonatomic,assign) int sign;
@property(nonatomic,strong) NSDictionary *diction;
@end
