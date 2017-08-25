//
//  ChattingItem.h
//  buyer
//
//  Created by H.M.L on 2017/5/15.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    
    ChattingItemTypeFromMe,
    ChattingItemTypeFromOthers
    
} ChattingItemType;

@interface ChattingItem : NSObject

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) UIImage* image;
@property (nonatomic,assign) ChattingItemType type;

@end
