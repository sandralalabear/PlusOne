//
//  DealStore.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/29.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "DealStore.h"
#import "ServerCommunicator.h"
#import "AppDelegate.h"
#import "ServerCommunicator.h"
#import "AdvanceImageView.h"

@implementation DealStore
{
    ServerCommunicator *comm;
}

- (Deal *)save:(Deal *)deal {
    // TODO create deal via API
    comm = [ServerCommunicator new];
    
    NSString *range1 = [NSString new];
    NSString *range1_price = [NSString new];
    NSString *range2 = [NSString new];
    NSString *range2_price = [NSString new];
    NSString *range3 = [NSString new];
    NSString *range3_price = [NSString new];
    
    if(deal.priceAndQuantityList.count == 0)
    {
        range1 = @"-1";
        range1_price = @"-1";
        range2 = @"-1";
        range2_price = @"-1";
        range3 = @"-1";
        range3_price = @"-1";
    }
    else if(deal.priceAndQuantityList.count == 1)
    {
        range1 = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[0]).quantity];
        range1_price = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[0]).price];
    }
    else if(deal.priceAndQuantityList.count == 2)
    {
        range1 = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[0]).quantity];
        range1_price = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[0]).price];
        range2 = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[1]).quantity];
        range2_price = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[1]).price];
    }
    else if(deal.priceAndQuantityList.count == 3)
    {
        range1 = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[0]).quantity];
        range1_price = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[0]).price];
        range2 = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[1]).quantity];
        range2_price = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[1]).price];
        range3 = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[2]).quantity];
        range3_price = [NSString stringWithFormat:@"%ld",((PriceAndQuantityData *)deal.priceAndQuantityList[2]).price];
    }
    
    NSDictionary *parameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"],
                                 @"dealname":deal.dealNameText,
                                 @"description":deal.dealDescriptionText,
                                 @"endtime":[NSString stringWithFormat:@"%@",deal.endingDate],
                                 @"target_min":[NSString stringWithFormat:@"%ld",deal.minQuantity],
                                 @"target_max":[NSString stringWithFormat:@"%ld",deal.maxQuantity],
                                 @"range1":range1,
                                 @"range1_price":range1_price,
                                 @"range2":range2,
                                 @"range2_price":range2_price,
                                 @"range3":range3,
                                 @"range3_price":range3_price,
                                 @"moneytransfer":[NSString stringWithFormat:@"%d",deal.moneyTranfer],
                                 @"creditcard":[NSString stringWithFormat:@"%d",deal.creditCard],
                                 @"paymentuponpickup":[NSString stringWithFormat:@"%d",deal.paymentUponPickup],
                                 @"express":[NSString stringWithFormat:@"%d",deal.express],
                                 @"ezship":[NSString stringWithFormat:@"%d",deal.ezship]
                                 };
    
    NSData *imageData = UIImageJPEGRepresentation(deal.coverPhoto, 0.8);
    
    [comm upLoadImages:parameters :imageData];
    
    return deal;
}

- (NSMutableArray *)findDealByUsername:(NSString *)username :(NSMutableArray *)selectALLDetail {
    
    // TODO find deal via API
    
    NSMutableArray *deals = [NSMutableArray new];
    
    for(int i = 0 ; i < selectALLDetail.count ; i++)
    {
        Deal *deal = [[Deal alloc] init];
        deal.id = selectALLDetail[i][@"id"];
        
        deal.dealNameText = selectALLDetail[i][@"dealname"];
        deal.endingDate = selectALLDetail[i][@"endtime"];
        deal.coverPhotoPath = selectALLDetail[i][@"pics"];
        

        PriceAndQuantityData *range1 = [[PriceAndQuantityData alloc] init];
        range1.price = [selectALLDetail[i][@"range1_price"] integerValue];
        range1.quantity = [selectALLDetail[i][@"range1"] integerValue];
        
        NSLog(@"dealstore_test,%ld",[selectALLDetail[i][@"range1"] integerValue]);
        
        if(range1.quantity != 0)
        {
            [deal.priceAndQuantityList addObject:range1];
            NSLog(@"dealstore_range1,%@",deal.priceAndQuantityList);
        }
        
        PriceAndQuantityData *range2 = [[PriceAndQuantityData alloc] init];
        range2.price = [selectALLDetail[i][@"range2_price"] integerValue];
        range2.quantity = [selectALLDetail[i][@"range2"] integerValue];
        
        if(range2.quantity != 0)
        {
            [deal.priceAndQuantityList addObject:range2];
            NSLog(@"dealstore_range2,%@",deal.priceAndQuantityList);
        }

        PriceAndQuantityData *range3 = [[PriceAndQuantityData alloc] init];
        range3.price = [selectALLDetail[i][@"range3_price"] integerValue];
        range3.quantity = [selectALLDetail[i][@"range3"] integerValue];
        
        if(range3.quantity != 0)
        {
            [deal.priceAndQuantityList addObject:range3];
            NSLog(@"dealstore_range3,%@",deal.priceAndQuantityList);
        }

        deals[i] = deal;
    }
    
    /*
    // Deal 1
    Deal *deal1 = [[Deal alloc] init];
    deal1.id = @"1";
    deal1.coverPhoto = [UIImage imageNamed:@"大湖草莓.jpg"];
    deal1.dealNameText = @"超香超甜大湖草莓湊免運～";
    deal1.endingDate = @"2017-06-01";
    
    PriceAndQuantityData *range1 = [[PriceAndQuantityData alloc] init];
    range1.price = 500;
    range1.quantity = 1;
    
    PriceAndQuantityData *range2 = [[PriceAndQuantityData alloc] init];
    range2.price = 350;
    range2.quantity = 50;
    
    PriceAndQuantityData *range3 = [[PriceAndQuantityData alloc] init];
    range3.price = 200;
    range3.quantity = 100;
    
    deal1.priceAndQuantityList[0] = range1;
    deal1.priceAndQuantityList[1] = range2;
    deal1.priceAndQuantityList[2] = range3;
    
    // Deal 2
    Deal *deal2 = [[Deal alloc] init];
    deal2.id = @"2";
    deal2.coverPhoto = [UIImage imageNamed:@"韓國防曬噴霧.JPG"];
    deal2.dealNameText = @"韓國超強力防曬噴霧";
    
    deal2.endingDate = @"2017-05-20";
    
    PriceAndQuantityData *deal2Range1 = [[PriceAndQuantityData alloc] init];
    deal2Range1.price = 500;
    deal2Range1.quantity = 1;
    
    PriceAndQuantityData *deal2Range2 = [[PriceAndQuantityData alloc] init];
    deal2Range2.price = 350;
    deal2Range2.quantity = 3;
    
    deal2.priceAndQuantityList[0] = deal2Range1;
    deal2.priceAndQuantityList[1] = deal2Range2;
    */
    //NSArray *deals = @[deal1, deal2];
    
    return deals;
}

    
@end
