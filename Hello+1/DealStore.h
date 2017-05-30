//
//  DealStore.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/29.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deal.h"

@interface DealStore : NSObject

- (Deal *)save:(Deal *)deal;
    
@end
