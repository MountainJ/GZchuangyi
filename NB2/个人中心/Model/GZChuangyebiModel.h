//
//  GZChuangyebiModel.h
//  NB2
//
//  Created by 张毅 on 2018/12/21.
//  Copyright © 2018年 MoutainJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GZChuangyebiModel : NSObject

//转让记录 - 接收记录
@property (nonatomic,copy) NSString  *phone;
@property (nonatomic,copy) NSString  *itemId;
@property (nonatomic,copy) NSString  *num;
@property (nonatomic,copy) NSString  *name;
@property (nonatomic,copy) NSString  *shijian;
@property (nonatomic,copy) NSString  *user;
//创业币明细
@property (nonatomic,copy) NSString  *nownum;//操作后金额
@property (nonatomic,copy) NSString  *beizhu;//备注
@property (nonatomic,copy) NSString  *oldnum;//操作前金额

@property (nonatomic,assign) BOOL  isDetailInfo;



- (instancetype)initwithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
