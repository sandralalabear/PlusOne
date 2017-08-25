//
//  ChatManagerTableViewCell.h
//  buyer
//
//  Created by H.M.L on 2017/5/13.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvanceImageView.h"
#import "AppDelegate.h"

@interface ChatManagerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *receiveName;
@property (weak, nonatomic) IBOutlet UILabel *receiveMessage;
@property (weak, nonatomic) IBOutlet UILabel *receiveTime;
@property (weak, nonatomic) IBOutlet AdvanceImageView *usernameImage;

@end
