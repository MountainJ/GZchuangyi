//
//  UILabel+KLable_expend.h
//  SeeDoctor
//
//  Created by qihui huang on 13-6-13.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (KLable_expend)

//获取普通字体的Lable
+ (UILabel *)getLableInitFrame:(CGRect)lableFrame lableText:(NSString *)lableText lableFont:(NSInteger)lableFont lableColor:(UIColor *)LableColor lableBackColor:(UIColor *)lableBackColor;

//获取加粗字体的babel
+ (UILabel *)getMyBlackLableInitFrame:(CGRect)lableFrame lableText:(NSString *)lableText lableFont:(CGFloat)lableFont lableColor:(UIColor *)LableColor lableBackColor:(UIColor *)lableBackColor;

//获取带下划线的label
+ (UILabel *)getAddAtributeLabeWithFrame:(CGRect)aFrame LabelText:(NSString *)labelText LabelFont:(NSInteger)labelFont LabelColor:(UIColor *)labelColor LabelBackColor:(UIColor *)backColor NumberOfLine:(NSInteger)numberOfLine ;


/**
 *  创建一个Label
 */
+(UILabel *)labelWithFrame:(CGRect)frame
           backGroundColor:(UIColor *)backGroundColor
                 textColor:(UIColor *)textColor
                  textFont:(UIFont *)font
                 addToView:(UIView *)targetView
                 labelText:(NSString *)labelText;

/**
 *  计算文本宽高
 *
 *  @param originSize 设定的宽或者高
 *  @param attributes 属性
 *  @param text       文本内容
 *
 *  @return 新的尺寸
 */
+ (CGSize)labelChangeSize:(CGSize)originSize Attribute:(NSDictionary *)attributes labelText:(NSString *)text;


/**
 根据字体，行间距 计算文本宽高

 @param originSize
 @param fontSize
 @param lineSpacing
 @param text
 @return 
 */
+ (CGSize)labelChangeSizeLineSpace:(CGSize)originSize fontSize:(CGFloat)fontSize lineSpacing:(CGFloat)lineSpacing labelText:(NSString *)text;


/**
 *  把一段文字里的所有的某段文字变色
 *
 *  @param mainStr   整段文字
 *  @param changeStr 需要变色的文字
 *  @param color     需要变的颜色
 */
- (void)setAttribute:(NSString *)mainStr ChangeStr:(NSString *)changeStr Color:(UIColor *)color;

- (void)setAttribute:(NSString *)mainStr ChangeStr:(NSString *)changeStr Color:(UIColor *)color Font:(UIFont *)font;

- (void)setAttribute:(NSString *)mainStr ChangeStr:(NSString *)changeStr Color:(UIColor *)color Font:(UIFont *)font textAlignment:(NSTextAlignment)align;


- (void)setMultiAttribute:(NSString *)mainStr ChangeStr:(NSArray *)changeStrArray Color:(NSArray *)colorArray;


- (void)setLineSpaceAttribute:(NSString *)mainStr lineSpacing:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize textColor:(UIColor *)color;

- (void)setLineSpaceAttribute:(NSString *)mainStr lineSpacing:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize textColor:(UIColor *)color textAlignment:(NSTextAlignment)align;




@end
