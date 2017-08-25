//
//  ChattingBubbleView.h
//  buyer
//
//  Created by H.M.L on 2017/5/15.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChattingItem.h"

@interface ChattingBubbleView : UIView

- (instancetype) initWithItem:(ChattingItem*)item
                      offsetY:(CGFloat) offsetY;

@end
