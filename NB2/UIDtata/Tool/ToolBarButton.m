//
//  ToolBarButton.m
//  SuningEBuy
//
//  Created by wangrui on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ToolBarButton.h"
#import "UIColor+Helper.h"
#import "UIColor+Addition.h"
#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

@implementation ToolBarButton
@synthesize inputView = _inputView;
@synthesize inputAccessoryView = _inputAccessoryView;
@synthesize aboveViewToolBar = _aboveViewToolBar;
@synthesize delegate = _delegate;

@synthesize nomalBgColor = _nomalBgColor;
@synthesize activeBgColor = _activeBgColor;

- (void)dealloc
{

    
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.inputAccessoryView = self.aboveViewToolBar;
        
        [self addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.inputAccessoryView = self.aboveViewToolBar;
        
        [self addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

+ (id)buttonWithType:(UIButtonType)buttonType
{
    id newInstance = [self buttonWithType:buttonType];
    
    [newInstance setInputAccessoryView:[newInstance aboveViewToolBar]];
    
    [newInstance addTarget:newInstance action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return newInstance;
}

- (UIToolbar *)aboveViewToolBar
{
    if (!_aboveViewToolBar)
    {
        _aboveViewToolBar = [[UIToolbar alloc] init];
        if (IOS7_OR_LATER) {
            _aboveViewToolBar.barStyle = UIBarStyleDefault;
        }else{
            _aboveViewToolBar.barStyle = UIBarStyleBlackTranslucent;
        }
        _aboveViewToolBar.translucent = YES;
        
        [_aboveViewToolBar sizeToFit];
        
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
        
        
        
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                          style:UIBarButtonItemStyleBordered target:self
                                                                         action:@selector(cancelClicked:)];
        
        cancelButton.tintColor = [UIColor colorWithRGBHex:0xf29400];
        
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确认"
                                                                        style:UIBarButtonItemStyleBordered target:self
                                                                       action:@selector(doneClicked:)];
        
        doneButton.tintColor = [UIColor colorWithRGBHex:0xf29400];
        
        [_aboveViewToolBar setItems:[NSArray arrayWithObjects:cancelButton,flexItem,doneButton, nil]];
    }
    
    return _aboveViewToolBar;
}

- (void)cancelClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cancelButtonClicked:)]) 
    {
        [_delegate cancelButtonClicked:sender];
    }
    
    [self resignFirstResponder];
}

- (void)doneClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(doneButtonClicked:superClass:)])
    {
        [_delegate doneButtonClicked:sender superClass:self];
    }
    
    [self resignFirstResponder];
}

- (void)buttonTapped:(id)sender
{
    
    if ([_delegate respondsToSelector:@selector(singleClickButton:)]) 
    {
        [_delegate singleClickButton:sender];
    }
    else
    {
        [self becomeFirstResponder];
    }
}

- (void)setNomalBgColor:(UIColor *)nomalBgColor
{
    if (nomalBgColor != _nomalBgColor) {
        _nomalBgColor = nomalBgColor;
        self.backgroundColor = _nomalBgColor;
    }
}

- (BOOL)canBecomeFirstResponder
{
    if (_activeBgColor) {
        self.backgroundColor = _activeBgColor;
    }
    return YES;
}

- (BOOL)canResignFirstResponder
{
    if (_nomalBgColor) {
        self.backgroundColor = _nomalBgColor;
    }
    return YES;
}

@end
