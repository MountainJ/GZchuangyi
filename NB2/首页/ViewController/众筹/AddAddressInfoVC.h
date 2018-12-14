//
//  AddAddressInfoVC.h
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ChuangyiBaseViewController.h"

typedef void(^DidSuccessSaveAddress)();

@interface AddAddressInfoVC : ChuangyiBaseViewController

@property (nonatomic,copy) DidSuccessSaveAddress saveSuccessBlock;

- (void)didSaveAddress:(DidSuccessSaveAddress)saveBlock;

@end
