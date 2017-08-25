//
//  NotificationStore.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/6/3.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "NotificationStore.h"
#import "Notification.h"

@implementation NotificationStore

NSDateFormatter *dateFormatter;

- (instancetype)init {
    self = [super init];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return self;
}
// 改寫 這裡
- (Notification *)save:(Notification *)notification {
    return notification;
}
// 改寫 這裡

- (NSArray *)findByDeal:(Deal *)deal :(NSMutableArray *)selectALLDetail {
    
    Notification *notification1 = [[Notification alloc] init];
    notification1.content = @"Inform all buyers to pay";
    notification1.date = @"2018-05-06";
    
    
    Notification *notification2 = [[Notification alloc] init];
    notification2.content = @"Inform deal is on the way";
    notification2.date = @"2017-05-07";
    
    return @[notification1, notification2];
}

- (Notification *)add:(NSString *)content to:(Deal *)deal {
    
    Notification *notification = [[Notification alloc] init];
    notification.content = content;
    notification.date = [dateFormatter stringFromDate:[NSDate date]];
    notification.dealId = deal.id;
    
    return [self save: notification];
}


@end
