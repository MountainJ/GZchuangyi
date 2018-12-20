//
//  GZChuangyebiModel.m
//  NB2
//
//  Created by 张毅 on 2018/12/21.
//  Copyright © 2018年 MoutainJay. All rights reserved.
//

#import "GZChuangyebiModel.h"

@implementation GZChuangyebiModel

- (instancetype)initwithDict:(NSDictionary *)dict
{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.itemId = [NSString stringWithFormat:@"%@",dict[@"id"]];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
