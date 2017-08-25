//
//  Deal.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/29.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "Deal.h"
#import "Joined.h"
#import "PriceAndQuantityData.h"

@implementation Deal

- (id)init {
    if (self = [super init]) {
        _priceAndQuantityList = [[NSMutableArray alloc] init];
    }
    return  self;
}

- (NSInteger)getTotalQuantity:(NSArray *)joineds {
    
    NSInteger count = 0;
    for (int i = 0; i < joineds.count; i ++) {
        Joined *joined = joineds[i];
        count = count + (NSInteger)joined.quantity;
    }
    return count;
}


- (NSInteger)getTotalPrice:(NSArray *)joineds {
    
    NSInteger totalQuantity = [self getTotalQuantity:joineds];
    NSInteger price = [self determinePrice:totalQuantity];
    
    return totalQuantity * price;
}

- (NSInteger)determinePrice:(NSInteger) totalQuantity {
    
    PriceAndQuantityData *priceData = _priceAndQuantityList[0];
    
    NSInteger price = priceData.price;
    
    for (int i = 0; i < _priceAndQuantityList.count; i ++)
    {
        PriceAndQuantityData *priceAndQuantity = _priceAndQuantityList[i];
        
        if (totalQuantity >= priceAndQuantity.quantity) {
            price = priceAndQuantity.price;
        }
        
    }
    return price;
}


@end
