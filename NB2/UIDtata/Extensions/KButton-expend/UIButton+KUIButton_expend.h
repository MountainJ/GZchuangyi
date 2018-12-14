//
//  UIButton+KUIButton_expend.h
//  SeeDoctor
//
//  Created by qihui huang on 13-6-4.
//
//

#import <UIKit/UIKit.h>


@interface UIButton (KUIButton_expend)

//获取一个带圆角的按钮只能赋予带圆角的图片
+ (UIButton *)getButtonInitUseBtnFrame:(CGRect)btnFrame btnTitleColor:(UIColor *)btnTitleColor btnTitle:(NSString *)btnTitle btnImage:(NSString *)btnImageStr btnBackImage:(NSString *)btnBackImage btnTitleFont:(NSInteger)btnFont;

//获取一个透明的按钮可以赋予任何图片
+ (UIButton *)getUserCustomButtonInitUseBtnFrame:(CGRect)btnFrame btnTitleColor:(UIColor *)btnTitleColor btnTitle:(NSString *)btnTitle btnImage:(NSString *)btnImageStr btnBackImage:(NSString *)btnBackImage btnTitleFont:(NSInteger)btnFont;


/**
 *  创建一个Button
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
              backGroundColor:(UIColor *)backGroundColor
                    textColor:(UIColor *)textColor
                  clickAction:(SEL)actionSel
                  clickTarget:(id)aTarget
                    addToView:(UIView *)targetView
                   buttonText:(NSString *)btnText;
/**
 *  创建一个圆角Button
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
              backGroundColor:(UIColor *)backGroundColor
                 cornerRadius:(CGFloat)radius
                    textColor:(UIColor *)textColor
                  clickAction:(SEL)actionSel
                  clickTarget:(id)aTarget
                    addToView:(UIView *)targetView
                   buttonText:(NSString *)btnText;





/**
 *  创建一个上图下文Button，自定义字体
 */
+ (UIButton *)buttonWithImageFrame:(CGRect)frame
                      headImg:(NSString *)imgName
                     fontSize:(CGFloat)fontSize
                  clickAction:(SEL)actionSel
                  clickTarget:(id)aTarget
                    addToView:(UIView *)targetView
                   buttonText:(NSString *)btnText;

/**
 *  自动添加上图下文按钮到视图上,实现点击
 *
 *  @param pictureArray 存储图片的数组
 *  @param textArray    存储文字的数组
 *  @param fontSize     文字的字体
 *  @param parentView   添加到哪一个视图上
 *  @param buttonSize   按钮的尺寸
 *  @param iconSize     显示图标的尺寸
 *  @param target       添加对象
 *  @param firstTag     第一个按钮的tag
 */
+ (void)creatButtonsUPPictureArray :(NSArray *)pictureArray downTextArray:(NSArray *)textArray
                          textFont:(CGFloat)fontSize addToView :(UIView *)parentView
                          toTarget:(id)target buttonFirstTag:(NSInteger)firstTag actionClick:(SEL)aClickAciton;


@end
