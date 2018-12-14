//
//  RecordListViewController.h
//  NB2
//
//  Created by zcc on 16/2/23.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DidChangeStateBlock)(void);

@interface RecordListViewController : UIViewController<TopViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) int sign;
@property(nonatomic,strong) NSString *strtitle;
@property(nonatomic,strong) NSDictionary *diction;

@property (nonatomic,copy) DidChangeStateBlock changeBlock;


@end
