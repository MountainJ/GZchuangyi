//
//  ShopInfoCell.h
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@class ShopInfoCell;
@protocol ShopInfoCellDelegate <NSObject>

- (void)ShopInfoCell:(ShopInfoCell *)cell action:(id)action;

@end

@interface ShopInfoCell : UITableViewCell
@property (nonatomic,strong)  GoodsModel * model;

@property (nonatomic,weak)id<ShopInfoCellDelegate>delegate;
@end
