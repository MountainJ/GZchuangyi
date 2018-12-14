//
//  MyPageControl.h
//  MyFaceBoard
//
//  Created by itensen003 on 13-10-31.
//  Copyright (c) 2013年 itensen003. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageControl : UIPageControl
{
    
    UIImage * activeImage;
    UIImage * inactiveImage;
    NSArray *_usedToRetainOriginalSubview;
    
}
@property (nonatomic,assign)CGFloat kSpacing;
@end
