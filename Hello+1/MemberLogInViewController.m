//
//  MemberLogInViewController.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/31.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "MemberLogInViewController.h"
#import "MemberLogInTableViewCell.h"
#import "User.h"
#import "ServerCommunicator.h"
#import "AppDelegate.h"
#import "ProfileTableViewController.h"

@interface MemberLogInViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
    @property (nonatomic,strong) NSArray *memberLogInFieldTitles;
    @property (weak, nonatomic) IBOutlet UITableView *memeberLogInTableView;
@end

@implementation MemberLogInViewController
{
    ServerCommunicator *comm;
    ProfileTableViewController *pro;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
    pro = [ProfileTableViewController new];
    
    // Do any additional setup after loading the view.
     _memberLogInFieldTitles = [[NSMutableArray alloc] initWithObjects:@"Username",@"Password", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    if (textField.tag != _memberLogInFieldTitles.count-1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag+1 inSection:0];
        MemberLogInTableViewCell *cell = [self.memeberLogInTableView cellForRowAtIndexPath:indexPath];
        [cell.logInTextField becomeFirstResponder];
    }
    return YES;
}
    

    
#pragma mark - Table view data source
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_memberLogInFieldTitles count];
}
    
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberLogInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.logInFieldTitle.text = [_memberLogInFieldTitles objectAtIndex:indexPath.row];
    cell.logInTextField.delegate = self;
    if (indexPath.row == 1) {
        cell.logInTextField.secureTextEntry = YES;
    }
    
    if (indexPath.row < _memberLogInFieldTitles.count -1) {
        cell.logInTextField.returnKeyType = UIReturnKeyNext;
    }else {
        cell.logInTextField.returnKeyType = UIReturnKeyDone;
    }
    
    cell.logInTextField.tag = indexPath.row;
    
    return cell;
}
    
    
- (IBAction)logInButtonPressed:(UIButton *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    MemberLogInTableViewCell *cell = [self.memeberLogInTableView cellForRowAtIndexPath:indexPath];
    User *user = [[User alloc] init];
    user.username = cell.logInTextField.text;
    NSLog(@"user.name: %@",user.username);

    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
    MemberLogInTableViewCell *cell1 = [self.memeberLogInTableView cellForRowAtIndexPath:indexPath1];
    user.password = cell1.logInTextField.text;
    NSLog(@"user.password: %@",user.password);
    
    NSDictionary *parameters = @{@"username" : user.username,
                                 @"password" : user.password};
    
    [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"login"];
    
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

-(void) alertTrue
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome" message:@"登入成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"GO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self performSegueWithIdentifier:@"goBackToProfile" sender:self];
        
    }];
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
    
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
