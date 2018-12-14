//
//  GoodsModel.m
//  NB2
//
//  Created by Jayzy on 2017/9/5.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

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

@implementation LocationModel

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

@implementation HistoryModel

- (instancetype)initWithDataDict:(NSDictionary *)dataDict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dataDict];
        self.itemID = [NSString stringWithFormat:@"%@",dataDict[@"id"]];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

@end

