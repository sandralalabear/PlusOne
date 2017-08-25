//
//  JoinedTableViewCell.m
//  buyer
//
//  Created by H.M.L on 2017/5/19.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "JoinedTableViewCell.h"
#import "LDProgressView.h"

@implementation JoinedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 175, 50, 35)];
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(110, 175, 50, 35)];
    self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(180, 175, 50, 35)];
    self.label4 = [[UILabel alloc] initWithFrame:CGRectMake(250, 175, 50, 35)];
    self.label5 = [[UILabel alloc] initWithFrame:CGRectMake(320, 175, 50, 35)];
    
    self.label1.text = @"合購中";
    self.label2.text = @"已成團";
    self.label3.text = @"已付款";
    self.label4.text = @"已出貨";
    self.label5.text = @"已取貨";
    
    self.label1.textColor = [UIColor lightGrayColor];
    self.label2.textColor = [UIColor lightGrayColor];
    self.label3.textColor = [UIColor lightGrayColor];
    self.label4.textColor = [UIColor lightGrayColor];
    self.label5.textColor = [UIColor lightGrayColor];
    
    self.label1.font = [UIFont systemFontOfSize:15.0];
    self.label2.font = [UIFont systemFontOfSize:15.0];
    self.label3.font = [UIFont systemFontOfSize:15.0];
    self.label4.font = [UIFont systemFontOfSize:15.0];
    self.label5.font = [UIFont systemFontOfSize:15.0];
    
    // flat, green, no text, progress inset, outer stroke, solid
    self.progressView = [[LDProgressView alloc] init];
    self.progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 157, self.frame.size.width-40, 22)];
    self.progressView.color = [UIColor colorWithRed:80.0/255.0 green:227.0/255.0 blue:194.0/255.0 alpha:1.0];

    self.progressView.flat = @YES;
    self.progressView.progress = 0.0;
    self.progressView.animate = @YES;
    self.progressView.showText = @NO;
    self.progressView.showStroke = @NO;
    self.progressView.progressInset = @5;
    self.progressView.showBackground = @NO;
    self.progressView.outerStrokeWidth = @3;
    self.progressView.type = LDProgressSolid;
    [self addSubview:self.progressView];
    
    [self addSubview:self.label1];
    [self addSubview:self.label2];
    [self addSubview:self.label3];
    [self addSubview:self.label4];
    [self addSubview:self.label5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
