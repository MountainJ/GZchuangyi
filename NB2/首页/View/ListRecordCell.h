//
//  ListRecordCell.h
//  NB2
//
//  Created by Jayzy on 2017/9/8.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhongchouModel.h"


#define LIST_CELL_HEIGHT KKFitScreen(50)


@interface ListRecordCell : UITableViewCell

@property (nonatomic,strong) RecordListModel *model;

@end
