//
//  JoinDetailViewController.m
//  Hello+1
//
//  Created by H.M.L on 2017/5/31.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "JoinDetailViewController.h"
#import "ServerCommunicator.h"
#import "LDProgressView.h"
#import "AdvanceImageView.h"
#import "AdvanceImageView.h"
#import "AppDelegate.h"
#import "joinedAllTableViewCell.h"

@interface JoinDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet AdvanceImageView *joinedImage;
@property (weak, nonatomic) IBOutlet UILabel *joinedDealName;
@property (weak, nonatomic) IBOutlet UILabel *joinedPrice;
@property (weak, nonatomic) IBOutlet UILabel *joinedCount;
@property (weak, nonatomic) IBOutlet UILabel *joinedEndTime;
@property (weak, nonatomic) IBOutlet UITextView *joinedPayment;
@property (weak, nonatomic) IBOutlet UITextView *joinedShipping;
@property (weak, nonatomic) IBOutlet UITableView *joinedAllTableView;

@end

@implementation JoinDetailViewController
{
    ServerCommunicator *comm;
    NSMutableArray *selectAllItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
    selectAllItem = [NSMutableArray new];
    
    NSDictionary *parametersID = @{@"id":self.filename[@"id"]};
    
    [comm doPostWithURLString:JOINED_SELECT_ALL_URL
                   parameters:parametersID
                         data:nil
                   completion:^(NSError *error, id result) {
                       selectAllItem = result;
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [self.joinedAllTableView reloadData];
                       });
                   }];
    
    self.joinedAllTableView.delegate = self;
    self.joinedAllTableView.dataSource = self;
    
    self.navigationItem.title = @"Joined details";
    
    //抓取圖片
    NSString * urlString = [PHOTO_URL stringByAppendingPathComponent:self.filename[@"pics"]];
    NSURL * url = [NSURL URLWithString:urlString];
    [self.joinedImage loadImageWithURL:url];
    
    self.joinedDealName.text = self.filename[@"dealname"];
    self.joinedPrice.text = [NSString stringWithFormat:@"NT %@ 元",self.filename[@"range1_price"]];
    self.joinedCount.text = [NSString stringWithFormat:@"Total quantity : %@",self.filename[@"sum_count"]];
    self.joinedEndTime.text = [NSString stringWithFormat:@"%@",self.filename[@"endtime"]];
    self.joinedPayment.text = self.filename[@"joinedpayment"];
    self.joinedShipping.text = self.filename[@"joinedshipping"];
    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 258, 50, 35)];
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(110, 258, 50, 35)];
    self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(180, 258, 50, 35)];
    self.label4 = [[UILabel alloc] initWithFrame:CGRectMake(250, 258, 50, 35)];
    self.label5 = [[UILabel alloc] initWithFrame:CGRectMake(320, 258, 50, 35)];
    
    self.label1.text = @"合購中";
    self.label2.text = @"已成團";
    self.label3.text = @"已付款";
    self.label4.text = @"已出貨";
    self.label5.text = @"已取貨";
    
    self.label1.textColor = [UIColor lightGrayColor];
    self.label2.textColor = [UIColor lightGrayColor];
    self.label3.textColor = [UIColor lightGrayColor];
    self.label4.textColor = [UIColor lightGrayColor];
    self.label5.textColor = [UIColor lightGrayColor];
    
    self.label1.font = [UIFont systemFontOfSize:15.0];
    self.label2.font = [UIFont systemFontOfSize:15.0];
    self.label3.font = [UIFont systemFontOfSize:15.0];
    self.label4.font = [UIFont systemFontOfSize:15.0];
    self.label5.font = [UIFont systemFontOfSize:15.0];
    
    // flat, green, no text, progress inset, outer stroke, solid
    self.progressView = [[LDProgressView alloc] init];
    self.progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 240, self.view.frame.size.width-40, 22)];
    self.progressView.color = [UIColor colorWithRed:0.00f green:0.64f blue:0.00f alpha:1.00f];
    self.progressView.flat = @YES;
    
    if([self.filename[@"sum_count"] intValue] >= [self.filename[@"target_min"] intValue])
    {
        self.progressView.progress = 0.40;
        self.label2.textColor = [UIColor orangeColor];
    }
    else
    {
        self.progressView.progress = 0.20;
        self.label1.textColor = [UIColor orangeColor];
    }

    self.progressView.animate = @YES;
    self.progressView.showText = @NO;
    self.progressView.showStroke = @NO;
    self.progressView.progressInset = @5;
    self.progressView.showBackground = @NO;
    self.progressView.outerStrokeWidth = @3;
    self.progressView.type = LDProgressSolid;
    [self.view addSubview:self.progressView];
    
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.label3];
    [self.view addSubview:self.label4];
    [self.view addSubview:self.label5];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        NSLog(@"selectAllItem,%@",selectAllItem);
        
        int count = 0;
        
        for(int i = 0 ; i < selectAllItem.count ; i++)
        {
            if(selectAllItem[i][@"buyer"] == [[NSUserDefaults standardUserDefaults] objectForKey:@"login"])
            {
                count++;
            }
        }
        
        return count;
        
        //return selectAllItem.count;
    }
    else
    {
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Activity";
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    joinedAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"joinedAllCell" forIndexPath:indexPath];
    
    if(indexPath.section == 1)
    {
        //joinedAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"joinedAllCell" forIndexPath:indexPath];
        
        cell.joinedAllUsername.text = [NSString stringWithFormat:@"%@",self.filename[@"buyer"]];
        cell.joinedAllCount.text = [NSString stringWithFormat:@"%@",self.filename[@"count"]];
        cell.joinedtime.text = self.filename[@"joinedtime"];
        
        //抓取圖片
        NSString * urlStringAll = [PHOTO_URL stringByAppendingPathComponent:self.filename[@"image"]];
        NSURL * urlAll = [NSURL URLWithString:urlStringAll];
        [cell.joinedAllImage loadImageWithURL:urlAll];
        
        // set the profile image into circle
        cell.joinedAllImage.layer.cornerRadius = cell.joinedAllImage.frame.size.width/ 2;
        cell.joinedAllImage.clipsToBounds = YES;
        
        // adding border to profile image
        cell.joinedAllImage.layer.borderWidth = 3.0f;
        cell.joinedAllImage.layer.borderColor = [UIColor whiteColor].CGColor;
        
        return cell;
    }
    
    return cell;
}

/*
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    joinedAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"joinedAllCell" forIndexPath:indexPath];
    
    cell.joinedAllUsername.text = [NSString stringWithFormat:@"%@,%@",selectAllItem[indexPath.row][@"buyer"],selectAllItem[indexPath.row][@"count"]];
    
    cell.joinedtime.text = selectAllItem[indexPath.row][@"joinedtime"];
    
    //抓取圖片
    NSString * urlStringAll = [PHOTO_URL stringByAppendingPathComponent:selectAllItem[indexPath.row][@"image"]];
    NSURL * urlAll = [NSURL URLWithString:urlStringAll];
    [cell.joinedAllImage loadImageWithURL:urlAll];
    
    // set the profile image into circle
    cell.joinedAllImage.layer.cornerRadius = cell.joinedAllImage.frame.size.width/ 2;
    cell.joinedAllImage.clipsToBounds = YES;
    
    // adding border to profile image
    cell.joinedAllImage.layer.borderWidth = 3.0f;
    cell.joinedAllImage.layer.borderColor = [UIColor whiteColor].CGColor;

    return cell;
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
