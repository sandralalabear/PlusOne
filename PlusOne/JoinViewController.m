//
//  JoinViewController.m
//  buyer
//
//  Created by H.M.L on 2017/5/25.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "JoinViewController.h"
#import "ServerCommunicator.h"
#import "AppDelegate.h"
#import "AdvanceImageView.h"

@interface JoinViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet AdvanceImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productCount;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UITextField *shippingTextField;
@property (weak, nonatomic) IBOutlet UITextField *paymentTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@end

@implementation JoinViewController
{
    ServerCommunicator *comm;
    int count;
    NSMutableArray *shippingItem;
    NSMutableArray *paymentItem;
    UIPickerView *shippingPV;
    UIPickerView *paymentPV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Join Confirm";
    comm = [ServerCommunicator new];
    shippingItem = [NSMutableArray new];
    paymentItem = [NSMutableArray new];
    count = 1;
    self.totalPrice.text = [NSString stringWithFormat:@"NT %@",self.filename[@"range1_price"]];
    
    //抓取圖片
    NSString * urlString = [PHOTO_URL stringByAppendingPathComponent:self.filename[@"image"]];
    NSURL * url = [NSURL URLWithString:urlString];
    [self.productImage loadImageWithURL:url];
    
    self.productCount.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.productCount.layer.borderWidth = 1.0;
    self.productPrice.text = [NSString stringWithFormat:@"NT %@",self.filename[@"range1_price"]];
    self.productName.text = self.filename[@"dealname"];
    
    //shippingItem = @[@"[---請選擇---]",@"面交",@"歐付寶(NT60)"];
    //paymentItem = @[@"[---請選擇---]",@"郵局",@"歐付寶線上刷卡"];
    
    [shippingItem addObject:@"[--Choose--]"];
    [paymentItem addObject:@"[--Choose--]"];
    
    //Save shipping methods
    if([[NSString stringWithFormat:@"%@",self.filename[@"paypal"]] isEqual:@"1"])
    {
        [paymentItem addObject:@"paypal"];
    }
    if([[NSString stringWithFormat:@"%@",self.filename[@"moneytransfer"]] isEqual:@"1"])
    {
        [paymentItem addObject:@"Money transfer"];
    }
    if([[NSString stringWithFormat:@"%@",self.filename[@"creditcard"]] isEqual:@"1"])
    {
        [paymentItem addObject:@"Credit card"];
    }
    if([[NSString stringWithFormat:@"%@",self.filename[@"paymentuponpickup"]] isEqual:@"1"])
    {
        [paymentItem addObject:@"Payment upon pickup"];
    }
    
    //Save payment methods
    if([[NSString stringWithFormat:@"%@",self.filename[@"express"]] isEqual:@"1"])
    {
        [shippingItem addObject:@"Express"];
    }
    if([[NSString stringWithFormat:@"%@",self.filename[@"ezship"]] isEqual:@"1"])
    {
        [shippingItem addObject:@"Ezship"];
    }
    
    shippingPV = [UIPickerView new];
    paymentPV = [UIPickerView new];
    shippingPV.delegate = self;
    paymentPV.delegate = self;
    shippingPV.dataSource = self;
    paymentPV.dataSource = self;
    self.shippingTextField.inputView = shippingPV;
    self.paymentTextField.inputView = paymentPV;
    self.shippingTextField.text = shippingItem[0];
    self.paymentTextField.text = paymentItem[0];
    self.shippingTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.paymentTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void) cancelKeyboard
{
    [self.shippingTextField resignFirstResponder];
    [self.paymentTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)minusBtn:(id)sender {
    
    if(count <= 0)
    {
        count = 0;
    }
    else
    {
        count--;
    }
    self.productCount.text = [NSString stringWithFormat:@"%d",count];
    //self.productPrice.text = [NSString stringWithFormat:@"NT %d",[self.filename[@"range1_price"] intValue] * count];
    
    self.totalPrice.text = [NSString stringWithFormat:@"NT %d",[self.filename[@"range1_price"] intValue] * count];
}

- (IBAction)plusBtn:(id)sender {
    
    if(count == [self.filename[@"target_max"] intValue])
    {
        count = [self.filename[@"target_max"] intValue];
    }
    else
    {
        count++;
    }
    
    self.productCount.text = [NSString stringWithFormat:@"%d",count];
    //self.productPrice.text = [NSString stringWithFormat:@"NT %d",[self.filename[@"range1_price"] intValue] * count];
    
    self.totalPrice.text = [NSString stringWithFormat:@"NT %d",[self.filename[@"range1_price"] intValue] * count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == shippingPV)
    {
        return shippingItem.count;
    }
    else
    {
        return paymentItem.count;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(pickerView == shippingPV)
    {
        self.shippingTextField.text = shippingItem[row];
        self.totalPrice.text = [NSString stringWithFormat:@"NT %d",[self.filename[@"range1_price"] intValue] * count];
    }
    else
    {
        self.paymentTextField.text = paymentItem[row];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == shippingPV)
    {
        return shippingItem[row];
    }
    else
    {
        return paymentItem[row];
    }
}

- (IBAction)doneBtn:(id)sender {
    
    if([self.shippingTextField.text isEqual: @"[--Choose--]"] || [self.paymentTextField.text isEqual: @"[--Choose--]"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"資料尚未選擇" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([self.shippingTextField.text isEqual: @"[--Choose--]"])
            {
                self.shippingTextField.backgroundColor = [UIColor yellowColor];
            }
            else
            {
                self.shippingTextField.backgroundColor = [UIColor whiteColor];
            }
            if([self.paymentTextField.text isEqual: @"[--Choose--]"])
            {
                self.paymentTextField.backgroundColor = [UIColor yellowColor];
            }
            else
            {
                self.paymentTextField.backgroundColor = [UIColor whiteColor];
            }
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSDictionary *parameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"],
                                     @"id":self.filename[@"id"],
                                     @"count":[NSString stringWithFormat:@"%d",count],
                                     @"shipping":self.shippingTextField.text,
                                     @"payment":self.paymentTextField.text};
        [comm doPostWithURLString:JOINED_INSERT_URL
                       parameters:parameters
                             data:nil
                       completion:^(NSError *error, id result) {
                       }];
    }
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
