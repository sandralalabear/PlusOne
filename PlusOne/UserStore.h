//
//  UserStore.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/27.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserStore : NSObject

- (User *)getByUsername:(NSString *) username;
- (User *)save:(User *) user;
    
@end
