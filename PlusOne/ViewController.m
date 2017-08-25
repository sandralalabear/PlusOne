//
//  ViewController.m
//  buyer
//
//  Created by H.M.L on 2017/4/27.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ServerCommunicator.h"
#import <AFNetworking.h>

@interface ViewController ()
{
    ServerCommunicator *comm;
}
@property (weak, nonatomic) IBOutlet UIImageView *showImageTest;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
    NSLog(@"userdefault%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]);
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login"];
}

//login button
- (IBAction)loginBtn:(id)sender {
    
    NSDictionary *parameters = @{@"username" : self.accountField.text,
                                 @"password" : self.passwordField.text};
    [[NSUserDefaults standardUserDefaults] setObject:parameters forKey:@"login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]);
    //連php判斷登入帳號密碼是否正確
    [comm doPostWithURLString:SELECT_URL
                   parameters:parameters
                         data:nil
                   completion:^(NSError *error, id result) {
                       if([result[@"result"] isEqualToString:@"YES"])
                       {
                           [self alertTrue];
                           NSLog(@"userdefault%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]);
                       }
                       else
                       {
                           [self alertFalse];
                       }
                   }];
}
- (IBAction)logoutBtn:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]);
    NSLog(@"logout");
}

//newaccount button
- (IBAction)newAccountBtn:(id)sender {
    
    BViewController * bVc = [self.storyboard instantiateViewControllerWithIdentifier:@"BViewController"];
    [self showViewController:bVc sender:nil];
}

//上傳圖片button
- (IBAction)uploadImage:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"hand.png"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSLog(@"imageData: %fx%f (%lu bytes)",image.size.width,image.size.height,imageData.length);
    NSDictionary * parameters = @{@"username": self.accountField.text};
    
    [comm upLoadImages:parameters :imageData];
}

-(void) alertTrue
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome" message:@"登入成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"GO" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) alertFalse
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"帳號or密碼錯誤" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

//點擊螢幕縮鍵盤
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
}

//保存登入session
//-(void)

//一定要先簽協定protocol
//按return縮鍵盤
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder]; //縮鍵盤
//    return YES;
//}


@end
