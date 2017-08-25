//
//  TableViewCell.h
//  buyer
//
//  Created by H.M.L on 2017/4/30.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvanceImageView.h"

@interface TableViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *productImages;
@property (weak, nonatomic) IBOutlet AdvanceImageView *productImages;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *savedBTN;
@property (weak, nonatomic) IBOutlet UIButton *joinedBTN;
@property (weak, nonatomic) IBOutlet UIButton *timePic;

@end
