//
//  CBAdvertisementView.m
//  TestAdMovie
//
//  Created by MBA on 16/1/23.
//  Copyright © 2016年 YiRuiHuLian. All rights reserved.
//

#import "CBAdvertisementView.h"
#import "MyPageControl.h"
#import <objc/runtime.h>
#import "UIImageView+WebCache.h"

//BANNER滚动时间间隔
#define TIME_SCROLL 3.0f

@interface CBAdvertisementView()<UIScrollViewDelegate>
{
    CGFloat imageWidth;//图片宽度
    CGFloat imageHeight;//图片高度
}
@property (nonatomic, strong)NSArray *imagesArray;

//网络图片地址数组
@property (nonatomic, strong) NSArray * urlArray;

@property (nonatomic, strong)UIPageControl *pageControl;

@property (nonatomic, strong) MyPageControl * myPageControl;

//为图片数量+2
@property (nonatomic, assign)NSInteger pageCount;

//包含收尾两张图片之后的下表
@property (nonatomic, assign)NSInteger currentPage;

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation CBAdvertisementView
-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        self.currentPage = 1;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if(!_pageControl){
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.bounds.size.width, 20)];
    }
    return _pageControl;
}

-(MyPageControl *)myPageControl{
    if(!_myPageControl){
        CGFloat pcWidth = 15 * (self.pageCount -2);
        _myPageControl=[[MyPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width * 0.5 - pcWidth * 0.5, self.bounds.size.height - 15 , pcWidth, 10)];
        _myPageControl.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        _myPageControl.currentPageIndicatorTintColor = COLOR_STATUS_NAV_BAR_BACK;
    }
    return _myPageControl;
}

- (void)setDotPosition:(PageControlPosition)dotPosition
{
    _dotPosition = dotPosition;
    CGFloat pcWidth = 15 * (self.pageCount -2);
    if (dotPosition == PageControlPositionCenter) {
        _myPageControl.frame =CGRectMake(self.bounds.size.width*0.5 -pcWidth*0.5 , self.bounds.size.height - 15 , pcWidth, 10);
    }else if (dotPosition == PageControlPositionLeft){
        _myPageControl.frame =CGRectMake(10 , self.bounds.size.height - 15 , pcWidth, 10);
    }
}

-(instancetype)initWithFrame:(CGRect)frame AndImagesArray:(NSArray *)imagesArray{
    if(self = [super initWithFrame:frame]){
        self.imagesArray = imagesArray;
        self.pageCount = imagesArray?(imagesArray.count+2):0;
        [self createUI];
//        [self createTimer];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame AndUrlArray:(NSArray *)imageUrlArray{
    if(self = [super initWithFrame:frame]){
        //如果传入空数组则直接返回
        if(!imageUrlArray.count || imageUrlArray.count == 0){
            return self;
        }
        self.urlArray = imageUrlArray;
        self.currentPage = 1;
        self.pageCount = imageUrlArray.count+2;
        
        [self createUIWithUrl];
        //如果只有一张图片则不滚动
        if(imageUrlArray.count > 1){
             [self createTimer];
        }else{
            [self.scrollView setScrollEnabled:NO];
        }
    }
    return self;
}

- (void)setDefaultImageShow:(BOOL)defaultImageShow
{
    _defaultImageShow = defaultImageShow;
    if (defaultImageShow) {
        self.pageCount = 1;
        [self createUIWithUrl];
    }
}

-(void)scrollToNextPage{
    if(self.currentPage == 1){
        [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width *self.currentPage, 0)];
          [self.scrollView scrollRectToVisible:CGRectMake(self.bounds.size.width*self.currentPage, 0, self.bounds.size.width, 20) animated:NO];
    }
    self.currentPage ++;
    if(self.currentPage == self.pageCount-1){
        self.myPageControl.currentPage = 0;
//        self.pageControl.currentPage = 0;
    }else{
        self.myPageControl.currentPage = self.currentPage - 1;
//        self.pageControl.currentPage = self.currentPage - 1;
    }
    [self.scrollView scrollRectToVisible:CGRectMake(self.bounds.size.width*self.currentPage, 0, self.bounds.size.width, 20) animated:YES];
    if(self.currentPage == self.pageCount - 1){
        self.currentPage = 1;
    }
}

#pragma mark - 加载网络图片
-(void)createUIWithUrl{
    imageWidth = self.frame.size.width;
    imageHeight = self.frame.size.height;
    for(int i=0; i<self.pageCount; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * imageWidth, 0, imageWidth, imageHeight)];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * imageWidth, 0, imageWidth, imageHeight)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        btn.tag = i;
        if(i == 0){
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[self.pageCount - 3]] placeholderImage:nil];
        }else if(i == self.pageCount-1){
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[0]] placeholderImage:nil];
        }else{
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[i-1]] placeholderImage:nil];
        }
        [self.scrollView addSubview:imgView];
        [self.scrollView addSubview:btn];
    }
    self.scrollView.contentSize = CGSizeMake(imageWidth *self.pageCount, imageHeight);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self scrollToPage:self.currentPage];
    
   
    //如果只有一张图片则不需要PageControl
    if(self.pageCount > 3){
         //MyPageControl
        [self addSubview:self.myPageControl];
        self.myPageControl.numberOfPages = self.pageCount-2;
        self.myPageControl.currentPage = 0;
        self.myPageControl.userInteractionEnabled = NO;

    }
}

#pragma mark - 定时器
-(void)createTimer{
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_SCROLL target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
}

-(void)stopTimer{
    if(_timer){
        if([_timer isValid]){
            [_timer invalidate];
            _timer = nil;
        }
    }
}

-(void)stop{
    [self stopTimer];
}

-(void)begin{
    //如果只有一张图片则不能滚动
    if(self.pageCount <=3){
        [self.scrollView setScrollEnabled:NO];
        return;
    }
    [self createTimer];
}

- (void)reloadPictures:(NSArray *)picArray
{
    if (!picArray.count) {
        return;
    }
    self.urlArray = picArray;
    self.currentPage = 1;
    self.pageCount = picArray.count+2;
    
    [self createUIWithUrl];
    //如果只有一张图片则不滚动
    if(picArray.count > 1){
        [self createTimer];
    }else{
        [self.scrollView setScrollEnabled:NO];
    }
}

- (void)setPageControlHide:(BOOL)pageControlHide
{
    _pageControlHide = pageControlHide;
    if (pageControlHide) {
        self.myPageControl.hidden = YES;
    }else{
        self.myPageControl.hidden = NO;
    }
}

#pragma mark - 加载本地图片
-(void)createUI{
    imageWidth = self.frame.size.width;
    imageHeight = self.frame.size.height;

    for(int i=0; i<self.pageCount; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * imageWidth, 0, imageWidth, imageHeight)];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * imageWidth, 0, imageWidth, imageHeight)];
        imgView.userInteractionEnabled = YES;
         btn.tag = i;
        
        if(i == 0){
            imgView.image = [UIImage imageNamed:self.imagesArray[self.pageCount-3]];
        }else if(i == self.pageCount-1){
            imgView.image = [UIImage imageNamed:self.imagesArray[0]];
        }else{
            imgView.image = [UIImage imageNamed:self.imagesArray[i-1]];
        }
        [self.scrollView addSubview:imgView];
        
    }
    self.scrollView.contentSize = CGSizeMake(imageWidth *self.pageCount, imageHeight);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self scrollToPage:self.currentPage];
    
    self.myPageControl.numberOfPages = self.pageCount-2;
    self.myPageControl.currentPage = 0;
    self.myPageControl.userInteractionEnabled = NO;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self createTimer];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offsetX = scrollView.contentOffset.x;
//    self.currentPage = offsetX / self.frame.size.width;
//    if(self.currentPage == 0){
//        self.myPageControl.currentPage = self.pageCount-2;
//        //        self.pageControl.currentPage = self.pageCount-2;
//        [self scrollToPage:self.pageCount-2];
//        self.currentPage = self.pageCount - 2;
//        
//    }else if(self.currentPage == self.pageCount-1){
//        self.myPageControl.currentPage = 0;
//        //        self.pageControl.currentPage = 0;
//        [self scrollToPage:1];
//        self.currentPage = 1;
//    }else{
//        self.myPageControl.currentPage= self.currentPage - 1;
//        //        self.pageControl.currentPage= self.currentPage - 1;
//    }
//}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    self.currentPage = offsetX / self.frame.size.width;
    if(self.currentPage == 0){
        self.myPageControl.currentPage = self.pageCount-2;
//        self.pageControl.currentPage = self.pageCount-2;
        [self scrollToPage:self.pageCount-2];
        self.currentPage = self.pageCount - 2;
        
    }else if(self.currentPage == self.pageCount-1){
        self.myPageControl.currentPage = 0;
//        self.pageControl.currentPage = 0;
        [self scrollToPage:1];
        self.currentPage = 1;
    }else{
        self.myPageControl.currentPage= self.currentPage - 1;
//        self.pageControl.currentPage= self.currentPage - 1;
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self stopTimer];
}

-(void)scrollToPage:(NSInteger)page{
    [self.scrollView scrollRectToVisible:CGRectMake(self.bounds.size.width*page, 0, self.bounds.size.width, 20) animated:NO];
}

#pragma mark - 点击事件
-(void)clickBtn:(UIButton *)btn{
    if (self.defaultImageShow) {
        return;
    }
    NSInteger index= btn.tag - 1;
    if(index == -1){
        index = self.pageCount - 1;
    }else if(index >= self.pageCount-2){
        index = 0;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(TapAtIndex:)]){
        [_delegate TapAtIndex:index];
    }
}

-(void)setPageControlType:(CBADV_Type)type{
    switch (type) {
        case CBADV_Type_System:
        {
            [self.myPageControl setHidden:YES];
            [self.pageControl setHidden:NO];
        }
            break;
        case CBADV_Type_Rect:
        {
            [self.myPageControl setHidden:NO];
            [self.pageControl setHidden:YES];

        }
            break;
        default:
            break;
    }
}

-(void)dealloc{
    [self stopTimer];
}





@end
