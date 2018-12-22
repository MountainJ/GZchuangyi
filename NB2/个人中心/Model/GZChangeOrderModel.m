//
//  GZChangeOrderModel.m
//  NB2
//
//  Created by 张毅 on 2018/12/22.
//  Copyright © 2018年 MoutainJay. All rights reserved.
//

#import "GZChangeOrderModel.h"

@implementation GZChangeOrderModel

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
