//
//  Deal.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/29.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "Deal.h"

@implementation Deal

- (id)init {
    if (self = [super init]) {
        _priceAndQuantityList = [[NSMutableArray alloc] init];
    }
    return  self;
}
    
@end
