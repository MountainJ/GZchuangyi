//
//  PaidanRecordViewController.h
//  NB2
//
//  Created by zcc on 2017/3/12.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ChuangyebiListType)
{
    ChuangyebiListTypeNone  = 0,
    ChuangyebiListTypeSend ,   //转让
    ChuangyebiListTypeReceive, //接受
    ChuangyebiListTypeDetail   //详细
};

@interface PaidanRecordViewController : UIViewController<TopViewDelegate,UITableViewDelegate,UITableViewDataSource,PullDelegate>

@property (nonatomic,assign) ChuangyebiListType  chuangyebiType;


@end
