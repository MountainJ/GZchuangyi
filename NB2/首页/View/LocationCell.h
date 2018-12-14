//
//  LocationCell.h
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

#define LOCATION_CELL_HEIGHT    KKFitScreen(50)


@interface LocationCell : UITableViewCell

@property (nonatomic,strong) LocationModel *model;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UILabel *locationLabel;

@end
