//
//  BViewController.m
//  buyer
//
//  Created by H.M.L on 2017/5/1.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "BViewController.h"
#import "ServerCommunicator.h"
#import "TableViewController.h"
#import "AppDelegate.h"
#import <AFNetworking.h>

@interface BViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation BViewController
{
    ServerCommunicator *comm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
}

- (IBAction)submitBtn:(id)sender
{
    NSDictionary *parameters = @{@"username" : self.usernameTextField.text,
                                 @"password" : self.passwordTextField.text};
    
    [comm doPostWithURLString:INSERT_URL
                 parameters:parameters
                       data:nil
                 completion:^(NSError *error, id result) {
                     if([result[@"result"] isEqualToString:@"YES"]){
                         [self alertTrue];
                     }
                     else{
                         [self alertFalse];
                     }
                 }];
}

-(void) alertTrue
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congragulations" message:@"註冊成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
                    TableViewController * tbv = [self.storyboard instantiateViewControllerWithIdentifier:@"tbv"];
                    [self showViewController:tbv sender:nil];
                }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) alertFalse
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Username已有人使用" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

//點擊螢幕縮鍵盤
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
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
