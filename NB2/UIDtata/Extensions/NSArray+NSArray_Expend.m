//
//  NSArray+NSArray_Expend.m
//  KKOL
//
//  Created by Li En on 15-1-13.
//
//

#import "NSArray+NSArray_Expend.h"

@implementation NSArray (NSArray_Expend)

- (instancetype)objectAtCheckIndex:(NSUInteger)index
{
    if (index>=self.count) {
        return nil;
    }
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end

@implementation NSMutableArray (NSMutableArray_Expend)
- (void)addObjectForNil:(id)obj {
    if (obj) {
        [self addObject:obj];
    }
}
@end
