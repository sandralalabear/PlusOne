//
//  JoinDetailViewController.h
//  Hello+1
//
//  Created by H.M.L on 2017/5/31.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "ViewController.h"
#import "LDProgressView.h"

@interface JoinDetailViewController : ViewController

@property(strong,nonatomic) NSDictionary *filename;

@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *label3;
@property (strong, nonatomic) UILabel *label4;
@property (strong, nonatomic) UILabel *label5;
@property (strong, nonatomic) LDProgressView *progressView;

@end
