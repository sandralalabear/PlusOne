//
//  ChattingView.h
//  buyer
//
//  Created by H.M.L on 2017/5/15.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChattingItem.h"

@interface ChattingView : UIScrollView

- (void) addChattingItem:(ChattingItem*) item;

- (void) refreshAllItems;

@end
