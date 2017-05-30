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

@interface ProfileTableViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) NSMutableArray * profileArray;
@property (weak, nonatomic) IBOutlet UITableView *profilePageTableView;
@property (nonatomic,strong) NSArray * hostArray;
@property (nonatomic,strong) NSArray * settingsArray;
@property (nonatomic,strong) NSArray * aboutUs;
@property (nonatomic,strong) NSMutableArray * titleArray;
@property (nonatomic,strong) UIImage * modifiedImage;
@property (nonatomic,strong) NSString * selectedBtnName;

@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIButton *profileImageBtn;




@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set navigation title
    self.navigationItem.title = @"Profile";
    
    // initialize arrays in profile array
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"Host",@"Settings",@"About us", nil];
    _hostArray = [[NSArray alloc] initWithObjects:@"Create a deal",@"Deals management",@"Payment settings",@"Shipping settings",nil];
    _settingsArray = [[NSArray alloc] initWithObjects:@"Log in",@"Settings", nil];
    _aboutUs = [[NSArray alloc] initWithObjects:@"Give us feedback", nil];
    
    _profileArray = [[NSMutableArray alloc] initWithObjects:_hostArray,_settingsArray,_aboutUs, nil];
    
    // set the profile image into circle
    self.profileImageBtn.layer.cornerRadius = self.profileImageBtn.frame.size.width/ 2;
    self.profileImageBtn.clipsToBounds = YES;
    
    // adding border to profile image
    self.profileImageBtn.layer.borderWidth = 3.0f;
    self.profileImageBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
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
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Upload photo from" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera whichBtn:btnName];
    }];
    UIAlertAction * album = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary whichBtn:btnName];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:nil];
    
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
   // cell.accessoryType = UITableViewCellAccessoryNone;
    
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
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                [self whichOneIsSelected:@"createADealBtn"];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                LoginViewController * login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self showViewController:login sender:nil];
                //[self presentViewController:login animated:true completion:nil];
            }
            break;
        default:
            break;
    }
    
    NSLog(@"%ld",(long)indexPath.section);
    NSLog(@"%ld",(long)indexPath.row);
}

- (IBAction)editProfileBtnPressed:(UIButton *)sender {
    AccountViewController *accountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    // TODO accountVC.username = ...
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

@end
