//
//  Deal.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/29.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdvanceImageView.h"


@interface Deal : NSObject

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) UIImage *coverPhoto;
@property (nonatomic,strong) NSString *coverPhotoPath;
@property (nonatomic,strong) NSString *dealDescriptionText;
@property (nonatomic,strong) NSString *dealNameText;
@property (nonatomic,strong) NSString *endingDate;
@property NSInteger minQuantity;
@property NSInteger maxQuantity;
@property (nonatomic,strong) NSMutableArray *priceAndQuantityList;

@property BOOL moneyTranfer;
@property BOOL creditCard;
@property BOOL paymentUponPickup;

@property BOOL express;
@property BOOL ezship;

- (NSInteger)getTotalQuantity:(NSArray *)joineds;
- (NSInteger)getTotalPrice:(NSArray *) joineds;
- (NSInteger)determinePrice:(NSInteger) totalQuantity;

@end
