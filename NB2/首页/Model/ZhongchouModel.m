//
//  ZhongchouModel.m
//  NB2
//
//  Created by Jayzy on 2017/9/3.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ZhongchouModel.h"

@implementation ZhongchouModel

- (instancetype)initWithDataDict:(NSDictionary *)dataDict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dataDict];
        self.itemID = [NSString stringWithFormat:@"%@",dataDict[@"id"]];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

@end


@implementation RecordListModel

- (instancetype)initWithDataDict:(NSDictionary *)dataDict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dataDict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

