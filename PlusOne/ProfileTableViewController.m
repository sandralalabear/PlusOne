//
//  ProfileTableViewController.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/4/16.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "CreateADealTableViewController.h"
#import "LoginViewController.h"
#import "AccountViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AFNetworking.h>
#import "Deal.h"
#import "User.h"
#import "DealsManagementTableViewController.h"
#import "ServerCommunicator.h"
#import "AppDelegate.h"
#import "AdvanceUIButton.h"

@interface ProfileTableViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) NSMutableArray *profileArray;
@property (nonatomic,strong) NSArray *hostArray;
@property (nonatomic,strong) NSArray *settingsArray;
@property (nonatomic,strong) NSArray *aboutUs;
@property (nonatomic,strong) NSMutableArray *titleArray;

@property (nonatomic,strong) NSString *selectedBtnName;

@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet AdvanceUIButton *profileImageBtn;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editProfileBtn;

@property User *user;

@end

@implementation ProfileTableViewController
{
    ServerCommunicator *comm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
    
    /* 讀資料 start 2017.05.30 */
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"profilePhoto"] != nil)
    {
        [self.profileImageBtn setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"profilePhoto"]] forState:UIControlStateNormal];
    }
    else
    {
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"login"])
        {
            NSDictionary *parameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]};
            NSData *data = [NSData new];
            [comm doPostJobWithURLString:PROFILE_IMAGE_URL
                              parameters:parameters
                                    data:data
                              completion:^(NSError *error, id result) {
                                  selectProfileImage = result;
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      //抓取圖片
                                      NSString *urlString = [PHOTO_URL stringByAppendingPathComponent:selectProfileImage[0][@"image"]];
                                      NSURL *url = [NSURL URLWithString:urlString];
                                      [self.profileImageBtn loadImageWithURL:url];
                                      
                                      [self.profileView reloadInputViews];
                                  });
                              }];
        }
    }
    /* 讀資料 end 2017.05.30 */
    
    self.navigationItem.title = NSLocalizedString(@"Profile", nil);
    
    // initialize arrays in profile array
    _titleArray = [[NSMutableArray alloc] initWithObjects: NSLocalizedString(@"Host", nil), NSLocalizedString(@"SETTINGS", nil), NSLocalizedString(@"About us", nil), nil];
    
    _hostArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Create a deal", nil), NSLocalizedString(@"Deals management", nil), nil];
    _settingsArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Log in", nil),  NSLocalizedString(@"Settings", nil), nil];
    _aboutUs = [[NSArray alloc] initWithObjects: NSLocalizedString(@"Give us feedback", nil) , nil];
    
    _profileArray = [[NSMutableArray alloc] initWithObjects:_hostArray,_settingsArray,_aboutUs, nil];
    
    // set the profile image into circle
    self.profileImageBtn.layer.cornerRadius = self.profileImageBtn.frame.size.width/ 2;
    self.profileImageBtn.clipsToBounds = YES;
    
    // adding border to profile image
    self.profileImageBtn.layer.borderWidth = 3.0f;
    self.profileImageBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.editProfileBtn setTitle: NSLocalizedString(@"Edit Profile", nil) forState:UIControlStateNormal];

}

- (void)viewDidAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login"]) {
        _settingsArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Log out", nil), NSLocalizedString(@"Settings", nil), nil];
        
        _profileArray[1] = _settingsArray;
        NSLog(@"check,%@",_profileArray);
        [_profileTableView reloadData];
        _userNameLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]];
        NSLog(@"_userNameLabel.text: %@",_userNameLabel.text);
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"profilePhoto"])
        {
            [self.profileImageBtn setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"profilePhoto"]] forState:normal];
        }
        else
        {
            NSDictionary *parameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]};
            NSData *data = [NSData new];
            [comm doPostJobWithURLString:PROFILE_IMAGE_URL
                              parameters:parameters
                                    data:data
                              completion:^(NSError *error, id result) {
                                  selectProfileImage = result;
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      //抓取圖片
                                      NSString *urlString = [PHOTO_URL stringByAppendingPathComponent:selectProfileImage[0][@"image"]];
                                      NSURL *url = [NSURL URLWithString:urlString];
                                      [self.profileImageBtn loadImageWithURL:url];
                                      
                                      [self.profileView reloadInputViews];
                                  });
                                  
                              }];
        }
        
    }else {
            [_profileImageBtn setImage:nil forState:normal];
            _userNameLabel.text = @"";
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profilePhoto"];
            _settingsArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Log in", nil), NSLocalizedString(@"Settings", nil), nil];
            _profileArray[1] = _settingsArray;
            [_profileTableView reloadData];
    }
}

// Set Section title color
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:80.0/255.0 green:227.0/255.0 blue:194.0/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Set UIPickerView for profile photo and create a deal

- (IBAction)uploadProfilePhoto:(id)sender {
    [self whichOneIsSelected:@"profilePhotoBtn"];
}

-(void)whichOneIsSelected:(NSString*)btnName {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Upload photo from", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera whichBtn:btnName];
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:NSLocalizedString(@"Library", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary whichBtn:btnName];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:camera];
    [alert addAction:album];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
}


-(void)launchImagePickerWithSourceType:(UIImagePickerControllerSourceType)type whichBtn:(NSString*)btnName {
    // Check if source type is available or not
    if(![UIImagePickerController isSourceTypeAvailable:type]) {
        NSLog(@"Invalid Source Type");
        return;
    }
    
    _selectedBtnName = btnName;
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
    NSLog(@"info:%@",info.description);
    
    if ([type isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
        self.modifiedImage = [self modifyImage:originalImage];
        
        NSLog(@"Original: %@",originalImage.description);
        NSLog(@"Modified: %@",self.modifiedImage.description);
        
        NSData * originalJPGData = UIImageJPEGRepresentation(originalImage, 0.7);
        NSData * modifiedJPGData = UIImageJPEGRepresentation(self.modifiedImage, 0.7);
        
        
        if ([_selectedBtnName isEqualToString:@"profilePhotoBtn"]) {
            [self.profileImageBtn setImage:self.modifiedImage forState:normal];
            
            /*存profile至database start 2017.05.30*/
            
            [[NSUserDefaults standardUserDefaults] setObject:UIImageJPEGRepresentation(self.modifiedImage, 0.8) forKey:@"profilePhoto"];
            
            NSData *imageData = UIImageJPEGRepresentation(self.modifiedImage, 0.8);
            
            NSDictionary *parameters = @{@"username": [[NSUserDefaults standardUserDefaults] objectForKey:@"login"]};
            
            [comm updateImages:parameters :imageData];
            
            /*存profile至database end 2017.05.30*/
            
        } else if ([_selectedBtnName isEqualToString:@"createADealBtn"]) {
            CreateADealTableViewController * createADeal = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateADealTableViewController"];
            
            createADeal.deal = [[Deal alloc] init];
            createADeal.deal.coverPhoto = _modifiedImage;
            
            [self.navigationController pushViewController:createADeal animated:YES];
        }
        NSLog(@"Original JPG Size: %ld, Modified JPG Size: %ld",(unsigned long)originalJPGData.length,modifiedJPGData.length);
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_profileArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_profileArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[_profileArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSLog(@"cell.textLabel.text: %@", cell.textLabel.text);
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [_titleArray objectAtIndex:section];
            break;
        case 1:
            return [_titleArray objectAtIndex:section];
            break;
        case 2:
            return [_titleArray objectAtIndex:section];
            break;
        default:
            return nil;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login"] == nil) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Please log in", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *OK = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:OK];
                    [self presentViewController:alert animated:true completion:nil];
                } else {
                    [self whichOneIsSelected:@"createADealBtn"];
                }
            } else {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login"] == nil) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"Please log in", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *OK = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:OK];
                    [self presentViewController:alert animated:true completion:nil];
                } else {
                    DealsManagementTableViewController *managementvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DealsManagementTableViewController"];
                    [self showViewController:managementvc sender:nil];
                }
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                NSLog(@"cell.textlabel.text : %@",cell.textLabel.text);
                if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"Log out", nil)]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profilePhoto"];
                    [self viewDidAppear:NO];
                } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"Log in", nil)]) {
                    LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    [self showViewController:login sender:nil];
                }
            }
            break;
        default:
            break;
    }
}


/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                [self whichOneIsSelected:@"createADealBtn"];
            } else {
                DealsManagementTableViewController *managementvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DealsManagementTableViewController"];
                [self showViewController:managementvc sender:nil];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                
                NSLog(@"cell.textlabel.text : %@",cell.textLabel.text);
                if ([cell.textLabel.text isEqualToString:@"Log out"]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profilePhoto"];
                    [self viewDidAppear:NO];
                } else if ([cell.textLabel.text isEqualToString:@"Log in"]) {
                    LoginViewController * login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    [self showViewController:login sender:nil];
                }
            }
            break;
        default:
            break;
    }
}
*/
- (IBAction)editProfileBtnPressed:(UIButton *)sender {
    
    AccountViewController *accountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    
    accountVC.user.username = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    
    accountVC.selectProfile = selectProfileImage;
    
    [self showViewController:accountVC sender:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// SignUpViewController dismiss than ProfileViewController show up
- (IBAction)dofirst:(UIStoryboardSegue*)sender {
    
}

- (IBAction)goToProfile:(UIStoryboardSegue*)sender {
    
}
@end
