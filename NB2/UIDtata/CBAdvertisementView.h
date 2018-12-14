//
//  CBAdvertisementView.h
//  TestAdMovie
//
//  Created by MBA on 16/1/23.
//  Copyright © 2016年 YiRuiHuLian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CBADV_Type)
{
    CBADV_Type_System = 1,//系统默认圆形PageControl
    CBADV_Type_Rect = 2,//方形PageControl
};

typedef NS_ENUM(NSInteger, AdvertisementViewType)
{
    //首页
    AdvertisementViewTypeHomePage = 1,
};

typedef  NS_ENUM(NSInteger,PageControlPosition){

    PageControlPositionRight  = 0,
    PageControlPositionCenter = 1,
    PageControlPositionLeft   = 2

};


typedef void (^TapImageBlock)(NSInteger index);

@protocol CBAdvertisementViewDelegate <NSObject>
-(void)TapAtIndex:(NSInteger)index;
@end

@interface CBAdvertisementView : UIView
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic,copy) TapImageBlock tapMyImageBlock;
@property (nonatomic, weak) id<CBAdvertisementViewDelegate> delegate;

@property (nonatomic, assign) AdvertisementViewType  adType;
@property (nonatomic, assign) PageControlPosition  dotPosition;

@property (nonatomic, assign) BOOL  pageControlHide;
@property (nonatomic, assign) BOOL  defaultImageShow;


-(instancetype)initWithFrame:(CGRect)frame AndImagesArray:(NSArray *)imagesArray;
-(instancetype)initWithFrame:(CGRect)frame AndUrlArray:(NSArray *)imageUrlArray;

//开始滚动
-(void)begin;

//停止滚动
-(void)stop;

//设置PageControl类型
-(void)setPageControlType:(CBADV_Type)type;

- (void)reloadPictures:(NSArray *)picArray;

@end
