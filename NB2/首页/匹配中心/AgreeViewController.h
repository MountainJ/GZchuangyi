//
//  AgreeViewController.h
//  NB2
//
//  Created by zcc on 16/4/27.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardViewController.h"
@interface AgreeViewController : UIViewController<TopViewDelegate,UIKeyboardViewControllerDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIKeyboardViewController *keyBoardController;
}
@property(nonatomic,strong) NSString *tid;
@end
