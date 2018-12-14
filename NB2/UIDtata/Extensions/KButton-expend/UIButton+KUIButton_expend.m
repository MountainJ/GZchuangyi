//
//  UIButton+KUIButton_expend.m
//  SeeDoctor
//
//  Created by qihui huang on 13-6-4.
//
//

#import "UIButton+KUIButton_expend.h"

#define kDownLabelEstimatedH 30.0 //上图下文按钮下方文字高度

@implementation UIButton (KUIButton_expend)


#pragma mark -- 获取一个带圆角的按钮只能赋予带圆角的图片
+ (UIButton *)getButtonInitUseBtnFrame:(CGRect)btnFrame btnTitleColor:(UIColor *)btnTitleColor btnTitle:(NSString *)btnTitle btnImage:(NSString *)btnImageStr btnBackImage:(NSString *)btnBackImage btnTitleFont:(NSInteger)btnFont {
    UIButton * btn = [[UIButton alloc] initWithFrame:btnFrame];
    [btn setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    //[btn setImage:[UIImage imageNamed:btnImageStr] forState:UIControlStateNormal];
    if (btnBackImage && [btnBackImage length] >0) {
        
        [btn setBackgroundImage:[UIImage imageNamed:btnBackImage] forState:UIControlStateNormal];

    }
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:btnFont];
    
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 10, 18)];
    if (btnImageStr && [btnImageStr length] >0) {
        
        imageV.image = [UIImage imageNamed:btnImageStr];

    }
    [btn addSubview:imageV];
    return btn;
}

#pragma mark -- 获取一个透明的按钮可以赋予任何图片
+ (UIButton *)getUserCustomButtonInitUseBtnFrame:(CGRect)btnFrame btnTitleColor:(UIColor *)btnTitleColor btnTitle:(NSString *)btnTitle btnImage:(NSString *)btnImageStr btnBackImage:(NSString *)btnBackImage btnTitleFont:(NSInteger)btnFont {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = btnFrame;
    [btn setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    if ([btnImageStr length]>0 && btnImageStr) {
        [btn setImage:[UIImage imageNamed:btnImageStr] forState:UIControlStateNormal];

    }
    if (btnBackImage && [btnBackImage length]>0) {
        
        [btn setBackgroundImage:[UIImage imageNamed:btnBackImage] forState:UIControlStateNormal];

    }
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:btnFont];
    return btn;
}


/**
 *  创建一个Button
 */

+(UIButton *)buttonWithFrame:(CGRect)frame backGroundColor:(UIColor *)backGroundColor textColor:(UIColor *)textColor clickAction:(SEL)actionSel clickTarget:(id)aTarget addToView:(UIView *)targetView buttonText:(NSString *)btnText
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =frame;
    btn.backgroundColor = backGroundColor;
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitle:btnText forState:UIControlStateNormal];
    if (aTarget && actionSel) {
        [btn addTarget:aTarget action:actionSel forControlEvents:UIControlEventTouchUpInside];
    }
    if (targetView) {
        [targetView addSubview:btn];
    }
    return btn;
}


+(UIButton *)buttonWithFrame:(CGRect)frame backGroundColor:(UIColor *)backGroundColor cornerRadius:(CGFloat)radius textColor:(UIColor *)textColor clickAction:(SEL)actionSel clickTarget:(id)aTarget addToView:(UIView *)targetView buttonText:(NSString *)btnText
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =frame;
    btn.backgroundColor = backGroundColor;
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitle:btnText forState:UIControlStateNormal];
    btn.layer.cornerRadius = radius;
    btn.layer.masksToBounds = YES;
    if (aTarget && actionSel) {
        [btn addTarget:aTarget action:actionSel forControlEvents:UIControlEventTouchUpInside];
    }
    if (targetView) {
        [targetView addSubview:btn];
    }
    return btn;
}


+ (UIButton *)buttonWithImageFrame:(CGRect)frame headImg:(NSString *)imgName fontSize:(CGFloat)fontSize clickAction:(SEL)actionSel clickTarget:(id)aTarget addToView:(UIView *)targetView buttonText:(NSString *)btnText
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =frame;
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:btnText forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];

    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    if (aTarget && actionSel) {
        [btn addTarget:aTarget action:actionSel forControlEvents:UIControlEventTouchUpInside];
    }
    if (targetView) {
        [targetView addSubview:btn];
    }
    UIImage *headImg = [UIImage imageNamed:imgName];
    if (headImg) {
        //需要先调用btn,titlelabel的方法，才可以显示size
        btn.titleLabel.backgroundColor = btn.backgroundColor;
        btn.imageView.backgroundColor = btn.backgroundColor;
        [btn setImage:headImg forState:UIControlStateNormal];
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        CGSize imgSize = btn.imageView.bounds.size;
        CGSize textSize = btn.titleLabel.bounds.size;
        CGFloat middleMargin = 3;
        CGFloat margin =fabs((frame.size.height - imgSize.height - textSize.height - middleMargin) * 0.5 );
        [btn setImageEdgeInsets:UIEdgeInsetsMake(margin, (frame.size.width - imgSize.width)*0.5, 0, 0)];
        
        CGFloat textCenterX =  imgSize.width + textSize.width * 0.5;
        CGFloat moveLenght = textCenterX - frame.size.width * 0.5;
        if (textCenterX < frame.size.width * 0.5) {
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(imgSize.height + margin + middleMargin ,frame.size.width * 0.5 - textCenterX, 0, 0)];
        }else{
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(imgSize.height + margin + middleMargin ,- moveLenght, 0, 0)];
        }
    }
    return btn;

}

/**
 *  自动添加上图下文按钮到视图上,实现点击
 */
+ (void)creatButtonsUPPictureArray :(NSArray *)pictureArray downTextArray:(NSArray *)textArray textFont:(CGFloat)fontSize addToView :(UIView *)parentView  toTarget:(id)target buttonFirstTag:(NSInteger)firstTag actionClick:(SEL)aClickAciton
{
    NSAssert(parentView!=nil, @"Button should be added to a parentView");
    CGFloat horMargin = 10.0;//水平间距
    CGFloat btnWidth = (float)(parentView.bounds.size.width - horMargin*(pictureArray.count+1))/pictureArray.count;
    CGFloat btnHeight = parentView.bounds.size.height;
    CGFloat iconImgHeight = btnHeight - kDownLabelEstimatedH;
    for (int i=0; i<[pictureArray count]; i++)
    {
        //原始图片的大小
        UIImage *originImg = [UIImage imageNamed:pictureArray[i]];
        //对应尺寸生成新图片
        CGSize newImgSize = CGSizeMake(originImg.size.width*iconImgHeight/originImg.size.height, iconImgHeight);
        UIImage *newImg = [self scaleImage:[ UIImage imageNamed:pictureArray[i]] withSize:newImgSize];
        UIButton *iconButton =[UIButton buttonWithType:UIButtonTypeCustom];
        iconButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        iconButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        iconButton.frame = CGRectMake(horMargin+i*(btnWidth+horMargin), 0, btnWidth, btnHeight);
        [iconButton setImage:newImg forState:UIControlStateNormal];
        [iconButton setTitle:textArray[i] forState:UIControlStateNormal];
        [iconButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        iconButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [iconButton addTarget:target action:aClickAciton forControlEvents:UIControlEventTouchUpInside];
        iconButton.tag = firstTag+i;
        
        iconButton.imageEdgeInsets = UIEdgeInsetsMake(0, iconButton.currentImage.size.width/2, 0, -iconButton.currentImage.size.width/2);
        iconButton.titleEdgeInsets = UIEdgeInsetsMake(iconButton.currentImage.size.height+2, -[self labelWidthWithStr:iconButton.titleLabel.text font:iconButton.titleLabel.font Height:80]/2,-iconButton.currentImage.size.height+2, [self labelWidthWithStr:iconButton.titleLabel.text font:iconButton.titleLabel.font Height:80]/2 );
        [parentView addSubview:iconButton];
    }
}

+ (UIImage*)scaleImage:(UIImage *)image withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    UIImage *originImage =image;
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [originImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (CGFloat)labelWidthWithStr:(NSString *)commentStr font:(UIFont *)font Height :(CGFloat)height
{
    CGSize retSize;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    retSize = [commentStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    return retSize.width;
}


@end
