//
//  RegistPickerView.m
//  JHGJProject
//
//  Created by kongbin on 2017/3/5.
//  Copyright © 2017年 jian zhang. All rights reserved.
//

#import "RegistPickerView.h"
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )

@interface RegistPickerView ()

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation RegistPickerView

- (id)initWithItem:(NSArray *)itemList
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsSelectionIndicator = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        self.dataArr = itemList;
        self.titleStr = itemList[0];
    }
    return self;
}

- (void)reloadItemList:(NSArray *)itemlist
{
    self.dataArr = itemlist;
    self.titleStr = itemlist[0];
}

#pragma mark -
#pragma mark picker view data source and delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    __block NSInteger rows = 0;
    switch (component) {
        case 0:
        {
            rows = [self.dataArr count];
            break;
        }
        
        default:
            break;
    }
    
    //ios6崩溃兼容，崩溃信息：
    //*** Assertion failure in -[UITableViewRowData rectForRow:inSection:],
    // /SourceCache/UIKit/UIKit-2372/UITableViewRowData.m:1630
    // http://stackoverflow.com/questions/12672318/assertion-failure-on-picker-view
    if (IOS6_OR_LATER) {
        return rows <= 0 ? 1 : rows;
    }
    
    return rows;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return 130.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    __block NSString *titleName = nil;
    
    UILabel *retval = (UILabel *)view;
    
    if (!retval)
    {
        CGRect frame = CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height);
        
        retval = [[UILabel alloc] initWithFrame:frame];
        retval.adjustsFontSizeToFitWidth = YES;
        retval.backgroundColor = [UIColor clearColor];
        retval.textAlignment = NSTextAlignmentCenter;
        retval.font = [UIFont systemFontOfSize:20.0];
        
    }
    
    switch (component) {
        case 0:
        {
            if ([self.dataArr count] > row) {
                
                NSString *provinceStr = [self.dataArr objectAtIndex:row];
                titleName = provinceStr;
                
            }
            break;
        }
        default:
            break;
    }
    
    retval.text = titleName;
    return retval;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row < 0) {
        return;
    }
    
    switch (component)
    {
        case 0:
        {
            
            NSString *titleStr = [self.dataArr objectAtIndex:row];
            self.titleStr = titleStr;
            break;
        }
        default:
            break;
    }
}


@end
