//
//  JoinedStore.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/6/3.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "JoinedStore.h"
#import "PriceAndQuantityData.h"

@implementation JoinedStore
{
    NSMutableArray *result;
}

// 改寫這裡
- (Joined *)save:(Joined *)joined {
    return nil;
}

// 改寫這裡
- (NSMutableArray *)findByDeal:(Deal *)deal :(NSMutableArray *)selectUserDetail {
    
    result = [NSMutableArray new];
    
    for(int i = 0 ; i < selectUserDetail.count ; i++)
    {
        Joined *buyer = [[Joined alloc] init];
        if([deal.id isEqual:selectUserDetail[i][@"id"]])
        {
            buyer.buyerName = selectUserDetail[i][@"buyer"];
            buyer.quantity = (NSInteger *)[selectUserDetail[i][@"count"] integerValue];
            buyer.amount = (NSInteger *)[selectUserDetail[i][@"totalprice"] integerValue];
            buyer.joinedDate = selectUserDetail[i][@"joinedtime"];
            buyer.keyString = selectUserDetail[i][@"image"];
        }
        [result addObject:buyer];
    }
    
    return result;
    
    /*
    if ([deal.id  isEqual: @"1"]) {
        // Buyer 1
        Joined *buyer1 = [[Joined alloc] init];
        buyer1.buyerPhoto = [UIImage imageNamed:@"selfie.jpg"];
        buyer1.buyerName = @"Sandralalabear";
        buyer1.quantity = (NSInteger *)2;
        buyer1.amount = (NSInteger *)1000;
        buyer1.joinedDate = @"2017-05-06";
        
        // Buyer 2
        Joined *buyer2 = [[Joined alloc] init];
        buyer2.buyerPhoto = [UIImage imageNamed:@"熊大.jpg"];
        buyer2.buyerName = @"BearDada";
        buyer2.quantity = (NSInteger *)10;
        buyer2.amount = (NSInteger *)2000;
        buyer2.joinedDate = @"2017-05-26";
    
        return @[buyer1,buyer2];
        
    } else if ([deal.id  isEqual: @"2"]) {
        // Buyer 1
        Joined *buyer1 = [[Joined alloc] init];
        buyer1.buyerPhoto = [UIImage imageNamed:@"MyCat.jpg"];
        buyer1.buyerName = @"Meowmeow";
        buyer1.quantity = (NSInteger *)20;
        buyer1.amount = (NSInteger *)10000;
        buyer1.joinedDate = @"2017-06-06";
        
        // Buyer 2
        Joined *buyer2 = [[Joined alloc] init];
        buyer2.buyerPhoto = [UIImage imageNamed:@"sketch.jpeg"];
        buyer2.buyerName = @"SketcherLee";
        buyer2.quantity = (NSInteger *)80;
        buyer2.amount = (NSInteger *)20000;
        buyer2.joinedDate = @"2017-04-28";
        
        return @[buyer1,buyer2];
    }
    */
    //return @[];
}

- (NSMutableArray *)findByBuyer:(Buyer *)buyer {
    return nil;
}
@end
