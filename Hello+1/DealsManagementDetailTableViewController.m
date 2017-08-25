//
//  DealsManagementDetailTableViewController.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/6/2.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "DealsManagementDetailTableViewController.h"
#import "InformBuyersTableViewCell.h"
#import "BuyersTableViewCell.h"
#import "DealStore.h"
#import "DealsManagementTableViewCell.h"
#import "DealsManagementTableViewController.h"
#import "Notification.h"
#import "NotificationStore.h"
#import "Joined.h"
#import "JoinedStore.h"
#import "AppDelegate.h"
#import "ServerCommunicator.h"

@interface DealsManagementDetailTableViewController ()
@property (nonatomic,strong) NSArray *manageSection;

@property (nonatomic,strong) NSMutableArray *joineds;
@property (nonatomic,strong) NSMutableArray *notifications;
@property (nonatomic,strong) JoinedStore *joinedStore;
@property (nonatomic,strong) NotificationStore *notificationStore;

@end

@implementation DealsManagementDetailTableViewController
{
    ServerCommunicator *comm;
    NSMutableArray *selectUserDetail2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
    selectUserDetail2 = [NSMutableArray new];
    
    for(int i = 0 ; i < self.selectUserDetail.count ; i++)
    {
        if(self.selectUserDetail[i][@"id"] == self.keyString)
        {
            [selectUserDetail2 addObject:self.selectUserDetail[i]];
        }
    }
    
    NSLog(@"testsforchat...,%@",selectUserDetail2);
    _manageSection = [[NSArray alloc] initWithObjects:@"deal",@"message",@"buyers", nil];
    
    _joinedStore = [[JoinedStore alloc] init];
    _joineds = [_joinedStore findByDeal:_deal :selectUserDetail2];
    _notificationStore = [[NotificationStore alloc] init];
    _notifications = [[NSMutableArray alloc] initWithArray:[_notificationStore findByDeal :_deal:selectUserDetail2]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _manageSection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        
        return _notifications.count + 1;
    }
    
    if (section == 2) {
        
        return _joineds.count;
    }
    
    return 1;
}

- (IBAction)sendPaymentMessage:(id)sender {
    
    NSString *systemSender = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    
    for(int i = 0 ; i < selectUserDetail2.count ; i++)
    {
        NSString *systemReceiver = selectUserDetail2[i][@"buyer"];
        
        if(systemReceiver != systemSender)
        {
            // Send Text with comm
            [comm sendTextMessage:systemSender
                          message:@"/*System Reminder*/\nInform all buyers to pay"
                         receiver:systemReceiver
                       completion:nil];
        }
    }
    
    Notification *notification = [_notificationStore add:@"Inform all buyers to pay" to:_deal];
    [_notifications addObject:notification];
    
    [self.tableView reloadData];
}

- (IBAction)sendShippingMessage:(id)sender {
    
    NSString *systemSender = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    
    for(int i = 0 ; i < selectUserDetail2.count ; i++)
    {
        NSString *systemReceiver = selectUserDetail2[i][@"buyer"];
        
        if(systemReceiver != systemSender)
        {
            // Send Text with comm
            [comm sendTextMessage:systemSender
                          message:@"/*System Reminder*/\nInform all product is on the way"
                         receiver:systemReceiver
                       completion:nil];
        }
    }
    
    Notification *notitfication = [_notificationStore add:@"Inform all product is on the way" to:_deal];
    [_notifications addObject:notitfication];
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            DealsManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            return [cell initWithData:_deal joineds:_joineds];
        }
        case 1: {
            if (indexPath.row == 0) {
                InformBuyersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
                return cell;
            } else {
                InformBuyersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
                cell.textLabel.text = ((Notification *) _notifications[indexPath.row - 1]).content;
                cell.detailTextLabel.text = ((Notification *) _notifications[indexPath.row - 1]).date;
                return cell;
            }
        }
        case 2: {
            
            BuyersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyerCell" forIndexPath:indexPath];
            
            Joined *joined = _joineds[indexPath.row];
            
            
            //抓取圖片
            NSString * urlString = [PHOTO_URL stringByAppendingPathComponent:joined.keyString];
            NSURL * url = [NSURL URLWithString:urlString];
            [cell.buyerCoverPhoto loadImageWithURL:url];
            
            //cell.buyerCoverPhoto.image = joined.buyerPhoto;
            cell.buyerName.text = joined.buyerName;
            cell.quantity.text = [NSString stringWithFormat:@"%ld",(long)joined.quantity];
            cell.totalAmount.text = [NSString stringWithFormat:@"%ld",(long)joined.amount];
            cell.joinedDate.text = joined.joinedDate;
            
            return cell;
        }
    }
    
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    if (section == 2) {
        sectionName = @"Buyers";
    }
    return sectionName;
}

// Set Section title color
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:80.0/255.0 green:227.0/255.0 blue:194.0/255.0 alpha:1.0]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 248;
            break;
        case 1:
            if (indexPath.row == 0) {
            return 100;
            } else {
                return 44;
            }
        default:
            break;
    }
    return  80;
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
