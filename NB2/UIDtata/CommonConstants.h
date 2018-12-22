//
//  CommonConstants.h
//  NB2
//
//  Created by Jayzy on 2017/9/3.
//  Copyright © 2017年 Kohn. All rights reserved.
//




#ifndef CommonConstants_h
#define CommonConstants_h

#define RequestResponseCodeKey     @"error_code"
#define RequestResponseCodeValue   @"000000"

//状态栏，导航栏的背景颜色
#define COLOR_STATUS_NAV_BAR_BACK   [UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1]

//浅色背景
#define COLOR_LIGHTGRAY_BACK   [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1]

//输入框浅色背景
#define COLOR_INPUTVIEW_BACK   [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1]


#define PROGRESS_COLOR   [UIColor orangeColor]

#define COLOR_RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]



#define IOS11_OR_LATER_SPACE(par)\
({\
float space = 0.0;\
if (@available(iOS 11.0, *))\
space = par;\
(space);\
})
#define JF_KEY_WINDOW [UIApplication sharedApplication].keyWindow
#define JF_TOP_SPACE IOS11_OR_LATER_SPACE(JF_KEY_WINDOW.safeAreaInsets.top)
#define JF_TOP_ACTIVE_SPACE IOS11_OR_LATER_SPACE(MAX(0, JF_KEY_WINDOW.safeAreaInsets.top-20))
#define JF_BOTTOM_SPACE     IOS11_OR_LATER_SPACE(JF_KEY_WINDOW.safeAreaInsets.bottom)

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define HEIGHT_MENU_VIEW ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 45 : 65)

#define TAB_BAR_HEIGHT  (49. + JF_BOTTOM_SPACE)

#define APP_STATUS_BAR_HEIGHT  (20. + JF_TOP_ACTIVE_SPACE)

//导航栏高度
#define NAV_BAR_HEIGHT     44


//以750的屏幕为基准的宽高设置，字体也可以根据给出的标值设定
#define KKFitScreen(widthOrHeight)     (ceilf([UIScreen mainScreen].bounds.size.width / 375.0f  * ((widthOrHeight) / 2) * 2) / 2.0f)


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#define SAFE_STRING(str)\
({\
    NSString *resultStr = str;\
    if ([str isKindOfClass:[NSNull class]] || resultStr <= 0 || [resultStr isEqualToString:@"<null>"]) {\
        resultStr = @"";\
    }\
    (resultStr);\
})

//用户id
#define UID [[[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectAtIndex:0] objectForKey:@"id"]

//用户姓名
#define UNAME [[[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectAtIndex:0] objectForKey:@"name"]
//用户md5
#define MD5 [[[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectAtIndex:0] objectForKey:@"md5"]





#endif /* CommonConstants_h */
