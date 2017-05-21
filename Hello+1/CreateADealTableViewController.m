//
//  CreateADealTableViewController.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/11.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "CreateADealTableViewController.h"
#import "CoverPhotoTableViewCell.h"
#import "CoverPhotoCollectionViewCell.h"
#import "DealDescriptionTableViewCell.h"
#import "DealNameAndDescriptionTableViewCell.h"
#import "DatePickerTableViewCell.h"
#import "MinAndMaxSliderTableViewCell.h"
#import "NMRangeSlider.h"
#import <MobileCoreServices/MobileCoreServices.h>




@interface CreateADealTableViewController () <UIImagePickerControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSMutableArray * titleArray;
@property (nonatomic,strong) NSMutableArray * createADealArray;
@property (nonatomic,strong) NSArray * dealPhotos;
@property (nonatomic,strong) NSArray * dealNameandDescription;
@property (nonatomic,strong) NSArray * condition;
//@property (nonatomic,strong) NSArray * dealDescription;
@property (nonatomic,strong) NSArray * shipping;
@property (nonatomic,strong) NSArray * payment;

@property (nonatomic,strong) UIImage * modifiedImage;
@property (nonatomic,strong) NSString *dealNameText;
@property (nonatomic,strong) NSString *dealDescriptionText;


@property (strong, nonatomic) UIDatePicker * datePicker;
@property (strong, nonatomic) UIToolbar * datePickerToolbar;

@property (nonatomic,strong) NMRangeSlider *labelSlider;
@property (assign, nonatomic) CGPoint lowerCenter;
@property (assign, nonatomic) CGPoint upperCenter;
@property (nonatomic,strong) UILabel *lowerLabel;
@property (nonatomic,strong) UILabel *upperLabel;

@end

@implementation CreateADealTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set navigation title and create right bar button item save
    self.navigationItem.title = @"Create a deal";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
    
    // Initialize arrays in create a deal tableView array
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"Deal photos",@"Deal name and Description",@"Condition",@"Shipping",@"Payment", nil]; 
    _dealPhotos = [[NSArray alloc] initWithObjects:@"coverPhoto", nil];
    _dealNameandDescription = [[NSArray alloc] initWithObjects:@"dealName",@"dealDescription", nil];
    _condition = [[NSArray alloc] initWithObjects:@"Ending date",@"Set min quantity and max quantity", nil];
    //_dealDescription = [[NSArray alloc] initWithObjects:@"dealDescription", nil];
    _shipping = [[NSArray alloc] initWithObjects:@"shipping", nil];
    _payment = [[NSArray alloc] initWithObjects:@"payment", nil];
    
    _createADealArray = [[NSMutableArray alloc] initWithObjects:_dealPhotos,_dealNameandDescription,_condition, nil];
    //_createADealArray = [[NSMutableArray alloc] initWithObjects:_dealPhotos,_dealName,_condition,_dealDescription,_shipping,_payment, nil];
    
    
    // Set ending date picker
    [self configureEndingDatePicker];
    // Set min and max slider
    [self configureLabelSlider];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateSliderLabels];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// when deal saved then pass all datas to next pagg
-(void)savePressed {
    //...
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Ending date picker

-(void) configureEndingDatePicker {
    // Initialise UIDatePicker
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged]; // method to respond to changes in the picker value
    
    // Setup UIToolbar for UIDatePicker
    _datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [_datePickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissPicker:)]; // method to dismiss the picker when the "Done" button is pressed
    [_datePickerToolbar setItems:[[NSArray alloc] initWithObjects: extraSpace, doneButton, nil]];
}

- (void) datePickerValueChanged:(id) sender {
    NSDate *selectedDate = _datePicker.date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterLongStyle];
    [_endingDateTextField setText:[df stringFromDate:selectedDate]];
}

-(void)dismissPicker:(UITextView *)sender{
    [_endingDateTextField resignFirstResponder];
}



#pragma mark - Label  Slider

- (void) configureLabelSlider
{
    self.labelSlider.minimumValue = 0;
    self.labelSlider.maximumValue = 100;
    
    self.labelSlider.lowerValue = 0;
    self.labelSlider.upperValue = 100;
    
    self.labelSlider.minimumRange = 10;
}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
}

- (void) updateSliderLabels
{
    // Get the center point of the slider handles and use this to arrange other subviews
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
    lowerCenter.y = (self.labelSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
    upperCenter.y = (self.labelSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.upperValue];
}



#pragma mark - Table view data source

// Set Section title color
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:80.0/255.0 green:227.0/255.0 blue:194.0/255.0 alpha:1.0]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_createADealArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection:%ld", section);
    
    return [[_createADealArray objectAtIndex:section] count];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellToReturn=nil;
    
    // Configure the cells
    switch (indexPath.section) {
        case 0:
        {
            // Set cover photo here
            static NSString *cellIdentifier = @"CoverPhotoCell";
            CoverPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cell == nil) {
                cell = [[CoverPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.clview.delegate = self;
            cell.clview.dataSource = self;
            cell.clview.allowsMultipleSelection = YES;
            
            cellToReturn = cell;
            break;
        }
        case 1:
        {
            if (indexPath.row == 0) {
                // Set Deal name here
                static NSString *cellIdentifier = @"DealNameAndDescriptionTableViewCell";
                DealNameAndDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(cell == nil) {
                    cell = [[DealNameAndDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                cell.dealNameTextField.text = _dealNameText;
                cellToReturn = cell;
            } else {
                // Set Deal description in textView
                static NSString *cellIdentifier = @"DealDescriptionTableViewCell";
                DealDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(cell == nil) {
                    cell = [[DealDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                cell.dealDescriptionTextView.text = _dealDescriptionText;
                cellToReturn = cell;
            }
            break;
        }

        case 2:
        {
            if (indexPath.row == 0) {
                // Set deal ending date
                static NSString *cellIdentifier = @"DatePickerTableViewCell";
                DatePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[DatePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
            
                // Set UITextfield's inputView as UIDatePicker
                cell.endingDateTextField.inputView = _datePicker;
                // Set UITextfield's inputAccessoryView as UIToolbar
                cell.endingDateTextField.inputAccessoryView = _datePickerToolbar;
                cell.endingDateTextField.text = _endingDateTextField.text;
                cellToReturn = cell;
            } else {
                // Set min and max slider
                static NSString *cellIdentifier = @"MinAndMaxSliderTableViewCell";
                MinAndMaxSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[MinAndMaxSliderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                cell.labelSlider = _labelSlider;
                cell.lowerLabel.text = _lowerLabel.text;
                cell.upperLabel.text = _upperLabel.text;
                cellToReturn = cell;
            }
            break;
        }
        case 3:
        {
            
            break;
        }
        case 4:
            // shipping picker
            break;
        case 5:
            // payment picker
            break;  
        default:
            break;
    }
    return cellToReturn;
}


// Set section title with titleArray
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
        case 3:
            return [_titleArray objectAtIndex:section];
            break;
        case 4:
            return [_titleArray objectAtIndex:section];
            break;
        case 5:
            return [_titleArray objectAtIndex:section];
            break;
        default:
            return nil;
            break;
    }
}



# pragma mark - Collection view of deal photo

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CoverPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CoverPhotoCell" forIndexPath:indexPath];
    
    // Configure the cell
    cell.coverPhotoImage.image = _coverPhoto; /*接前面的照片*/

    return cell;
}

# pragma mark - Deal photo and Imagepickerdelegate related

- (IBAction)addPhotoBtnPressed:(UIButton *)sender {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Upload more deal photos from" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
    NSLog(@"info:%@",info.description);
    
    if ([type isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
        self.modifiedImage = [self modifyImage:originalImage];
        
        NSLog(@"Original: %@",originalImage.description);
        NSLog(@"Modified: %@",self.modifiedImage.description);
        
        NSData * originalJPGData = UIImageJPEGRepresentation(originalImage, 0.7);
        NSData * modifiedJPGData = UIImageJPEGRepresentation(self.modifiedImage, 0.7);
        
//        // 這裡要接收user 新增的照片用collectionview顯示出來
        
        
//        if ([_selectedBtnName isEqualToString:@"profilePhotoBtn"]) {
//            [self.profileImageBtn setImage:self.modifiedImage forState:normal];
//        } else if ([_selectedBtnName isEqualToString:@"createADealBtn"]) {
//            CreateADealTableViewController * createADeal = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateADealTableViewController"];
//            createADeal.coverPhoto =_modifiedImage;
//            [self.navigationController pushViewController:createADeal animated:YES];
//        }
//        
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


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    
//    switch (indexPath.section) {
//        case 0:
//            if (indexPath.row == 0) {
//                
//            }
//            break;
//        case 1:
//            if (indexPath.row == 0) {
//                
//            }
//            break;
//        default:
//            break;
//    }
//    
//    NSLog(@"%ld",(long)indexPath.section);
//    NSLog(@"%ld",(long)indexPath.row);

//}


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
