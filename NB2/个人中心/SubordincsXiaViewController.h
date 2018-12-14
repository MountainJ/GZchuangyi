//
//  SubordincsXiaViewController.h
//  NB2
//
//  Created by zcc on 16/3/21.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendViewController.h"
@interface SubordincsXiaViewController : UIViewController<TopViewDelegate,UITableViewDelegate,UITableViewDataSource,PullDelegate>
@property(nonatomic,strong) NSMutableDictionary *diction;

@end
