//
//  BuyersTableViewCell.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/6/3.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvanceImageView.h"

@interface BuyersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AdvanceImageView *buyerCoverPhoto;
@property (weak, nonatomic) IBOutlet UILabel *buyerName;
@property (weak, nonatomic) IBOutlet UILabel *quantity;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UILabel *joinedDate;

@end
