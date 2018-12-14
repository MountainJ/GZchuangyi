//
//  RecommendViewController.h
//  NB2
//
//  Created by zcc on 16/6/14.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubordincsXiaViewController;
@interface RecommendViewController : UIViewController<TopViewDelegate,UITableViewDelegate,UITableViewDataSource,PullDelegate>
@property(nonatomic,strong) NSMutableDictionary *diction;

@end
