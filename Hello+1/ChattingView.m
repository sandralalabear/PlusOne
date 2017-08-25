//
//  ChattingView.m
//  buyer
//
//  Created by H.M.L on 2017/5/15.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "ChattingView.h"
#import "ChattingBubbleView.h"

#define Y_PADDING 20

@implementation ChattingView
{
    NSMutableArray *allItems;
    CGFloat lastBubbleViewY;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void) addChattingItem:(ChattingItem*) item {

    // Prepare allItems
    if(allItems == nil) {
        allItems = [NSMutableArray new];
    }
    
    // Prepare ChattingBubbleView
    ChattingBubbleView *bubbleView = [[ChattingBubbleView alloc] initWithItem:item offsetY:lastBubbleViewY + Y_PADDING];
    
    // Add ChattingBubbleView to ChattingView
    [self addSubview:bubbleView];
    
    // Recaculate lastBubbleViewY and content size
    lastBubbleViewY = CGRectGetMaxY(bubbleView.frame);
    self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), lastBubbleViewY);
    
    // Scroll to Bottom of ChattingView
    [self scrollRectToVisible:CGRectMake(0, lastBubbleViewY - 1, 1, 1) animated:true];
    
    // Keep ChattingItem
    [allItems addObject:item];
}

- (void) refreshAllItems {
    
    // Clear all exist bubbles and reset some variables.
    for(UIView *tmp in self.subviews) {
        [tmp removeFromSuperview];
    }
    NSArray *previousItems = [NSArray arrayWithArray:allItems];
    [allItems removeAllObjects];
    lastBubbleViewY = 0;
    
    // Recreate all bubbles
    for(ChattingItem *item in previousItems) {
        [self addChattingItem:item];
    }
    
}




@end
