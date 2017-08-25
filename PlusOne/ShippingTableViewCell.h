//
//  ShippingTableViewCell.h
//  
//
//  Created by Sandra Wei on 2017/5/24.
//
//

#import <UIKit/UIKit.h>

@interface ShippingTableViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UILabel *shippingMethodTextField;
    @property (weak, nonatomic) IBOutlet UISwitch *shippingSwitch;

@end
