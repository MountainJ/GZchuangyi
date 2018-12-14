//
//  ModifyLocationCell.h
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "LocationCell.h"
@class ModifyLocationCell;
@protocol ModifyLocationCellDelegate <NSObject>

- (void)ModifyLocationCell:(ModifyLocationCell *)cell clickAciton:(id)action;

@end


@interface ModifyLocationCell : LocationCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier buttonText:(NSString *)buttonText;

@property (nonatomic,weak)id<ModifyLocationCellDelegate>delegate;

- (void)updateUIWithModel:(LocationModel *)model;

@end
