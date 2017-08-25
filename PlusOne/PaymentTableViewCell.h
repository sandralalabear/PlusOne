//
//  PaymentTableViewCell.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/24.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTableViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UILabel *paymentMethodTextField;
    @property (weak, nonatomic) IBOutlet UISwitch *paymentSwitch;

@end
