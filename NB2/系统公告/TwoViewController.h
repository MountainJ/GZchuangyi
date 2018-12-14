//
//  TwoViewController.h
//  NB2
//
//  Created by zcc on 16/2/18.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQMultistageTableView.h"
@interface TwoViewController : UIViewController<TopViewDelegate,TQTableViewDataSource,TQTableViewDelegate,PullDelegate>
@property (nonatomic, strong) TQMultistageTableView *mTableView;
@end
