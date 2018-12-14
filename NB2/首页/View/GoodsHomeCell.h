//
//  GoodsHomeCell.h
//  NB2
//
//  Created by Jayzy on 2017/9/5.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@class GoodsHomeCell;
@protocol GoodsHomeCellDelegate <NSObject>

- (void)GoodsHomeCell:(GoodsHomeCell *)cell model:(GoodsModel *)model;

@end

#define GOODS_HOME_HEIGHT   KKFitScreen(240)

@interface GoodsHomeCell : UITableViewCell

@property (nonatomic,strong) GoodsModel *model;
@property (nonatomic,weak)id<GoodsHomeCellDelegate>delegate;
@end
