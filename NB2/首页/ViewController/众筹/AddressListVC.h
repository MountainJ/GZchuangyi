//
//  AddressListVC.h
//  NB2
//
//  Created by Jayzy on 2017/9/9.
//  Copyright © 2017年 Kohn. All rights reserved.
//

#import "ChuangyiBaseViewController.h"

typedef void(^DidSelectAddress)(id object);

@interface AddressListVC : ChuangyiBaseViewController

@property (nonatomic,copy) DidSelectAddress selectBlock;

- (void)didChooseAddressBlock:(DidSelectAddress)block;

@end
