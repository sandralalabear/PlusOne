//
//  AppDelegate.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/4/12.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <UIKit/UIKit.h>

// ngrok
#define BASE_URL @"https://7f23ad2c.ngrok.io/appdb"
#define PHOTO_URL @"https://7f23ad2c.ngrok.io/appdb/pics/"

#define SELECT_URL [BASE_URL stringByAppendingPathComponent:@"appdb_select.php"]
#define INSERT_URL [BASE_URL stringByAppendingPathComponent:@"appdb_insert.php"]
#define SELECT_IMAGE_URL [BASE_URL stringByAppendingPathComponent:@"appdb_select_image.php"]
#define INSERT_DEAL_URL [BASE_URL stringByAppendingPathComponent:@"appdb_insert_deal.php"]
#define UPDATE_IMAGE_URL [BASE_URL stringByAppendingPathComponent:@"appdb_update_image.php"]
#define PROFILE_IMAGE_URL [BASE_URL stringByAppendingPathComponent:@"appdb_select_profileimage.php"]
#define INSERT_IMAGE_URL [BASE_URL stringByAppendingPathComponent:@"appdb_insert_image.php"]
#define SAVED_INSERT_URL [BASE_URL stringByAppendingPathComponent:@"appdb_insert_saved.php"]
#define SAVED_SELECT_URL [BASE_URL stringByAppendingPathComponent:@"appdb_select_saved.php"]
#define JOINED_INSERT_URL [BASE_URL stringByAppendingPathComponent:@"appdb_insert_joined.php"]
#define JOINED_SELECT_URL [BASE_URL stringByAppendingPathComponent:@"appdb_select_joined.php"]
#define USER_DETAIL_URL [BASE_URL stringByAppendingPathComponent:@"appdb_select_user_detail.php"]
#define JOINED_SELECT_ALL_URL [BASE_URL stringByAppendingPathComponent:@"appdb_select_all_joined.php"]
#define MESSAGE_SELECT_URL [BASE_URL stringByAppendingPathComponent:@"appdb_select_message.php"]
#define CHATMESSAGE_SELECT_URL [BASE_URL stringByAppendingPathComponent:@"appdb_select_chatmessage.php"]
#define CHATMESSAGE_INSERT_URL [BASE_URL stringByAppendingPathComponent:@"appdb_insert_chatmessage.php"]
#define PROFILE_UPDATE_URL [BASE_URL stringByAppendingPathComponent:@"appdb_update_profile.php"]
#define UPDATEDEVICETOKEN_URL [BASE_URL stringByAppendingPathComponent:@"appdb_deviceToken.php"]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

