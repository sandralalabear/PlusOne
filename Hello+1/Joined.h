//
//  Joined.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/6/3.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Joined : NSObject

@property (nonatomic,strong) UIImage *buyerPhoto;
@property (nonatomic,strong) NSString *buyerName;
@property (nonatomic,strong) NSString *joinedDate;
@property  NSInteger *quantity;
@property  NSInteger *amount;
@property (nonatomic,strong) NSString *shippingMethod;
@property (nonatomic,strong) NSString *paymentMethod;
@property (nonatomic,strong) NSString *dealId;
@property (nonatomic,strong) NSString *keyString;




@end
