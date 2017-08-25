//
//  TableViewCell.m
//  buyer
//
//  Created by H.M.L on 2017/4/30.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"login"] == NULL)
    {
        self.savedBTN.hidden = true;
    }
    else
    {
        self.savedBTN.hidden = false;
    }
}

@end
