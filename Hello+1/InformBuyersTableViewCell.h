//
//  InformBuyersTableViewCell.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/6/2.
//  Copyright © 2017年 Appbear. All rights reserved.
//
 
#import <UIKit/UIKit.h>

@interface InformBuyersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *informTitle;
@property (weak, nonatomic) IBOutlet UIButton *paymentInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *shippingInfoBtn;
@end
