//
//  ZhongchouDetailCell.h
//  NB2
//
//  Created by Jayzy on 2017/9/6.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WebKit/WebKit.h>

@interface ZhongchouDetailCell : UITableViewCell

@property (nonatomic,strong) WKWebView *detailWebView;

- (void)loadHtmlString:(NSString *)html;
@end
