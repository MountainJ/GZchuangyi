//
//  GiveMoneyViewController.h
//  NB2
//
//  Created by zcc on 16/8/13.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiveMoneyViewController : UIViewController<TopViewDelegate>
@property(nonatomic,strong) NSMutableDictionary *diction;
@property (strong, nonatomic) UIImageView *minImageView;
@end
