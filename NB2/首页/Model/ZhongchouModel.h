//
//  ZhongchouModel.h
//  NB2
//
//  Created by Jayzy on 2017/9/3.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhongchouModel : NSObject
@property (nonatomic,copy) NSString *itemID;
@property (nonatomic,copy) NSString *jinbi;
@property (nonatomic,copy) NSString *intro;
@property (nonatomic,copy) NSString *yitou;
@property (nonatomic,copy) NSString *shijian;
@property (nonatomic,copy) NSString *totel;
@property (nonatomic,copy) NSString *faqi;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *jinbimax;
@property (nonatomic,copy) NSString *zhichishu;
@property (nonatomic,copy) NSString *yinbi;
@property (nonatomic,copy) NSString *baifenbi;
@property (nonatomic,copy) NSString *xiangou;
@property (nonatomic,copy) NSString *yinbimax;
@property (nonatomic,copy) NSString *fangan;


@property (nonatomic,copy) NSString *homeBackImg;
@property (nonatomic,copy) NSString *titleImg;
@property (nonatomic,copy) NSString *leftImg;


- (instancetype)initWithDataDict:(NSDictionary *)dataDict;

@end

@interface RecordListModel : NSObject

@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *tid;
@property (nonatomic,copy) NSString *jine;
@property (nonatomic,copy) NSString *shijian;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *user;

- (instancetype)initWithDataDict:(NSDictionary *)dataDict;


@end


