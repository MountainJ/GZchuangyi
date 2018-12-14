//
//  DetailsViewController.h
//  NB2
//
//  Created by zcc on 16/2/20.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController<TopViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign) int sign;

//标题
@property(nonatomic,strong) NSString *namestring;
@property(nonatomic,strong) NSMutableDictionary *diction;
@end
