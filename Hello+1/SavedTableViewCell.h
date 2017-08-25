//
//  SavedTableViewCell.h
//  buyer
//
//  Created by H.M.L on 2017/5/5.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvanceImageView.h"
#import "AppDelegate.h"

@interface SavedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet AdvanceImageView *productImages;

@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productCount;
@property (weak, nonatomic) IBOutlet UILabel *productEndTime;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIButton *timePic;


@end
