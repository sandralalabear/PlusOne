//
//  DealsManagementTableViewCell.m
//  Hello+1
//
//  Created by Sandra Wei on 2017/5/31.
//  Copyright © 2017年 Appbear. All rights reserved.
//

#import "DealsManagementTableViewCell.h"
#import "PriceAndQuantityData.h"
#import "Deal.h"
#import "AppDelegate.h"

static int ProgressBarPadding = 20;
static int PriceLabelYposition = 160;
static int QuantityLabelYPosition = 210;
static int LabelWidth = 50;
static int LabelHeight = 35;

@implementation DealsManagementTableViewCell

- (id)initWithData: (Deal *)deal joineds: (NSMutableArray *)joineds {
    
    int progressBarWidth = self.frame.size.width - ProgressBarPadding * 2;
    NSLog(@"progressBarWith: %d", progressBarWidth);
    
    for (int i = 0; i < deal.priceAndQuantityList.count; i++) {
        
        PriceAndQuantityData *priceAndQuantityData = (PriceAndQuantityData *)deal.priceAndQuantityList[i];
        
        int labelXPositionOffset = [self determineLabelXPositionOffset:i of:deal.priceAndQuantityList.count];
        int labelXPosition = progressBarWidth / (deal.priceAndQuantityList.count - 1) * i + labelXPositionOffset;
        
        UILabel *quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelXPosition, QuantityLabelYPosition, LabelWidth, LabelHeight)];
        quantityLabel.tag = 777;
        quantityLabel.textColor = [UIColor lightGrayColor];
        quantityLabel.font = [UIFont systemFontOfSize:15.0];
        quantityLabel.textAlignment = NSTextAlignmentCenter;
        quantityLabel.text = [NSString stringWithFormat:@"%ld", priceAndQuantityData.quantity];
        
        [self addSubview:quantityLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelXPosition, PriceLabelYposition, LabelWidth, LabelHeight)];
        priceLabel.tag = 888;
        priceLabel.textColor = [UIColor lightGrayColor];
        priceLabel.font = [UIFont systemFontOfSize:15.0];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.text = [NSString stringWithFormat:@"%ld", priceAndQuantityData.price];
        
        [self addSubview:priceLabel];
        
    }
    self.progressView.tag = 999;
    self.progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 190, progressBarWidth, 22)];
    self.progressView.color = [UIColor colorWithRed:80.0/255.0 green:227.0/255.0 blue:194.0/255.0 alpha:1.0];
    self.progressView.flat = @YES;
    self.progressView.progress = [self determineProgress:deal with:joineds];
    self.progressView.animate = @YES;
    self.progressView.showText = @NO;
    self.progressView.showStroke = @NO;
    self.progressView.progressInset = @4;
    self.progressView.showBackground = @NO;
    self.progressView.outerStrokeWidth = @3;
    self.progressView.type = LDProgressSolid;
    [self addSubview:self.progressView];
    
    //抓取圖片
    NSString * urlString = [PHOTO_URL stringByAppendingPathComponent:deal.coverPhotoPath];
    NSURL * url = [NSURL URLWithString:urlString];
    [self.dealCoverPhoto loadImageWithURL:url];
    
    self.dealName.text = deal.dealNameText;
    self.dealEndDate.text = [NSString stringWithFormat:@"%@",deal.endingDate];
    self.totalQuantity.text = [NSString stringWithFormat:@"%ld",(long)[deal getTotalQuantity:joineds]];
    self.totalPrice.text = [NSString stringWithFormat:@"%ld",(long)[deal getTotalPrice:joineds]];
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    for(UIView *subview in [self subviews])
    {
        if(subview.tag == 888 || subview.tag == 777 || subview.tag == 999)
        {
            [subview removeFromSuperview];
        }
    }
}

- (int)determineLabelXPositionOffset: (int)i of:(NSUInteger)count {
    
    if (i == 0) {
        // first item
        return ProgressBarPadding;
    }
    
    if (i == count - 1) {
        // last item
        return 0 - ProgressBarPadding;
    }
    
    // middle item
    return ProgressBarPadding - LabelWidth / 2;
}

- (CGFloat)determineProgress:(Deal *) deal with:(NSArray *) joineds {
    
    NSInteger totalQuantity = [deal getTotalQuantity:joineds];
    
    double progressUnit = (double)1 / (deal.priceAndQuantityList.count);
    double progress = 0;
    
    for (int i = 0; i < deal.priceAndQuantityList.count; i++) {
        
        if (totalQuantity >= ((PriceAndQuantityData *)deal.priceAndQuantityList[i]).quantity) {
            progress += progressUnit;
        }
    }
    return (CGFloat)progress;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
