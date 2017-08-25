//
//  DealsManagementTableViewController.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/31.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "DealsManagementTableViewController.h"
#import "Deal.h"
#import "User.h"
#import "DealStore.h"
#import "JoinedStore.h"
#import "ServerCommunicator.h"
#import "AppDelegate.h"

@interface DealsManagementTableViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *deals;
//@property (nonatomic,strong) NSArray *deals;
@property (nonatomic,strong) DealStore *dealStore;

@property (nonatomic,strong) JoinedStore *joinedStore;

@end

@implementation DealsManagementTableViewController
{
    ServerCommunicator *comm;
    NSMutableArray *selectALLDetail;
    NSMutableArray *selectUserDetail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
    selectALLDetail = [NSMutableArray new];
    selectUserDetail = [NSMutableArray new];
    _deals = [NSMutableArray new];
    
    self.navigationItem.title = @"Deals management";
    
    NSString *username = [NSString stringWithFormat: @"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"login"]];
    if (username == nil) {
        // TODO log in alert
        
    }
    
    NSDictionary *parameters = @{@"username":username,
                                 @"who":@"saler"};
    NSData *data = [NSData new];
    
    [comm doPostJobWithURLString:USER_DETAIL_URL
                      parameters:parameters
                            data:data
                      completion:^(NSError *error, id result) {
                          
                          selectALLDetail = result;
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              _deals = [_dealStore findDealByUsername:username :selectALLDetail];
                              [self.tableView reloadData];
                          });
                      }];
    
    NSDictionary *parameters2 = @{@"username":username,
                                 @"who":@"buyer"};
    NSData *data2 = [NSData new];
    
    [comm doPostJobWithURLString:USER_DETAIL_URL
                      parameters:parameters2
                            data:data2
                      completion:^(NSError *error, id result) {
                          
                          selectUserDetail = result;
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              [self.tableView reloadData];
                          });
                      }];
    
    _dealStore = [[DealStore alloc] init];
    
    _joinedStore = [[JoinedStore alloc] init];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"deals.count: %lu ",(unsigned long)_deals.count);
    return _deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DealsManagementTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSMutableArray *joineds = [_joinedStore findByDeal:_deals[indexPath.row] :selectUserDetail];
    
    return [cell initWithData: _deals[indexPath.row] joineds:joineds];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DealsManagementDetailTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DealsManagementDetailTableViewController"];
    
    vc.deal = _deals[indexPath.row];
    vc.selectUserDetail = selectUserDetail;
    vc.keyString = selectALLDetail[indexPath.row][@"id"];
    [self showViewController:vc sender:nil];
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
