//
//  joinedAllTableViewCell.h
//  Hello+1
//
//  Created by H.M.L on 2017/6/4.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "TableViewCell.h"

@interface joinedAllTableViewCell : TableViewCell
@property (weak, nonatomic) IBOutlet AdvanceImageView *joinedAllImage;
@property (weak, nonatomic) IBOutlet UILabel *joinedAllUsername;
@property (weak, nonatomic) IBOutlet UILabel *joinedtime;
@property (weak, nonatomic) IBOutlet UILabel *joinedAllCount;

@end
