//
//  ZhougchouListCell.h
//  NB2
//
//  Created by Jayzy on 2017/9/3.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhongchouModel.h"


#define ZHONGCHOU_LIST_CELL_HEIGHT   KKFitScreen(560)

@interface ZhougchouListCell : UITableViewCell

@property (nonatomic,strong) ZhongchouModel *model;

@end
