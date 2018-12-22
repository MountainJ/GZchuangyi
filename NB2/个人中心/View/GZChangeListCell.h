//
//  GZChangeListCell.h
//  NB2
//
//  Created by 张毅 on 2018/12/22.
//  Copyright © 2018年 MoutainJay. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GZChangeOrderModel.h"

@class GZChangeListCell ;
@protocol GZChangeListCellDelegate <NSObject>

- (void)GZChangeListCell:(GZChangeListCell*)cell changeModel:(GZChangeOrderModel*)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GZChangeListCell : UITableViewCell

@property (nonatomic,strong) GZChangeOrderModel  *model;
@property (nonatomic,weak) id <GZChangeListCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
