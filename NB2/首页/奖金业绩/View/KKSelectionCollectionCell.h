//
//  KKSelectionCollectionCell.h
//  NB2
//
//  Created by Jayzy on 2018/2/28.
//  Copyright © 2018年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKSelectionCollectionCell : UICollectionViewCell

- (void)updateCellWithTitle:(NSString *)title;

-(void)updateCellStateSeleted:(BOOL)selected;

@end
