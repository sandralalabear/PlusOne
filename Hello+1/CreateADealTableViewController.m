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


static NSString *DatePickerTableViewCellIdentifier = @"DatePickerTableViewCell";
static NSString *MinAndMaxSliderTableViewCellIdentifier = @"MinAndMaxSliderTableViewCell";

@interface CreateADealTableViewController () <UIImagePickerControllerDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UITextFieldDelegate>
    
    @property (nonatomic,strong) NSMutableArray *titleArray;
    @property (nonatomic,strong) NSMutableArray *createADealArray;
    @property (nonatomic,strong) NSArray *dealPhotos;
    @property (nonatomic,strong) NSArray *dealNameandDescription;
    @property (nonatomic,strong) NSArray *condition;
    
    @property (nonatomic,strong) NSArray *shipping;
    @property (nonatomic,strong) NSArray *payment;
    
    @property (nonatomic,strong) UIImage *modifiedImage;
    
    @property (nonatomic,strong) NSString *dealNameText;
    @property (nonatomic,strong) UITextView *dealDescriptionTextView;
    @property (nonatomic,strong) UIToolbar *keyboardDoneToolBar;
    
    @property (nonatomic,strong) NSDate *endingDate;
    @property (nonatomic,strong) NSDateFormatter *endingDateFormatter;
    @property (nonatomic,strong) UIDatePicker *datePicker;
    @property (nonatomic,strong) UIToolbar *datePickerToolbar;
    
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
    // [self configureLabelSlider];
    
    [self addDoneToolBarToKeyboard:_dealDescriptionTextView];
    [self createEndingDateFormatter];
    [self loadDealData];
    
}
    
- (void)viewDidUnload {
    [super viewDidUnload];
}
    
- (void) viewDidAppear: (BOOL)animated {
    [super viewWillAppear:animated];
    [self updateSliderLabels];
}
    
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
    
    // when deal saved then pass all datas to next page
-(void)savePressed {
    //...
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
    
#pragma mark - Set Textfield keyboard dissmiss
-(void)doneButtonClickedDismissKeyboard {
    [self.view endEditing:YES];
}
    
#pragma mark - Set textview placeholder and done button for keyboard
    
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Input your deal description here..."]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.text.length < 1){
        textView.text = @"Input your deal description here...";
        textView.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:0.9];
    }
}
    
-(void)addDoneToolBarToKeyboard:(UITextView *)textView {
    _keyboardDoneToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)];

    [_keyboardDoneToolBar sizeToFit];
    [_keyboardDoneToolBar setItems:[[NSArray alloc] initWithObjects: extraSpace, doneButton, nil]];
}
    
#pragma mark - Date picker
    
-(void) configureEndingDatePicker {
    // Initialise UIDatePicker
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    //[_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged]; // method to respond to changes in the picker value
    
    // Setup UIToolbar for UIDatePicker
    _datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissPicker)]; // method to dismiss the picker when the "Done" button is pressed
    [_datePickerToolbar setItems:[[NSArray alloc] initWithObjects: extraSpace, doneButton, nil]];
}
    
- (void)loadDealData {
    // ...
    self.endingDate = [NSDate date];
}
- (void)createEndingDateFormatter {
    self.endingDateFormatter = [[NSDateFormatter alloc] init];
    [self.endingDateFormatter setDateFormat:@"yyyy/MM/dd"];
}
- (void)dismissPicker {
    _endingDate = _datePicker.date;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    DatePickerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.endingDateTextField.text = [_endingDateFormatter stringFromDate:_endingDate];
    [self.view endEditing:YES];
}
    
#pragma mark - Textfield Keyboard dismiss funciton with return type done
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
    
    
#pragma mark - Label Slider
    - (void) configureLabelSlider: (NMRangeSlider *)labelSlider {
        
        labelSlider.minimumValue = 0;
        labelSlider.maximumValue = 500;
        
        labelSlider.lowerValue = 0;
        labelSlider.upperValue = 500;
        
        labelSlider.minimumRange = 1;
    }
    
    - (void) updateSliderLabels {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        MinAndMaxSliderTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        // Get the center point of the slider handles and use this to arrange other subviews
        CGPoint lowerCenter;
        lowerCenter.x = (cell.labelSlider.lowerCenter.x + cell.labelSlider.frame.origin.x);
        lowerCenter.y = (cell.labelSlider.center.y - 30.0f);
        cell.lowerLabel.center = lowerCenter;
        cell.lowerLabel.text = [NSString stringWithFormat:@"%d", (int) cell.labelSlider.lowerValue];
        
        CGPoint upperCenter;
        upperCenter.x = (cell.labelSlider.upperCenter.x + cell.labelSlider.frame.origin.x);
        upperCenter.y = (cell.labelSlider.center.y - 30.0f);
        cell.upperLabel.center = upperCenter;
        cell.upperLabel.text = [NSString stringWithFormat:@"%d", (int)cell.labelSlider.upperValue];
        NSLog(@"i'm heredsfsdf , %f", cell.labelSlider.center.y);
        NSLog(@"%f", cell.labelSlider.frame.origin.x);
        NSLog(@"i'm here , %@",[NSString stringWithFormat:@"%d", (int) cell.labelSlider.lowerValue]);
    }
    
    // Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender {
    [self updateSliderLabels];
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
    return [[_createADealArray objectAtIndex:section] count];
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
                cell.dealNameTextField.delegate = self;
                cell.dealNameTextField.returnKeyType = UIReturnKeyDone;
                cell.dealNameTextField.text = _dealNameText;
                cellToReturn = cell;
            } else {
                // Set Deal description in textView
                static NSString *cellIdentifier = @"DealDescriptionTableViewCell";
                DealDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(cell == nil) {
                    cell = [[DealDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                cell.dealDescriptionTextView.delegate = self;
                cell.dealDescriptionTextView.inputAccessoryView = _keyboardDoneToolBar;
                cell.dealDescriptionTextView.text = @"Input your deal description here...";
                cell.dealDescriptionTextView.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:0.8];

                _dealDescriptionTextView = cell.dealDescriptionTextView;
                
                cellToReturn = cell;
            }
            break;
        }
        
        case 2:
        {
            if (indexPath.row == 0) {
                // Set deal ending date
                DatePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DatePickerTableViewCellIdentifier];
                if (cell == nil) {
                    cell = [[DatePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DatePickerTableViewCellIdentifier];
                }
                
                // Set UITextfield's inputView as UIDatePicker
                cell.endingDateTextField.inputView = _datePicker;
                // Set UITextfield's inputAccessoryView as UIToolbar
                cell.endingDateTextField.inputAccessoryView = _datePickerToolbar;
                cell.endingDateTextField.text = [_endingDateFormatter stringFromDate:_endingDate];
                cellToReturn = cell;
                
            } else if (indexPath.row == 1) {
                // Set min and max slider
                MinAndMaxSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MinAndMaxSliderTableViewCellIdentifier forIndexPath:indexPath];
                [self configureLabelSlider:cell.labelSlider];
                cellToReturn = cell;
            } else {
                //...
                
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
