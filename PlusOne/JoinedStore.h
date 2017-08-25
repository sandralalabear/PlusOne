//
//  JoinedStore.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/6/3.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Joined.h"
#import "Deal.h"
#import "Buyer.h"

@interface JoinedStore : NSObject

- (Joined *)save: (Joined *)joined;
- (NSMutableArray *)findByDeal: (Deal *)deal :(NSMutableArray *) selectUserDetail;
- (NSMutableArray *)findByBuyer: (Buyer *)buyer;

@end
