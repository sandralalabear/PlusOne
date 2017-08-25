//
//  ChatBox.h
//  buyer
//
//  Created by H.M.L on 2017/5/15.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatBox : UIViewController
@property(strong,nonatomic) NSDictionary *getChatManager;
@property(strong,nonatomic) NSString *sender;
@property(strong,nonatomic) NSString *receiver;

@end
