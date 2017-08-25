//
//  ViewController.h
//  buyer
//
//  Created by H.M.L on 2017/4/27.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BViewController.h"


typedef void(^DoneHandler)(NSError *error,id result);

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (strong,nonatomic) NSMutableArray *getUNFromSC;
@property (strong,nonatomic) NSMutableArray *getPWFromSC;

@end

