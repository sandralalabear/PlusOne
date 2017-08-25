//
//  JoinedTableViewCell.h
//  buyer
//
//  Created by H.M.L on 2017/5/19.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"
#import "AdvanceImageView.h"
#import "AppDelegate.h"

@interface JoinedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AdvanceImageView *joinedImage;
@property (weak, nonatomic) IBOutlet UILabel *joinedProduct;
@property (weak, nonatomic) IBOutlet UILabel *joinedPrice;
@property (weak, nonatomic) IBOutlet UILabel *joinedCount;
@property (weak, nonatomic) IBOutlet UILabel *joinedEndTime;

@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *label3;
@property (strong, nonatomic) UILabel *label4;
@property (strong, nonatomic) UILabel *label5;
@property (strong, nonatomic) LDProgressView *progressView;

@end
