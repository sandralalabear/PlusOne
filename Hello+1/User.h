//
//  User.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/27.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *birthday;
@property (nonatomic) NSArray *paymentMethod;
@property (nonatomic) NSArray *shippingMethod;
    
@end
