//
//  UserStore.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/27.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "UserStore.h"
#import "User.h"

static NSString * ObjectKey = @"users";

@implementation UserStore
    
- (NSMutableArray *)findAll {
    NSMutableArray *users = [[NSUserDefaults standardUserDefaults] objectForKey:ObjectKey];
    return users == nil ? [[NSMutableArray alloc] init] : users;
}
    
- (int)getIndexByUsername:(NSString *)username in:(NSMutableArray *)users {
    for (int i = 0; i < users.count; i++) {
        if (((User *)users[i]).username == username) {
            return i;
        }
    }
    return -1;
}
    
//- (int)getIndexByUsername:(NSString *)username {
//    NSArray *users = [self findAll];
//    return [self getIndexByUsername:username in:users];
//}
    
- (User *)getByUsername:(NSString *)username {
    
    // TODO load data from api
    NSMutableArray * users = [self findAll];
    
    NSLog(@"Get user by username [%@]", username);
    
    int index = [self getIndexByUsername:username in:users];
    
    if (index == -1) {
        return nil;
    } else {
        return users[index];
    }
    //    User *user = [User new];
    //    user.username = @"sandrawei";
    //    user.password = @"demo";
    //    user.addressFloat = @"桃園市八德區廣興二路777號";
    //
    //
    //    return user;
}
    
- (User *)save:(User *)user {
    
    // TODO save user via api
    
    NSMutableArray * users = [self findAll];
    int index = [self getIndexByUsername:user.username in:users];
    if (index == -1) {
        // create
        [users addObject:user];
    } else {
        // update
        users[index] = user;
    }
//    [[NSUserDefaults standardUserDefaults] setObject:users forKey:ObjectKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"User [%@] is saved", user.username);
    return user;
}

@end
