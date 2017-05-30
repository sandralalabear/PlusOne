//
//  SignUpViewController.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/28.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpTableViewCell.h"

@interface SignUpViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate>
    @property (nonatomic,strong) NSArray *signUpFieldTitles;
    @property (weak, nonatomic) IBOutlet UITableView *signUpTableView;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set navigation title
    self.navigationItem.title = @"Sign up";
    
    // initialize array
    _signUpFieldTitles = [[NSMutableArray alloc] initWithObjects:@"Username",@"Password",@"Confirm password", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self.view endEditing:YES];
//   return YES;
    
    if (textField == _signUpFieldTitles[2]) {
        [textField resignFirstResponder];
    } else if (textField == _signUpFieldTitles[0]) {
        [_signUpFieldTitles[1] becomeFirstResponder];
    }
    return YES;
}
    

#pragma mark - Table view data source
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_signUpFieldTitles count];
}

    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SignUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.signUpTitleLabel.text = [_signUpFieldTitles objectAtIndex:indexPath.row];
    cell.signUpTextField.delegate = self;
    cell.signUpTextField.returnKeyType = UIReturnKeyNext;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
