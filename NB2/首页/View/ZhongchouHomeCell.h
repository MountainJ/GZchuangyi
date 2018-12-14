//
//  ZhongchouHomeCell.h
//  NB2
//
//  Created by Jayzy on 2017/9/3.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhongchouModel.h"

#define ZHONGCHOU_CELL_HEIGHT   KKFitScreen(460)

@interface ZhongchouHomeCell : UITableViewCell

@property (nonatomic,strong) ZhongchouModel *model;

@end
