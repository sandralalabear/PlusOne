//
//  MinAndMaxSliderTableViewCell.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/21.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

@interface MinAndMaxSliderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;
@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;

@end
