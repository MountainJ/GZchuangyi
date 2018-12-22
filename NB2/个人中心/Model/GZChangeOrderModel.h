//
//  GZChangeOrderModel.h
//  NB2
//
//  Created by 张毅 on 2018/12/22.
//  Copyright © 2018年 MoutainJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GZChangeOrderModel : NSObject

@property (nonatomic,copy) NSString  *endtime;
@property (nonatomic,copy) NSString  *itemId;
@property (nonatomic,copy) NSString  *jine;
@property (nonatomic,copy) NSString  *orderid;
@property (nonatomic,copy) NSString  *shijian;
@property (nonatomic,copy) NSString  *station;

- (instancetype)initwithDict:(NSDictionary *)dict;

@end




NS_ASSUME_NONNULL_END
