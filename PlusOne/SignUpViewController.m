//
//  SignUpViewController.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/28.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpTableViewCell.h"
#import "User.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ProfileTableViewController.h"
#import "UserStore.h"
#import "ServerCommunicator.h"
#import "AppDelegate.h"


static NSString *cellIdentifier = @"Cell";

@interface SignUpViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
    @property (nonatomic,strong) NSArray *signUpFieldTitles;
    @property (weak, nonatomic) IBOutlet UITableView *signUpTableView;
    @property (nonatomic,strong) User *user;
    @property (weak, nonatomic) IBOutlet UIButton *profileImageBtn;
    @property (nonatomic,strong) UIImage * modifiedImage;
    @property (nonatomic,strong) UserStore *userStore;

@end

@implementation SignUpViewController
{
    ServerCommunicator *comm;
    ProfileTableViewController *pro;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
    pro = [ProfileTableViewController new];

    // Set navigation title
    self.navigationItem.title = @"Sign up";
    
    // initialize array
    _signUpFieldTitles = [[NSMutableArray alloc] initWithObjects:@"Username",@"Password",@"Confirm password", nil];
    
    
    // set the profile image into circle
    self.profileImageBtn.layer.cornerRadius = self.profileImageBtn.frame.size.width/ 2;
    self.profileImageBtn.clipsToBounds = YES;
    
    // adding border to profile image
    self.profileImageBtn.layer.borderWidth = 3.0f;
    self.profileImageBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _userStore = [[UserStore alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    if (textField.tag != _signUpFieldTitles.count-1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag+1 inSection:0];
        SignUpTableViewCell *cell = [self.signUpTableView cellForRowAtIndexPath:indexPath];
        [cell.signUpTextField becomeFirstResponder];
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
    
    SignUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.signUpTitleLabel.text = [_signUpFieldTitles objectAtIndex:indexPath.row];
    cell.signUpTextField.delegate = self;

    if (indexPath.row < _signUpFieldTitles.count -1) {
        cell.signUpTextField.returnKeyType = UIReturnKeyNext;
    }else {
        cell.signUpTextField.returnKeyType = UIReturnKeyDone;
    }
    
    if (indexPath.row == 1 || indexPath.row == 2 ) {
        cell.signUpTextField.secureTextEntry = YES;
    }

    cell.signUpTextField.tag = indexPath.row;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
    
- (IBAction)signUpButtonPressed:(UIButton *)sender {
    
    SignUpTableViewCell *usernameCell = [self.signUpTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    SignUpTableViewCell *passwordCell = [self.signUpTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    SignUpTableViewCell *confirmPasswordCell = [self.signUpTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (![passwordCell.signUpTextField.text isEqualToString: confirmPasswordCell.signUpTextField.text]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Password confirm error" message:@"Please check your password again!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
    }
    
    User *user = [[User alloc] init];
    user.username = usernameCell.signUpTextField.text;
    NSLog(@"user.username: %@",user.username);
    
    user.password = passwordCell.signUpTextField.text;
    NSLog(@"user.password: %@",user.password);
    
    user.profilePhoto = _modifiedImage;
    NSLog(@"_modifiedImage: %@",_modifiedImage);
    
    NSDictionary *parameters = @{@"username" : user.username,
                                 @"password" : user.password};
    
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
    
    /*存profile至database start 2017.05.30 by Larry*/
    
    [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"login"];
    
    //[_userStore save:user];
    
    if(user.profilePhoto)
    {
        [[NSUserDefaults standardUserDefaults] setObject:UIImageJPEGRepresentation(user.profilePhoto,0.8) forKey:@"profilePhoto"];
        
        NSData *imageData = UIImageJPEGRepresentation(self.modifiedImage, 0.8);
        
        NSDictionary *parameters2 = @{@"username": user.username};
        
        [comm updateImages:parameters2 :imageData];
    }
    
    /*存profile至database end 2017.05.30 by Larry*/
    
    //[_userStore save:user];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)profilePhotoUpload:(UIButton *)sender {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Upload photo from" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction * album = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:camera];
    [alert addAction:album];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
}

    
-(void)launchImagePickerWithSourceType:(UIImagePickerControllerSourceType)type {
    // Check if source type is available or not
    if(![UIImagePickerController isSourceTypeAvailable:type]) {
        NSLog(@"Invalid Source Type");
        return;
    }
    // Prepare picker
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    // media type: Image and video
    picker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:true completion:nil];
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString * type = info[UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
        self.modifiedImage = [self modifyImage:originalImage];
//        NSData * originalJPGData = UIImageJPEGRepresentation(originalImage, 0.7);
//        NSData * modifiedJPGData = UIImageJPEGRepresentation(self.modifiedImage, 0.7);
         [self.profileImageBtn setImage:self.modifiedImage forState:normal];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }

    
    
    
// Compress images
-(UIImage *) modifyImage:(UIImage *) inputImage {
    CGFloat maxLength = 1024.0;
    CGSize targetSize;
    UIImage * finalImage;
    CGSize inputSize = inputImage.size;
    
    // Check if it is necessary to resize input image
    if(inputSize.width <= maxLength && inputSize.height <= maxLength) {
        // Use original image
        finalImage = inputImage;
        targetSize = inputSize;
    } else {
        // Will resize inpuImage
        if (inputSize.width >= inputSize.height) {
            // width >= height
            CGFloat ratio = inputSize.width / maxLength;
            targetSize = CGSizeMake(maxLength, inputSize.height / ratio);
        } else {
            // width < height
            CGFloat ratio = inputSize.height / maxLength;
            targetSize = CGSizeMake(inputSize.width / ratio , maxLength);
        }
        // Perform resize here
        UIGraphicsBeginImageContext(targetSize);
        [inputImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
        finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return finalImage;
}

-(void) alertTrue
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome to +1 App" message:@"註冊成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        [self performSegueWithIdentifier:@"goBackToProfile" sender:self];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
