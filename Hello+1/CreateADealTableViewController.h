//
//  CreateADealTableViewController.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/11.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateADealTableViewController : UITableViewController <UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic,strong) UIImage * coverPhoto;
@property (nonatomic,strong) UITextView *endingDateTextField;

@end
