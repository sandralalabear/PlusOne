//
//  TableViewController.m
//  buyer
//
//  Created by H.M.L on 2017/4/27.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "ServerCommunicator.h"
#import "dealViewController.h"
#import "JoinViewController.h"
#import "AdvanceImageView.h"

@interface TableViewController ()
{
    ServerCommunicator *comm;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    comm = [ServerCommunicator new];
    NSData *data = [NSData new];
    
    selectimage = [NSMutableArray new];
    
    getindexpath = [NSMutableDictionary new];
    getSearchIndexpath = [NSMutableDictionary new];
    
    loginParameters = [NSDictionary new];
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"login"])
    {
        loginParameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]};
    }
    else
    {
        loginParameters = @{@"username":@""};
    }
    //連PHP找出目前database(image)資料
    [comm doPostJobWithURLString:SELECT_IMAGE_URL
                      parameters:loginParameters
                            data:data
                      completion:^(NSError *error, id result) {
                          
                          selectimage = result;
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.tableView reloadData];
                          });
                      }];
    
    mySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    mySearchController.searchBar.barTintColor = [UIColor colorWithRed:80.0/255.0 green:227.0/255.0 blue:194.0/255.0 alpha:1.0];
    mySearchController.searchResultsUpdater = self;
    mySearchController.dimsBackgroundDuringPresentation = NO;
    CGRect rect = mySearchController.searchBar.frame;
    rect.size.height = 44.0;
    mySearchController.searchBar.frame = rect;
    self.tableView.tableHeaderView = mySearchController.searchBar;
    self.definesPresentationContext = YES;
   

   /*
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    */
}

/*
- (void)refresh:(UIRefreshControl *)refreshControl {
    // 實作重新撈資料
    
    [refreshControl beginRefreshing];
    
    [self.tableView reloadData];
    
    [refreshControl endRefreshing];
}*/

-(void)viewDidAppear:(BOOL)animated
{
    NSData *data = [NSData new];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"login"])
    {
        loginParameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]};
    }
    else
    {
        loginParameters = @{@"username":@""};
    }
    //連PHP找出目前database(image)資料
    [comm doPostJobWithURLString:SELECT_IMAGE_URL
                      parameters:loginParameters
                            data:data
                      completion:^(NSError *error, id result) {
                          
                          selectimage = result;
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              [self.tableView reloadData];
                          });
                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        //判斷searchbar有無keyin文字
        if(searchResult != nil)
        {
            return searchResult.count;
        }
        else
        {
            return selectimage.count;
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    //秀出searchbar keyin的資料
    if(searchResult != nil)
    {
        cell.joinedBTN.tag = indexPath.row;
        cell.savedBTN.tag = indexPath.row;
        NSDictionary *info = [searchResult objectAtIndex:indexPath.row];
        cell.productLabel.text = info[@"dealname"];
        cell.priceLabel.text = [NSString stringWithFormat:@"NT %@ dollars",info[@"range1_price"]];
        cell.countLabel.text = [NSString stringWithFormat:@"Total quantity : %@",info[@"sum_count"]];
        cell.timeLabel.text = info[@"endtime"];
        
        //抓取圖片
        NSString * urlString = [PHOTO_URL stringByAppendingPathComponent:info[@"image"]];
        NSURL * url = [NSURL URLWithString:urlString];
        [cell.productImages loadImageWithURL:url];
        
        if(([NSString stringWithFormat:@"%@",searchResult[indexPath.row][@"indexpath"]] == [NSString stringWithFormat:@"1"]) &&
           ([[NSUserDefaults standardUserDefaults] objectForKey:@"login"] == [NSString stringWithFormat:@"%@",searchResult[indexPath.row][@"username"]]))
        {
            [cell.savedBTN setBackgroundImage:[UIImage imageNamed:@"saved red"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.savedBTN setBackgroundImage:[UIImage imageNamed:@"saved tab"] forState:UIControlStateNormal];
        }
    }
    //若無keyin則秀出全部資料
    else
    {
        cell.joinedBTN.tag = indexPath.row;
        cell.savedBTN.tag = indexPath.row;
        NSDictionary *info = [selectimage objectAtIndex:indexPath.row];
        cell.productLabel.text = info[@"dealname"];
        cell.priceLabel.text = [NSString stringWithFormat:@"NT %@ dollars",info[@"range1_price"]];
        cell.countLabel.text = [NSString stringWithFormat:@"Total quantity : %@",info[@"sum_count"]];
        cell.timeLabel.text = info[@"endtime"];
        
        //抓取圖片
        NSString * urlString = [PHOTO_URL stringByAppendingPathComponent:info[@"image"]];
        NSURL * url = [NSURL URLWithString:urlString];
        [cell.productImages loadImageWithURL:url];

        if(([NSString stringWithFormat:@"%@",selectimage[indexPath.row][@"indexpath"]] == [NSString stringWithFormat:@"1"]))
        {
            [cell.savedBTN setBackgroundImage:[UIImage imageNamed:@"saved red"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.savedBTN setBackgroundImage:[UIImage imageNamed:@"saved tab"] forState:UIControlStateNormal];
        }
        
    }

    [cell.savedBTN addTarget:self action:@selector(savedButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.joinedBTN addTarget:self action:@selector(joinedButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void) savedButtonSelect:(UIButton*) sender
{
    if(searchResult != nil)
    {
        getindexpath = [NSMutableDictionary dictionaryWithDictionary:
                        @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"],
                          @"id":searchResult[sender.tag][@"id"]}];
    }
    else
    {
        getindexpath = [NSMutableDictionary dictionaryWithDictionary:
                        @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"login"],
                          @"id":selectimage[sender.tag][@"id"]}];
    }
    
    sender.enabled = NO;
    
    //if(([NSString stringWithFormat:@"%@",selectimage[sender.tag][@"indexpath"]] != [NSString stringWithFormat:@"1"]))
    
    if([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"saved tab"]])
    {
        getindexpath[@"indexpath"] = @"1";
        
        [comm doPostWithURLString:SAVED_INSERT_URL
                       parameters:getindexpath
                             data:nil
                       completion:^(NSError *error, id result) {
                           [sender setBackgroundImage:[UIImage imageNamed:@"saved red"] forState:UIControlStateNormal];
                           
                           sender.enabled = YES;
                       }];
    }
    
    else //delete(indexpath=0)
    {
        getindexpath[@"indexpath"] = @"0";
        
        [comm doPostWithURLString:SAVED_INSERT_URL
                       parameters:getindexpath
                             data:nil
                       completion:^(NSError *error, id result) {
                           [sender setBackgroundImage:[UIImage imageNamed:@"saved tab"] forState:UIControlStateNormal];
                           
                           sender.enabled = YES;
                       }];
    }
}

-(void) joinedButtonSelect:(UIButton*) sender
{
    if(searchResult != nil)
    {
        JoinViewController *jVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JoinViewController"];
        NSDictionary * filename = searchResult[sender.tag];
        jVC.filename = filename;
        
        [self showViewController:jVC sender:nil];
    }
    else
    {
        JoinViewController *jVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JoinViewController"];
        NSDictionary * filename = selectimage[sender.tag];
        jVC.filename = filename;
        
        [self showViewController:jVC sender:nil];

    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(searchResult != nil)
    {
        dealViewController * dealVC = segue.destinationViewController;
        NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
        NSDictionary * filename = searchResult[indexPath.row];
        
        dealVC.filename = filename;
    }
    else
    {
        dealViewController * dealVC = segue.destinationViewController;
        NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
        NSDictionary * filename = selectimage[indexPath.row];
        
        dealVC.filename = filename;
    }
}

//Protocol(UISearchResultsUpdating)需要的function
-(void) updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if(searchController.isActive)
    {
        NSString * searchString = searchController.searchBar.text;
        if([searchString length] > 0)
        {
            NSPredicate *p = [NSPredicate predicateWithFormat:@"dealname CONTAINS[cd] %@",searchString];
            searchResult = [selectimage filteredArrayUsingPredicate:p];
        }
        else
        {
            searchResult = nil;
        }
    }
    else
    {
        searchResult = nil;
    }
    [self.tableView reloadData];
}




@end
