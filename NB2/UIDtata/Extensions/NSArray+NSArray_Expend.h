//
//  NSArray+NSArray_Expend.h
//  KKOL
//
//  Created by Li En on 15-1-13.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (NSArray_Expend)

- (id)objectAtCheckIndex:(NSUInteger)index;

@end


@interface NSMutableArray (NSMutableArray_Expend)
- (void)addObjectForNil:(id)obj;
@end
