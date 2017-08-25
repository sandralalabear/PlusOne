//
//  DealsManagementTableViewCell.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/31.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"
#import "Deal.h"

@interface DealsManagementTableViewCell : UITableViewCell

@property (nonatomic,strong) LDProgressView *progressView;
//@property (weak, nonatomic) IBOutlet UIImageView *dealCoverPhoto;
@property (weak, nonatomic) IBOutlet AdvanceImageView *dealCoverPhoto;
@property (weak, nonatomic) IBOutlet UILabel *dealName;
@property (weak, nonatomic) IBOutlet UILabel *dealEndDate;

@property (weak, nonatomic) IBOutlet UILabel *totalQuantity;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

- (id)initWithData: (Deal *) deal joineds: (NSMutableArray *)joineds;

@end
