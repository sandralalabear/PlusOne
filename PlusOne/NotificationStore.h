//
//  NotificationStore.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/6/3.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deal.h"
#import "Notification.h"

@interface NotificationStore : NSObject

- (Notification *)save:(Notification *)notification;
- (NSArray *)findByDeal:(Deal *)deal :(NSMutableArray *)selectALLDetail;
- (Notification *)add:(NSString *) content to: (Deal *)deal;

@end
