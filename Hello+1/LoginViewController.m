//
//  LoginViewController.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/4/19.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "LoginViewController.h"



@interface LoginViewController ()


    
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FBSDKLoginButton *fbLoginButton = [[FBSDKLoginButton alloc] init];
    
    [self.view addSubview:fbLoginButton];
    
    fbLoginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
}
    
- (void) fbLoginButton:(FBSDKLoginButton *)fbLoginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    NSDictionary *demandInfo = @{@"fields": @"email, first_name, id, last_name, name, picture"};
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:demandInfo] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        NSLog(@"%@",result);
        
        FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
        NSLog(@"%@",accessToken);
        
        NSString *userEmail = result[@"email"];
        NSLog(@"%@",userEmail);
        
        NSString *firstName = result[@"first_name"];
        NSLog(@"%@",firstName);
        
        NSString *lastName = result[@"last_name"];
        NSLog(@"%@",lastName);
        
        NSString *userID = result[@"id"];
        NSLog(@"%@",userID);
        
        NSString *userName = result[@"name"];
        NSLog(@"%@",userName);
        
        //        NSDictionary *picture = result[@"picture"];
        //        NSDictionary *data = picture[@"data"];
        //        NSString *userPictureURL = data[@"url"];
        NSString *userPictureURL = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
        NSLog(@"%@",userPictureURL);
    }];
}
    
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)fbLoginButton {
    NSLog(@"log out %@",[FBSDKAccessToken currentAccessToken]);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
