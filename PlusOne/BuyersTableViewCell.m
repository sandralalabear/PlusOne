//
//  BuyersTableViewCell.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/6/3.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "BuyersTableViewCell.h"

@implementation BuyersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // set the profile image into circle
    self.buyerCoverPhoto.layer.cornerRadius = self.buyerCoverPhoto.frame.size.width/ 2;
    self.buyerCoverPhoto.clipsToBounds = YES;
    
    // adding border to profile image
    self.buyerCoverPhoto.layer.borderWidth = 2.0f;
    self.buyerCoverPhoto.layer.borderColor = [UIColor whiteColor].CGColor;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
