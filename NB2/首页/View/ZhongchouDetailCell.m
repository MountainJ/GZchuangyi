//
//  ZhongchouDetailCell.m
//  NB2
//
//  Created by Jayzy on 2017/9/6.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ZhongchouDetailCell.h"

@interface ZhongchouDetailCell ()<WKUIDelegate,WKNavigationDelegate>


@end

@implementation ZhongchouDetailCell
-(WKWebView *)detailWebView{
    if(!_detailWebView){
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        _detailWebView =  [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height) configuration:wkWebConfig];
        _detailWebView.UIDelegate = self;
        _detailWebView.navigationDelegate = self;
        //        _detailWebView.scrollView.delegate = self;
//        [_detailWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _detailWebView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    [self.contentView addSubview:self.detailWebView];
    [self frameConfig];
}

- (void)frameConfig
{
    
}

- (void)loadHtmlString:(NSString *)html
{
    if (!html) {
        return;
    }
    [self.detailWebView loadHTMLString:html baseURL:nil];
}

@end
