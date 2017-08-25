//
//  JoinedTableViewController.m
//  buyer
//
//  Created by H.M.L on 2017/5/19.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "JoinedTableViewController.h"
#import "JoinedTableViewCell.h"
#import "ServerCommunicator.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "LDProgressView.h"
#import "JoinDetailViewController.h"

@interface JoinedTableViewController ()

@end

@implementation JoinedTableViewController
{
    ServerCommunicator *comm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"login"])
    {
        NSDictionary *parameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]};
        
        [comm doPostWithURLString:JOINED_SELECT_URL
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

-(void)viewDidAppear:(BOOL)animated
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"login"])
    {
        NSDictionary *parameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]};
        
        [comm doPostWithURLString:JOINED_SELECT_URL
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
    JoinedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"joinedCell" forIndexPath:indexPath];
    
    NSDictionary *info = [savedImage objectAtIndex:indexPath.row];
    
    cell.joinedProduct.text = info[@"dealname"];
    cell.joinedPrice.text = [NSString stringWithFormat:@"NT %@ dollars",info[@"range1_price"]];
    cell.joinedCount.text = [NSString stringWithFormat:@"Total quantity : %@",info[@"sum_count"]];
    cell.joinedEndTime.text = info[@"endtime"];
    
    if([[NSString stringWithFormat:@"%@",info[@"endyn"]] isEqual:@"1"])
    {
        cell.joinedEndTime.text = info[@"endtime"];
    }
    else
    {
        cell.joinedEndTime.text = @"Closed";
    }

    
    /*
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-M-d"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:info[@"endtime"]];
    NSComparisonResult result = [date compare:[NSDate date]];
    
    if(result == NSOrderedDescending)
    {
        cell.joinedEndTime.text = info[@"endtime"];
    }
    else if(result == NSOrderedAscending)
    {
        cell.joinedEndTime.text = @"已截止";
    }
    */
    //抓取圖片
    NSString * urlString = [PHOTO_URL stringByAppendingPathComponent:info[@"pics"]];
    NSURL * url = [NSURL URLWithString:urlString];
    [cell.joinedImage loadImageWithURL:url];

    if([info[@"sum_count"] intValue] >= [info[@"target_min"] intValue])
    {
        cell.progressView.progress = 0.40;
        cell.label1.textColor = [UIColor lightGrayColor];
        cell.label2.textColor = [UIColor orangeColor];
        cell.label3.textColor = [UIColor lightGrayColor];
        cell.label4.textColor = [UIColor lightGrayColor];
        cell.label5.textColor = [UIColor lightGrayColor];
    }
    else
    {
        cell.progressView.progress = 0.20;
        cell.label1.textColor = [UIColor orangeColor];
        cell.label2.textColor = [UIColor lightGrayColor];
        cell.label3.textColor = [UIColor lightGrayColor];
        cell.label4.textColor = [UIColor lightGrayColor];
        cell.label5.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    JoinDetailViewController * joinVC = segue.destinationViewController;
    NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
    NSDictionary * filename = savedImage[indexPath.row];
    
    joinVC.filename = filename;
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
