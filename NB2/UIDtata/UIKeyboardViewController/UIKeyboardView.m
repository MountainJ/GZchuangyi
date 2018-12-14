

#import "UIKeyboardView.h"


@implementation UIKeyboardView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		keyboardToolbar = [[UIView alloc] initWithFrame:frame];
        keyboardToolbar.backgroundColor=[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
     
        UIButton *previousBarItem=[UIButton buttonWithType:UIButtonTypeCustom];
        previousBarItem.frame=CGRectMake(SCREEN_WIDTH/32.0, 8, SCREEN_WIDTH/6.4, 20);
        previousBarItem.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [previousBarItem setTitle:@"上一个" forState:UIControlStateNormal];
        [previousBarItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        previousBarItem.showsTouchWhenHighlighted=YES;
		previousBarItem.tag=1;
        [previousBarItem addTarget:self action:@selector(toolbarButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
        UIButton *nextBarItem=[UIButton buttonWithType:UIButtonTypeCustom];
        nextBarItem.frame=CGRectMake(SCREEN_WIDTH/4.57, 8, SCREEN_WIDTH/6.4, 20);
        nextBarItem.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [nextBarItem setTitle:@"下一个" forState:UIControlStateNormal];
        [nextBarItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        nextBarItem.showsTouchWhenHighlighted=YES;
		nextBarItem.tag=2;
        [nextBarItem addTarget:self action:@selector(toolbarButtonTap:) forControlEvents:UIControlEventTouchUpInside];
	
        UIButton *doneBarItem=[UIButton buttonWithType:UIButtonTypeCustom];
        doneBarItem.frame=CGRectMake(SCREEN_WIDTH/1.18, 8, SCREEN_WIDTH/8.0, 20);
        doneBarItem.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [doneBarItem setTitle:@"完成" forState:UIControlStateNormal];
        [doneBarItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        doneBarItem.showsTouchWhenHighlighted=YES;
		doneBarItem.tag=3;
        [doneBarItem addTarget:self action:@selector(toolbarButtonTap:) forControlEvents:UIControlEventTouchUpInside];
		[keyboardToolbar addSubview:previousBarItem];
        [keyboardToolbar addSubview:nextBarItem];
        [keyboardToolbar addSubview:doneBarItem];
        [self addSubview:keyboardToolbar];
    }
    return self;
}

- (void)toolbarButtonTap:(UIButton *)button {
	if ([self.delegate respondsToSelector:@selector(toolbarButtonTap:)]) {
		[self.delegate toolbarButtonTap:button];
	}
}

@end

@implementation UIKeyboardView (UIKeyboardViewAction)

//根据index找出对应的UIBarButtonItem
- (UIButton *)itemForIndex:(NSInteger)itemIndex {
	if (itemIndex < [[keyboardToolbar subviews] count]) {
		return [[keyboardToolbar subviews] objectAtIndex:itemIndex];
	}
	return nil;
}

@end
