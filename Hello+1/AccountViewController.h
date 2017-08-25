//
//  AccountViewController.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/25.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "XLForm.h"
#import "XLFormViewController.h"
#import "UserStore.h"
#import "User.h"

@interface AccountViewController : XLFormViewController
@property (nonatomic) User *user;
@property (nonatomic) UserStore *userStore;
@property (nonatomic) NSMutableArray *selectProfile;


@end
