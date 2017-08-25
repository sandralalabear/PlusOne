//
//  AccountViewController.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/25.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "AccountViewController.h"
#import "UIView+XLFormAdditions.h"
#import "NSObject+XLFormAdditions.h"
#import "FloatLabeledTextFieldCell.h"



#pragma mark - NSValueTransformer

@interface NSArrayValueTrasformer : NSValueTransformer
    @end

@implementation NSArrayValueTrasformer
    
+ (Class)transformedValueClass
    {
        return [NSString class];
        
    }
    
+ (BOOL)allowsReverseTransformation
    {
        return NO;
    }
    
- (id)transformedValue:(id)value
    {
        if (!value) return nil;
        if ([value isKindOfClass:[NSArray class]]){
            NSArray * array = (NSArray *)value;
            return [NSString stringWithFormat:@"%@ Item%@", @(array.count), array.count > 1 ? @"s" : @""];
        }
        if ([value isKindOfClass:[NSString class]])
        {
            return [NSString stringWithFormat:@"%@ - ;) - Transformed", value];
        }
        return nil;
    }
    
    @end

#pragma mark - AccountViewController


NSString *const Username = @"Username";
NSString *const Password = @"Password";
NSString *const Name = @"Name";
NSString *const Email = @"Email";
NSString *const Address = @"Address";
NSString *const Birthday = @"Birthday";
NSString *const PaymentMethod = @"Payment Methods";
NSString *const ShippingMethod = @"Shipping Methods";
NSString *userObjectKey = @"user";

@interface AccountViewController ()
    
@end



@implementation AccountViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
}
    
-(void)savePressed:(UIBarButtonItem *)button {
    
    NSDictionary *formValues = [self formValues];
    
    _user.password = formValues[Password];
    
    _user.name = formValues[Name];
    NSLog(@"_user.name: %@",_user.name);
    _user.email = formValues[Email];
    NSLog(@"_user.email: %@", _user.email);
    _user.address = formValues[Address];
    _user.birthday = formValues[Birthday];
    _user.paymentMethod = formValues[PaymentMethod];
    _user.shippingMethod = formValues[ShippingMethod];
    
    [_userStore save:_user];
    
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}
    
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}
    
- (void)initializeForm {
    
    // TODO find a better place, any method called before this method, to load the data
    _userStore = [UserStore new];
    
     NSString *username = [NSString stringWithFormat: @"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"login"]];
    NSLog(@"initalizeForm username: %@", username);
    
    _user = [_userStore getByUsername:username];

    
    // Implementation details covered in the next section.
    // Initial form-section-row
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"Edit Profile"] ; //Create a form with title
    XLFormSectionDescriptor *section;  //Create a section
    XLFormRowDescriptor *row; //Create a cell
    
    
    // First section - Login Account
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Login Account"];
    [form addFormSection:section];
    
    // Username (load data from database and unchangeable)
    row = [XLFormRowDescriptor formRowDescriptorWithTag:Username rowType:XLFormRowDescriptorTypeText title:@"Username"];
    row.required = YES;
    row.value = username;
    NSLog(@"_user,username: %@", _user.username);
    [section addFormRow:row];
    // Password
    row = [XLFormRowDescriptor formRowDescriptorWithTag:Password rowType:XLFormRowDescriptorTypePassword title:@"Password"];
    row.value = _user.password;
    [section addFormRow:row];
    
    
    // Second section - General Information
    section = [XLFormSectionDescriptor formSectionWithTitle:@"General Information"];
    [form addFormSection:section];
    
    // Name for formal use
    row = [XLFormRowDescriptor formRowDescriptorWithTag:Name rowType:XLFormRowDescriptorTypeFloatLabeledTextField title:@"Name"];
    row.value = _user.name;
    [section addFormRow:row];
    // Email
    row = [XLFormRowDescriptor formRowDescriptorWithTag:Email rowType:XLFormRowDescriptorTypeFloatLabeledTextField title:@"Email"];
    row.value = _user.email;
    [section addFormRow:row];
    // Address
    row = [XLFormRowDescriptor formRowDescriptorWithTag:Address rowType:XLFormRowDescriptorTypeFloatLabeledTextField title:@"Address"];
    row.value = _user.address;
    [section addFormRow:row];
    // Birthday
    row = [XLFormRowDescriptor formRowDescriptorWithTag:Birthday rowType:XLFormRowDescriptorTypeDateInline title:@"Birthday"];
    row.value = _user.birthday;
    row.value = [NSDate new];
    [row.cellConfigAtConfigure setObject:[NSLocale localeWithLocaleIdentifier:@"US_en" ] forKey:@"locale"];
    [section addFormRow:row];
    
    
    // Third Section - Host Settings
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Host Settings"];
    [form addFormSection:section];
    
    // Payment Methods Seletors
    row = [XLFormRowDescriptor formRowDescriptorWithTag:PaymentMethod rowType:XLFormRowDescriptorTypeMultipleSelector title:@"Payment Methods"];
    row.selectorOptions = @[@"Paypal",@"Money transfer",@"Credit card", @"Payment upon pickup"];
    row.value = @[@"Paypal",@"Money transfer",@"Credit card", @"Payment upon pickup"];
    row.valueTransformer = [NSArrayValueTrasformer class];
    [section addFormRow:row];
    // Shipping Methods Seletors
    row = [XLFormRowDescriptor formRowDescriptorWithTag:ShippingMethod rowType:XLFormRowDescriptorTypeMultipleSelector title:@"Shipping Methods"];
    row.selectorOptions = @[@"Express",@"Payment upon pickup",@"Ezship"];
    row.value = @[@"Express",@"Payment upon pickup",@"Ezship"];
    row.valueTransformer = [NSArrayValueTrasformer class];
    [section addFormRow:row];
    
    self.form = form;
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
