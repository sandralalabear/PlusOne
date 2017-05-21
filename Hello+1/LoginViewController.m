//
//  LoginViewController.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/4/19.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "LoginViewController.h"



@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *login;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Check if only one user log in at a time
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
    }
    
    self.login.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];

   

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
