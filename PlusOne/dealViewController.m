//
//  dealViewController.m
//  buyer
//
//  Created by H.M.L on 2017/5/24.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "dealViewController.h"
#import "ServerCommunicator.h"
#import "JoinViewController.h"
#import "AdvanceImageView.h"
#import "AppDelegate.h"
#import "ChatBox.h"
#import "ChatManagerTableViewController.h"

@interface dealViewController ()
@property (weak, nonatomic) IBOutlet AdvanceImageView *picimage;
@property (weak, nonatomic) IBOutlet UILabel *titlename;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *ussername;
@property (weak, nonatomic) IBOutlet UILabel *endtime;
@property (weak, nonatomic) IBOutlet UITextView *shipping;
@property (weak, nonatomic) IBOutlet UITextView *payment;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *target;
@property (weak, nonatomic) IBOutlet UILabel *range1;
@property (weak, nonatomic) IBOutlet UILabel *range2;
@property (weak, nonatomic) IBOutlet UILabel *range3;
@property (weak, nonatomic) IBOutlet UILabel *targetborder;
@property (weak, nonatomic) IBOutlet AdvanceImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *productCount;
@property (weak, nonatomic) IBOutlet UILabel *productEndTime;
@end

@implementation dealViewController
{
    ServerCommunicator *comm;
    NSMutableArray *shippingArray;
    NSMutableArray *paymentArray;
    //ChatBox * chatBox;
    //ChatManagerTableViewController *chatManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    comm = [ServerCommunicator new];
    shippingArray = [NSMutableArray new];
    paymentArray = [NSMutableArray new];
    
    //chatBox = [ChatBox new];
    //chatManager = [ChatManagerTableViewController new];
    
    self.navigationItem.title = @"Join";
    self.titlename.text = self.filename[@"dealname"];
    self.price.text = [NSString stringWithFormat:@"NT %@",self.filename[@"range1_price"]];
    self.ussername.text = self.filename[@"uploadusername"];
    self.productEndTime.text = self.filename[@"endtime"];
    self.endtime.text = self.filename[@"endtime"];
    self.productCount.text = [NSString stringWithFormat:@"Total quantity : %@",self.filename[@"sum_count"]];
    
    //抓取圖片
    NSString * productImageString = [PHOTO_URL stringByAppendingPathComponent:self.filename[@"image"]];
    NSURL * productImage = [NSURL URLWithString:productImageString];
    [self.picimage loadImageWithURL:productImage];
    
    self.target.text = [NSString stringWithFormat:@"%@ ~ %@",self.filename[@"target_min"],self.filename[@"target_max"]];
    self.targetborder.layer.borderColor = [[UIColor grayColor] CGColor];
    self.targetborder.layer.borderWidth = 2.0;
    self.targetborder.layer.cornerRadius = 8.0;
    
    if([[NSString stringWithFormat:@"%@",self.filename[@"range1"]] isEqual: @"0"])
    {
        self.range1.hidden = YES;
    }
    else
    {
        self.range1.text = [NSString stringWithFormat:@"quantity %@  --> price %@ dollars",self.filename[@"range1"],self.filename[@"range1_price"]];
    }
    if([[NSString stringWithFormat:@"%@",self.filename[@"range2"]] isEqual: @"0"])
    {
        self.range2.hidden = YES;
    }
    else
    {
        self.range2.text = [NSString stringWithFormat:@"quantity %@ --> price %@ dollars",self.filename[@"range2"],self.filename[@"range2_price"]];
    }
    if([[NSString stringWithFormat:@"%@",self.filename[@"range3"]] isEqual: @"0"])
    {
        self.range3.hidden = YES;
    }
    else
    {
        self.range3.text = [NSString stringWithFormat:@"quantity %@ --> price %@ 元",self.filename[@"range3"],self.filename[@"range3_price"]];
    }
    
    //Save shipping methods
    if([[NSString stringWithFormat:@"%@",self.filename[@"paypal"]] isEqual: @"1"])
    {
        [shippingArray addObject:@"paypal"];
    }
    if([[NSString stringWithFormat:@"%@",self.filename[@"moneytransfer"]] isEqual:@"1"])
    {
        [shippingArray addObject:@"Money transfer"];
    }
    if([[NSString stringWithFormat:@"%@",self.filename[@"creditcard"]] isEqual:@"1"])
    {
        [shippingArray addObject:@"Credit card"];
    }
    if([[NSString stringWithFormat:@"%@",self.filename[@"paymentuponpickup"]] isEqual:@"1"])
    {
        [shippingArray addObject:@"Payment upon pickup"];
    }
    
    //Save payment methods
    if([[NSString stringWithFormat:@"%@",self.filename[@"express"]] isEqual:@"1"])
    {
        [paymentArray addObject:@"Express"];
    }
    if([[NSString stringWithFormat:@"%@",self.filename[@"ezship"]] isEqual:@"1"])
    {
        [paymentArray addObject:@"Ezship"];
    }
    
    for (NSString *item in shippingArray) {
        self.shipping.text = [NSString stringWithFormat:@"%@\n%@", item, self.shipping.text];
    }
    
    for(NSString *item in paymentArray){
        self.payment.text = [NSString stringWithFormat:@"%@\n%@", item, self.payment.text];
    }
    
    //self.shipping.text = self.filename[@"shipping"];
    self.shipping.layer.borderColor = [[UIColor grayColor] CGColor];
    self.shipping.layer.borderWidth = 2.0;
    self.shipping.layer.cornerRadius = 8.0;
    //self.payment.text = self.filename[@"payment"];
    self.payment.layer.borderColor = [[UIColor grayColor] CGColor];
    self.payment.layer.borderWidth = 2.0;
    self.payment.layer.cornerRadius = 8.0;
    self.descriptionLabel.text = self.filename[@"description"];
    self.descriptionLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    self.descriptionLabel.layer.borderWidth = 2.0;
    self.descriptionLabel.layer.cornerRadius = 8.0;
    
    // set the profile image into circle
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/ 2;
    self.profileImage.clipsToBounds = YES;
    
    // adding border to profile image
    self.profileImage.layer.borderWidth = 3.0f;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;

    //self.profileImage.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"image"]];
    
    //抓取圖片
    NSString * uploadImageString = [PHOTO_URL stringByAppendingPathComponent:self.filename[@"uploadusernameimage"]];
    NSURL * uploadImage = [NSURL URLWithString:uploadImageString];
    [self.profileImage loadImageWithURL:uploadImage];
    
}
- (IBAction)pressImageToChat:(id)sender {
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"login"] != self.filename[@"uploadusername"])
    {
        /*
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        UIViewController *rootController = controllers[0]; // 保留 rootController
        [controllers removeAllObjects]; // 移除全部
        [controllers addObject:rootController]; // 先將 rootController 放到 index 0
        ChatManagerTableViewController *chatManager = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatManagerTableViewController"];
        [controllers addObject:chatManager]; // 建立並放入 D 在 index 1
        ChatBox *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"chatbox"];
        [controllers addObject:chatVC];
        
        self.tabBarController.selectedIndex = 3;
        
        chatVC.sender = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
        chatVC.receiver = self.filename[@"uploadusername"];
        
        [[self navigationController] setViewControllers:controllers animated:YES];
         */
        
        ChatBox *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"chatbox"];
        
        chatVC.sender = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
        chatVC.receiver = self.filename[@"uploadusername"];
        
        UINavigationController *navi = self.tabBarController.viewControllers[3];
        self.tabBarController.selectedIndex = 3;
        [navi pushViewController:chatVC animated:YES];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    JoinViewController * joinVC = segue.destinationViewController;
    
    joinVC.filename = self.filename;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
