//
//  JMCell.m
//  NB2
//
//  Created by zcc on 16/3/3.
//  Copyright © 2016年 Kohn. All rights reserved.
//

#import "JMCell.h"

@implementation JMCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _borrowName=[[UILabel alloc] initWithFrame:CGRectMake(0,5,SCREEN_WIDTH*0.3,20)];
        _borrowName.font=[UIFont systemFontOfSize:14];
        _borrowName.textColor=[UIColor blackColor];
        _borrowName.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_borrowName];
        
        _borrowMoney=[[UILabel alloc] init];
        _borrowMoney.font=[UIFont systemFontOfSize:11];
        _borrowMoney.textColor=[UIColor grayColor];
        _borrowMoney.backgroundColor=[UIColor clearColor];
        _borrowMoney.text=@"融资金额 (元)   ";
        _borrowMoney.frame=CGRectMake(0,CGRectGetMaxY(_borrowName.frame), SCREEN_WIDTH*0.3, 15);
        [self.contentView addSubview:_borrowMoney];
        
        //  借款金额
        _borrowRateT=[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_borrowMoney.frame)+5,SCREEN_WIDTH*0.3,30)];
        _borrowRateT.font=[UIFont systemFontOfSize:15];
        _borrowRateT.textColor=[UIColor grayColor];
        _borrowRateT.backgroundColor=[UIColor clearColor];

        [self.contentView addSubview:_borrowRateT];
        
        //borrowTimesT,*imageState,*borrowMin,*imageProcess,*rateL,*borrowMin0,*borrowProgessT
        _borrowTimesT=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.51,5,SCREEN_WIDTH*0.3,20)];
        _borrowTimesT.font=[UIFont systemFontOfSize:13];
        _borrowTimesT.text=@"激活码编号：";
        _borrowTimesT.textColor=[UIColor colorWithWhite:0.1 alpha:1];
        _borrowTimesT.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_borrowTimesT];
        
        _imageState=[[UILabel alloc] init];
        _imageState.font=[UIFont systemFontOfSize:13];
        _imageState.textColor=[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
        _imageState.backgroundColor=[UIColor clearColor];
        _imageState.frame=CGRectMake(0,CGRectGetMaxY(_borrowName.frame), SCREEN_WIDTH*0.3, 15);
        [self.contentView addSubview:_imageState];
        
        //  借款金额
        _borrowMin=[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_borrowMoney.frame)+5,SCREEN_WIDTH*0.3,30)];
        _borrowMin.text=@"激活码：";
        _borrowMin.font=[UIFont systemFontOfSize:13];
        _borrowMin.textColor=[UIColor grayColor];
        _borrowMin.backgroundColor=[UIColor clearColor];
        
        [self.contentView addSubview:_borrowMin];
        
        //  借款金额
        _imageProcess=[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_borrowMoney.frame)+5,SCREEN_WIDTH*0.3,30)];
        _imageProcess.font=[UIFont systemFontOfSize:13];
        _imageProcess.textColor=[UIColor colorWithRed:4.0/255 green:145.0/255 blue:218.0/255 alpha:1];
        _imageProcess.backgroundColor=[UIColor clearColor];
       [self.contentView addSubview:_imageProcess];
        
        //底部画线
        UIView *lingFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 102 - 0.5, SCREEN_WIDTH, 5)];
        [lingFootView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:lingFootView];
        self.backgroundColor=[UIColor grayColor];
        
    }
    return self;
}


@end
