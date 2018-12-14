//
//  RegistPickerView.h
//  JHGJProject
//
//  Created by kongbin on 2017/3/5.
//  Copyright © 2017年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistPickerView : UIPickerView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSString  *titleStr;

- (id)initWithItem:(NSArray *)itemList;

- (void)reloadItemList:(NSArray *)itemlist;

@end
