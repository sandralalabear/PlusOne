//
//  UserStore.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/27.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "UserStore.h"
#import "User.h"
#import "ServerCommunicator.h"
#import "AppDelegate.h"

static NSString * ObjectKey = @"users";

@implementation UserStore
{
    ServerCommunicator *comm;
}

- (User *)getByUsername:(NSString *)username {
    
    User *user = [User new];
    //user.username = @"sandrawei";
    //user.password = @"demo";
    //user.address = @"桃園市八德區廣興二路777號";
    return user;
}

- (User *)save:(User *)user
{
    NSLog(@"testonly,%@",user.username);
    
    comm = [ServerCommunicator new];
    
    NSString *payment1;
    NSString *payment2;
    NSString *payment3;
    NSString *payment4;
    NSString *shipping1;
    NSString *shipping2;
    NSString *shipping3;
    
    if(user.paymentMethod.count == 0)
    {
        payment1 = @"";
        payment2 = @"";
        payment3 = @"";
        payment4 = @"";
    }
    else if(user.paymentMethod.count == 1)
    {
        payment1 = user.paymentMethod[0];
        payment2 = @"";
        payment3 = @"";
        payment4 = @"";
    }
    else if(user.paymentMethod.count == 2)
    {
        payment1 = user.paymentMethod[0];
        payment2 = user.paymentMethod[1];
        payment3 = @"";
        payment4 = @"";
    }
    else if(user.paymentMethod.count == 3)
    {
        payment1 = user.paymentMethod[0];
        payment2 = user.paymentMethod[1];
        payment3 = user.paymentMethod[2];
        payment4 = @"";
    }
    else if(user.paymentMethod.count == 4)
    {
        payment1 = user.paymentMethod[0];
        payment2 = user.paymentMethod[1];
        payment3 = user.paymentMethod[2];
        payment4 = user.paymentMethod[3];
    }
    
    if(user.shippingMethod.count == 0)
    {
        shipping1 = @"";
        shipping2 = @"";
        shipping3 = @"";
    }
    else if(user.shippingMethod.count == 1)
    {
        shipping1 = user.shippingMethod[0];
        shipping2 = @"";
        shipping3 = @"";
    }
    else if(user.shippingMethod.count == 2)
    {
        shipping1 = user.shippingMethod[0];
        shipping2 = user.shippingMethod[1];
        shipping3 = @"";
    }
    else if(user.shippingMethod.count == 3)
    {
        shipping1 = user.shippingMethod[0];
        shipping2 = user.shippingMethod[1];
        shipping3 = user.shippingMethod[2];
    }
    
    NSDictionary *parameters = @{@"username":user.username,
                                 @"password":user.password,
                                 @"name":user.name,
                                 @"email":user.email,
                                 @"address":user.address,
                                 @"birthday":[NSString stringWithFormat:@"%@",user.birthday],
                                 @"payment1":payment1,
                                 @"payment2":payment2,
                                 @"payment3":payment3,
                                 @"payment4":payment4,
                                 @"shipping1":shipping1,
                                 @"shipping2":shipping2,
                                 @"shipping3":shipping3
                                 };
    
    [comm doPostWithURLString:PROFILE_UPDATE_URL
                   parameters:parameters
                         data:nil
                   completion:nil];
    return user;
}

/*
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
*/


@end
