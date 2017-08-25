//
//  DealsManagementDetailTableViewController.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/6/2.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"


@interface DealsManagementDetailTableViewController : UITableViewController
@property (nonatomic,strong) Deal *deal;
@property (nonatomic,strong) NSMutableArray *selectUserDetail;
@property (nonatomic,strong) NSString *keyString;


@end
