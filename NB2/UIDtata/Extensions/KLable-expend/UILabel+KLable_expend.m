//
//  UILabel+KLable_expend.m
//  SeeDoctor
//
//  Created by qihui huang on 13-6-13.
//
//

#import "UILabel+KLable_expend.h"

@implementation UILabel (KLable_expend)

+ (UILabel *)getLableInitFrame:(CGRect)lableFrame lableText:(NSString *)lableText lableFont:(NSInteger)lableFont lableColor:(UIColor *)LableColor lableBackColor:(UIColor *)lableBackColor {
    UILabel * titleLb = [[UILabel alloc] initWithFrame:lableFrame];
    if (lableText == nil) {
        lableText = @"";
    }
    titleLb.text = lableText;
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.font = [UIFont systemFontOfSize:lableFont];
    titleLb.textColor = LableColor;
    titleLb.backgroundColor = lableBackColor;
    return titleLb;
}

+ (UILabel *)getMyBlackLableInitFrame:(CGRect)lableFrame lableText:(NSString *)lableText lableFont:(CGFloat)lableFont lableColor:(UIColor *)LableColor lableBackColor:(UIColor *)lableBackColor {
    UILabel * titleLb = [self getLableInitFrame:lableFrame lableText:lableText lableFont:lableFont lableColor:LableColor lableBackColor:lableBackColor];
    titleLb.font = [UIFont boldSystemFontOfSize:lableFont];
    return titleLb;
}

#pragma mark -- 获取带下划线的label
+ (UILabel *)getAddAtributeLabeWithFrame:(CGRect)aFrame LabelText:(NSString *)labelText LabelFont:(NSInteger)labelFont LabelColor:(UIColor *)labelColor LabelBackColor:(UIColor *)backColor NumberOfLine:(NSInteger)numberOfLine {
    UILabel * titleLb = [self getLableInitFrame:aFrame lableText:labelText lableFont:labelFont lableColor:labelColor lableBackColor:backColor];
    titleLb.font = [UIFont systemFontOfSize:labelFont];
    titleLb.numberOfLines = numberOfLine;

    return titleLb;
}


/**
 *  创建一个Label
 */
+(UILabel *)labelWithFrame:(CGRect)frame  backGroundColor:(UIColor *)backGroundColor  textColor:(UIColor *)textColor textFont:(UIFont *)font addToView:(UIView *)targetView labelText:(NSString *)labelText
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = backGroundColor;
    if (textColor) {
        label.textColor = textColor;
    }
    label.font = font;
    label.text = labelText;
    [targetView addSubview:label];
    return label;
}

/**
 *  计算文本宽高
 */
+ (CGSize)labelChangeSize:(CGSize)originSize Attribute:(NSDictionary *)attributes labelText:(NSString *)text
{
    if (!text || ![text length]) {
        return CGSizeZero;
    }
 return   [text boundingRectWithSize:originSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}

+ (CGSize)labelChangeSizeLineSpace:(CGSize)originSize fontSize:(CGFloat)fontSize lineSpacing:(CGFloat)lineSpacing labelText:(NSString *)text
{
    if (!text || ![text length]) {
        return CGSizeZero;
    }
    NSMutableDictionary *attributeDict = [NSMutableDictionary dictionary];
    if (lineSpacing > 0) {
        NSMutableParagraphStyle *muParag = [[NSMutableParagraphStyle alloc] init];
        muParag.lineSpacing = lineSpacing;
        [attributeDict setObject:muParag forKey:NSParagraphStyleAttributeName];
    }
    [attributeDict setObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:attributeDict];
    return   [text boundingRectWithSize:originSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
}


- (void)setAttribute:(NSString *)mainStr ChangeStr:(NSString *)changeStr Color:(UIColor *)color
{
    if (mainStr == nil) {
        return;
    }
    NSArray * rangeArr = [self selectRange:mainStr ChangeStr:changeStr];
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc] initWithString:mainStr];
    for (NSString * rangeStr in rangeArr) {
        NSRange range = NSRangeFromString(rangeStr);
        [noteStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    [self setAttributedText:noteStr];
}

- (NSArray *)selectRange:(NSString *)mainStr ChangeStr:(NSString *)changeStr
{
    if (!changeStr) {
        return nil;
    }
    NSMutableArray * rangeArr = [[NSMutableArray alloc] init];
    for (NSInteger num = 0; ; num ++) {
        NSRange range = [mainStr rangeOfString:changeStr];
        if (range.location != NSNotFound) {
            mainStr = [mainStr substringFromIndex:range.location + range.length];
            NSString * lastStr = [rangeArr lastObject];
            if (lastStr != nil) {
                NSRange lastRange = NSRangeFromString(lastStr);
                range.location = range.location + lastRange.location + lastRange.length;
            }
            [rangeArr addObject:NSStringFromRange(range)];
        }else
        {
            break;
        }
    }
    
    return rangeArr;
}

- (void)setAttribute:(NSString *)mainStr ChangeStr:(NSString *)changeStr Color:(UIColor *)color Font:(UIFont *)font
{
    if (!mainStr) {
        return;
    }
    NSArray * rangeArr = [self selectRange:mainStr ChangeStr:changeStr];
    
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc] initWithString:mainStr];
    for (NSString * rangeStr in rangeArr) {
        NSRange range = NSRangeFromString(rangeStr);
        if (color) {
            [noteStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        [noteStr addAttribute:NSFontAttributeName value:font range:range];
    }
    [self setAttributedText:noteStr];
    
}

- (void)setAttribute:(NSString *)mainStr ChangeStr:(NSString *)changeStr Color:(UIColor *)color Font:(UIFont *)font textAlignment:(NSTextAlignment)align
{
    if (!mainStr) {
        return;
    }
    NSArray * rangeArr = [self selectRange:mainStr ChangeStr:changeStr];
    
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc] initWithString:mainStr];
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    parag.alignment = align;
    parag.lineSpacing = 5.0;
    [noteStr addAttribute:NSParagraphStyleAttributeName value:parag range:NSMakeRange(0, noteStr.length)];
    for (NSString * rangeStr in rangeArr) {
        NSRange range = NSRangeFromString(rangeStr);
        if (color) {
            [noteStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        [noteStr addAttribute:NSFontAttributeName value:font range:range];
    }
    [self setAttributedText:noteStr];
}

- (void)setMultiAttribute:(NSString *)mainStr ChangeStr:(NSArray *)changeStrArray Color:(NSArray *)colorArray
{
    if (mainStr == nil) {
        return;
    }
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc] initWithString:mainStr];
    for (NSInteger i =0 ;i < changeStrArray.count ; i++) {
        NSString *changeStr = changeStrArray[i];
        NSArray * rangeArr = [self selectRange:mainStr ChangeStr:changeStr];
        UIColor *color = colorArray[i];
        for (NSString * rangeStr in rangeArr) {
            NSRange range = NSRangeFromString(rangeStr);
            [noteStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }
    [self setAttributedText:noteStr];
    
}

- (void)setLineSpaceAttribute:(NSString *)mainStr lineSpacing:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize textColor:(UIColor *)color
{
    if (mainStr == nil) {
        return;
    }
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc] initWithString:mainStr];
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    parag.lineSpacing = lineSpacing;
    [noteStr addAttribute:NSParagraphStyleAttributeName value:parag range:NSMakeRange(0, noteStr.length)];
    if (fontSize > 0) {
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, noteStr.length)];
    }
    if (color) {
        [noteStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, noteStr.length)];
    }
    [self setAttributedText:noteStr];
}

- (void)setLineSpaceAttribute:(NSString *)mainStr lineSpacing:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize textColor:(UIColor *)color textAlignment:(NSTextAlignment)align
{
    if (mainStr == nil) {
        return;
    }
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc] initWithString:mainStr];
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    parag.lineSpacing = lineSpacing;
    parag.alignment = align;
    [noteStr addAttribute:NSParagraphStyleAttributeName value:parag range:NSMakeRange(0, noteStr.length)];
    if (fontSize > 0) {
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, noteStr.length)];
    }
    if (color) {
        [noteStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, noteStr.length)];
    }
    [self setAttributedText:noteStr];
}




@end
