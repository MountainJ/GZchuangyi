//
//  UIColor+Addition.h
//  AntGroupBuy
//
//  Created by yanqi on 14-7-14.
//  Copyright (c) 2014年 AntGroupBuy. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIColor (Addition)

+ (UIColor *)colorWithNHex:(NSString *)hexColor;

+ (UIColor *)viewBackColor;

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
@end
