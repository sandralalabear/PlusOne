//
//  TableViewController.h
//  buyer
//
//  Created by H.M.L on 2017/4/27.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController<UISearchResultsUpdating>
{
    UISearchController *mySearchController;
    NSDictionary *loginParameters;
    NSArray *searchResult;
    NSMutableArray *selectimage;
    NSArray *buttonPressed;
    NSMutableDictionary *getindexpath;
    NSMutableDictionary *getSearchIndexpath;
}

@property (strong,nonatomic) UIImage *image;

@end
