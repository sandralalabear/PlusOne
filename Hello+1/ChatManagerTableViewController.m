//
//  ChatManagerTableViewController.m
//  buyer
//
//  Created by H.M.L on 2017/5/13.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "ChatManagerTableViewController.h"
#import "AppDelegate.h"
#import "ServerCommunicator.h"
#import "ChatManagerTableViewCell.h"
#import "ChatBox.h"

@interface ChatManagerTableViewController ()

@end

@implementation ChatManagerTableViewController
{
    ServerCommunicator *comm;
    ChatBox *chatBox;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
    self.getMessageArray = [NSMutableArray new];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"login"])
    {
        NSDictionary *parameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]};
        [comm doPostJobWithURLString:MESSAGE_SELECT_URL
                          parameters:parameters
                                data:nil
                          completion:^(NSError *error, id result) {
                              
                              self.getMessageArray = result;
                              
                              dispatch_async(dispatch_get_main_queue(),^{
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
        
        [comm doPostJobWithURLString:MESSAGE_SELECT_URL
                          parameters:parameters
                                data:nil
                          completion:^(NSError *error, id result) {
                              
                              self.getMessageArray = result;
                              
                              dispatch_async(dispatch_get_main_queue(),^{
                                  [self.tableView reloadData];
                              });
                          }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.getMessageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatMessageCell" forIndexPath:indexPath];
    
    cell.receiveName.text = [NSString stringWithFormat:@"%@",self.getMessageArray[indexPath.row][@"receiver"]];
    cell.receiveMessage.text = [NSString stringWithFormat:@"%@",self.getMessageArray[indexPath.row][@"message"]];
    cell.receiveTime.text = [NSString stringWithFormat:@"%@",self.getMessageArray[indexPath.row][@"sendtime"]];
    
    // set the profile image into circle
    cell.usernameImage.layer.cornerRadius = cell.usernameImage.frame.size.width/ 2;
    cell.usernameImage.clipsToBounds = YES;
    
    // adding border to profile image
    cell.usernameImage.layer.borderWidth = 3.0f;
    cell.usernameImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //抓取圖片
    NSString * urlString = [PHOTO_URL stringByAppendingPathComponent:self.getMessageArray[indexPath.row][@"image"]];
    NSURL * url = [NSURL URLWithString:urlString];
    [cell.usernameImage loadImageWithURL:url];
    
    

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChatBox * cb = segue.destinationViewController;
    NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
    NSDictionary * filename = self.getMessageArray[indexPath.row];
    cb.getChatManager = filename;
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
