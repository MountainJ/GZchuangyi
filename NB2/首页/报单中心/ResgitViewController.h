//
//  ResgitViewController.h
//  NB2
//
//  Created by zcc on 16/2/19.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardViewController.h"
@interface ResgitViewController : UIViewController<TopViewDelegate,UIKeyboardViewControllerDelegate>
{
    UIKeyboardViewController *keyBoardController;
    
}
@property(nonatomic,strong) NSString *user;
@property(nonatomic,assign) int type;

@end
