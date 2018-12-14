//
//  ConvertValue.h
//  36cn
//
//  Created by shi on 13-12-12.
//  Copyright (c) 2013年 shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertValue : NSObject

+ (BOOL)isNULL:(NSString*)string;
+(NSString *)numWithSign:(NSString *)floatStr;
+(NSMutableAttributedString *)titleSign:(NSString *)descri;
+(NSMutableArray *)getNumFromString:(NSMutableArray *)wordsTemp :(NSString *)signString;
+(NSString *)getRandom;
+(BOOL) isValidateshuzi:(NSString *)mobile;
+(void)loginOut;
//+ (NSString *)macaddress;
+(NSString *)deviceIPAdress;
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
+ (BOOL) validatePassword:(NSString *)passWord;
+(int)getPageNum:(NSUInteger)arrayCount :(NSInteger)numPage;
+(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font;
+(CGFloat)getHightFrame:(id)sender;
+(void)clearKeyBoard;
+(CGSize)getFontSize:(UILabel *)tempLabel :(CGFloat)tempWith;

//--------------------------------------------------------------------
//  群广播
//+(void)sendSystemMessage:(NSString *)phoneNum :(NSString *)messageData;
//  群消息
+(void)sendGroupMessage:(NSString *)groupName :(NSString *)messageData;

+(NSMutableArray *)initInfo;

+(void)downLoadImg:(NSString *)url;

+(BOOL)hasDownLoad:(NSString *)imgName;

+ (void)scrollTableToNum:(BOOL)animated :(NSInteger)num :(UITableView *)tempTabele;

+(void)sendPhoneToServer;
@end
