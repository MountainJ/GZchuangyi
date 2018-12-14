//
//  GoodsModel.h
//  NB2
//
//  Created by Jayzy on 2017/9/5.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject


@property (nonatomic,copy) NSString *itemID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *shijian;
@property (nonatomic,copy) NSString *jinbijiage;
@property (nonatomic,copy) NSString *yinbijiage;
@property (nonatomic,copy) NSString *xiangou;
@property (nonatomic,copy) NSString *price;


@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *yinbikucun;
@property (nonatomic,copy) NSString *jinbikucun;

@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *numDescrip;
@property (nonatomic,copy) NSString *jine;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *station;
@property (nonatomic,copy) NSString *fushujiage;
@property (nonatomic,copy) NSString *licaijiage;
@property (nonatomic,copy) NSString *zhonggoujiage;
@property (nonatomic,copy) NSString *fushukucun;
@property (nonatomic,copy) NSString *licaikucun;
@property (nonatomic,copy) NSString *zhonggoukucun;
@property (nonatomic,copy) NSString *kucun;




- (instancetype)initWithDataDict:(NSDictionary *)dataDict;
@end



//用户地址信息管理
@interface LocationModel : NSObject
@property (nonatomic,copy) NSString *itemID;
@property (nonatomic,copy) NSString *user;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *dizhi;
@property (nonatomic,copy) NSString *type;
- (instancetype)initWithDataDict:(NSDictionary *)dataDict;

@end


//历史记录列表
@interface HistoryModel : NSObject
@property (nonatomic,copy) NSString *itemID;
@property (nonatomic,copy) NSString *user;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *shijian;
@property (nonatomic,copy) NSString *type;

- (instancetype)initWithDataDict:(NSDictionary *)dataDict;

@end

