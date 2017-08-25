//
//  SavedTableViewController.m
//  buyer
//
//  Created by H.M.L on 2017/5/5.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "SavedTableViewController.h"
#import "SavedTableViewCell.h"
#import "ServerCommunicator.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "dealViewController.h"
#import "JoinViewController.h"

@interface SavedTableViewController ()

@end

@implementation SavedTableViewController
{
    ServerCommunicator *comm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
    savedImage = [NSMutableArray new];
    cancelIndexpath = [NSMutableDictionary new];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"login"])
    {
        NSDictionary *parameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]};
        
        [comm doPostWithURLString:SAVED_SELECT_URL
                       parameters:parameters
                             data:nil
                       completion:^(NSError *error, id result) {
                           savedImage = result;
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self.tableView reloadData];
                           });
                       }];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"login"])
    {
        NSDictionary *parameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]};
        
        [comm doPostWithURLString:SAVED_SELECT_URL
                       parameters:parameters
                             data:nil
                       completion:^(NSError *error, id result) {
                           savedImage = result;
                           NSLog(@"savedImage,%@",savedImage);
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self.tableView reloadData];
                           });
                       }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return savedImage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    SavedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"savedCell" forIndexPath:indexPath];
    
    cell.cancelBtn.tag = indexPath.row;
    cell.joinBtn.tag = indexPath.row;
    
    NSDictionary *info = [savedImage objectAtIndex:indexPath.row];
    
    cell.productLabel.text = [NSString stringWithFormat:@"%@",info[@"dealname"]];
    cell.productPrice.text = [NSString stringWithFormat:@"NT %@ dollars",info[@"range1_price"]];
    cell.productCount.text = [NSString stringWithFormat:@"Total quantity : %@",info[@"sum_count"]];
    cell.productEndTime.text = [NSString stringWithFormat:@"%@",info[@"endtime"]];
    
    if([[NSString stringWithFormat:@"%@",info[@"endyn"]] isEqual:@"1"])
    {
        cell.productEndTime.text = info[@"endtime"];
        NSLog(@"endtime,%@",info[@"endtime"]);
        cell.backgroundColor = [UIColor whiteColor];
        cell.productImages.alpha = 1.0;
        cell.productLabel.alpha = 1.0;
        cell.productPrice.alpha = 1.0;
        cell.productCount.alpha = 1.0;
        cell.productEndTime.alpha = 1.0;
        cell.cancelBtn.alpha = 1.0;
        cell.joinBtn.alpha = 1.0;
        cell.timePic.alpha = 1.0;
    }
    else
    {
        cell.productEndTime.text = @"Closed";
        //cell.userInteractionEnabled = false;
        cell.backgroundColor = [UIColor whiteColor];
        cell.productImages.alpha = 0.20;
        cell.productLabel.alpha = 0.20;
        cell.productPrice.alpha = 0.20;
        cell.productCount.alpha = 0.20;
        cell.productEndTime.alpha = 0.20;
        cell.cancelBtn.alpha = 0.20;
        cell.joinBtn.alpha = 0.20;
        cell.timePic.alpha = 0.20;
        NSLog(@"endingtime,%@",info[@"endtime"]);
    }
    
    //抓取圖片
    NSString * urlString = [PHOTO_URL stringByAppendingPathComponent:info[@"image"]];
    NSURL * url = [NSURL URLWithString:urlString];
    [cell.productImages loadImageWithURL:url];
    
    if([NSString stringWithFormat:@"%@",savedImage[indexPath.row][@"indexpath"]] == [NSString stringWithFormat:@"1"])
    {
        [cell.cancelBtn setBackgroundImage:[UIImage imageNamed:@"saved red"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.cancelBtn setBackgroundImage:[UIImage imageNamed:@"saved tab"] forState:UIControlStateNormal];
    }
    
    [cell.cancelBtn addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.joinBtn addTarget:self action:@selector(joinButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)cancelButton:(UIButton*) sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"saved tab"] forState:UIControlStateNormal];
    
    cancelIndexpath = [NSMutableDictionary dictionaryWithDictionary:
                       @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"],
                         @"id":savedImage[sender.tag][@"id"],
                         @"indexpath":@(0)}];
    [comm doPostWithURLString:SAVED_INSERT_URL
                   parameters:cancelIndexpath
                         data:nil
                   completion:^(NSError *error, id result) {
                       dispatch_async(dispatch_get_main_queue(),^{
                           savedImage = result;
                           [self.tableView reloadData];
                       });
                   }];
}

-(void)joinButton:(UIButton*) sender
{
    JoinViewController *jVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JoinViewController"];
    NSDictionary * filename = savedImage[sender.tag];
    jVC.filename = filename;
    
    [self showViewController:jVC sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    dealViewController * dealVC = segue.destinationViewController;
    NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
    NSDictionary * filename = savedImage[indexPath.row];
    
    dealVC.filename = filename;
}


@end
