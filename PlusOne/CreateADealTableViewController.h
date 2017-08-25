//
//  CreateADealTableViewController.h
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/11.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoverPhotoTableViewCell.h"
#import "CoverPhotoCollectionViewCell.h"
#import "DealNameAndDescriptionTableViewCell.h"
#import "DatePickerTableViewCell.h"
#import "MinAndMaxSliderTableViewCell.h"
#import "PriceAndQuantityRangeTableViewCell.h"
#import "PriceAndQuantityData.h"
#import "PaymentTableViewCell.h"
#import "ShippingTableViewCell.h"
#import "NMRangeSlider.h"
#import "XLFormViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Deal.h"
#import "DealStore.h"

@interface CreateADealTableViewController : UITableViewController <UICollectionViewDelegate,UICollectionViewDataSource>
    
@property (nonatomic,strong) Deal *deal;
@property (nonatomic,strong) UITextView *endingDateTextField;

@end
