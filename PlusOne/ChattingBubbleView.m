//
//  ChattingBubbleView.m
//  buyer
//
//  Created by H.M.L on 2017/5/15.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "ChattingBubbleView.h"

// Layout constants
#define SIDE_PADDING_RATE       0.02
#define MAX_BUBBLE_WIDTH_RATE   0.7
#define CONTENT_MARGIN          10.0
#define BUBBLE_TALE_WIDTH       10.0
#define TEXT_FONT_SIZE          16.0

@implementation ChattingBubbleView
{
    CGFloat currentY;
    
    // Subviews
    UIImageView *photoImageView;
    UILabel *textLabel;
    UIImageView *backgroundImageView;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype) initWithItem:(ChattingItem*)item
                      offsetY:(CGFloat) offsetY {
    // Step1: Caculate a basic frame
    self = [super init];
    self.frame = [self caculateBasicFrameWithType:item.type
                                          offsetY:offsetY];
    
    // Step2: Caculate with Image
    currentY = 0.0;
    if(item.image != nil) {
        [self caculateWithImage:item.image
                       itemType:item.type];
    }
    
    // Step3: Caculate with Text
    if(item.text.length > 0) {
        [self caculateWithText:item.text
                      itemType:item.type];
    }
    
    // Step4: Caculate final bubble view frame with Image/Text Size
    [self caculateFinalSizeWithItemType:item.type];
    
    // Step5: Show background of bubble view
    [self prepareBackgroundImageWithItemType:item.type];
    
    return self;
}

- (CGRect) caculateBasicFrameWithType:(ChattingItemType) type offsetY:(CGFloat) offsetY {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat sidePadding = screenWidth * SIDE_PADDING_RATE;
    CGFloat maxWidth = screenWidth * MAX_BUBBLE_WIDTH_RATE;
    
    CGFloat offsetX;
    
    if(type == ChattingItemTypeFromMe) {
        offsetX = screenWidth - sidePadding - maxWidth;
    } else {
        // From Others
        offsetX = sidePadding;
    }
    // maxWidth,10 are just temp values.
    return CGRectMake(offsetX, offsetY, maxWidth, 10);
}

- (void) caculateWithImage:(UIImage*)image itemType:(ChattingItemType)type {
    
    CGFloat x = CONTENT_MARGIN;
    CGFloat y = CONTENT_MARGIN;
    
    if(type == ChattingItemTypeFromOthers) {
        x += BUBBLE_TALE_WIDTH;
    }
    // Caculate display size
    CGFloat displayWidth = MIN(image.size.width,self.frame.size.width - 2 * CONTENT_MARGIN - BUBBLE_TALE_WIDTH);
    CGFloat displayRatio = displayWidth / image.size.width;
    CGFloat displayHeight = image.size.height * displayRatio;
    
    CGRect displayFrame = CGRectMake(x, y, displayWidth, displayHeight);
    
    // Prepare photoImageView
    photoImageView = [[UIImageView alloc] initWithFrame:displayFrame];
    photoImageView.image = image;
    photoImageView.layer.cornerRadius = 5.0;
    photoImageView.layer.masksToBounds = true;
    // Add to self
    [self addSubview:photoImageView];
    
    // Update currentY
    currentY = CGRectGetMaxY(displayFrame);
}

- (void) caculateWithText:(NSString*)text
                 itemType:(ChattingItemType) type {
    
    // Decide x,y
    CGFloat x = CONTENT_MARGIN;
    CGFloat y = currentY + TEXT_FONT_SIZE/2;
    if(type == ChattingItemTypeFromOthers) {
        x += BUBBLE_TALE_WIDTH;
    }
    // Decide Display Width and Height
    CGFloat displayWidth = self.frame.size.width - 2 * CONTENT_MARGIN - BUBBLE_TALE_WIDTH;
    CGFloat displayHeight = TEXT_FONT_SIZE;
    
    CGRect displayFrame = CGRectMake(x, y, displayWidth, displayHeight);
    
    // Prepare textLabel
    textLabel = [[UILabel alloc] initWithFrame:displayFrame];
    textLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE];
    textLabel.text = text;
    textLabel.numberOfLines = 0;
    [textLabel sizeToFit];
    
    // Add to Self
    [self addSubview:textLabel];
    
    // Update currentY
    currentY = CGRectGetMaxY(textLabel.frame);
}

- (void) caculateFinalSizeWithItemType:(ChattingItemType) type {
    
    CGFloat finalWidth = 0.0;
    CGFloat finalHeight = currentY + CONTENT_MARGIN;
    
    if(photoImageView != nil) {
        if(type == ChattingItemTypeFromMe) {
            finalWidth = CGRectGetMaxX(photoImageView.frame) + CONTENT_MARGIN + BUBBLE_TALE_WIDTH;
        } else {
            // From Others
            finalWidth = CGRectGetMaxX(photoImageView.frame) + CONTENT_MARGIN;
        }
    }
    if(textLabel != nil) {
        CGFloat labelWidth = 0;
        
        if(type == ChattingItemTypeFromMe) {
            labelWidth = CGRectGetMaxX(textLabel.frame) + CONTENT_MARGIN + BUBBLE_TALE_WIDTH;
        } else {
            // From Others
            labelWidth = CGRectGetMaxX(textLabel.frame) + CONTENT_MARGIN;
        }
        
        finalWidth = MAX(labelWidth,finalWidth);
    }
    
    // Final adjustment of textLabel
    CGRect finalFrame = self.frame;
    
    if(type == ChattingItemTypeFromMe && photoImageView == nil) {
        finalFrame.origin.x += finalFrame.size.width - finalWidth;
    }
    
    // Update frame
    finalFrame.size.width = finalWidth;
    finalFrame.size.height = finalHeight;
    
    self.frame = finalFrame;
}

- (void) prepareBackgroundImageWithItemType:(ChattingItemType)type {
    
    CGRect backgroundImageViewFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundImageViewFrame];
    
    if(type == ChattingItemTypeFromMe) {
        UIImage *image = [UIImage imageNamed:@"fromMe.png"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 17, 28)];
        backgroundImageView.image = image;
    } else {
        // From Others
        UIImage *image = [UIImage imageNamed:@"fromOthers.png"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(14, 22, 17, 20)];
        backgroundImageView.image = image;
    }
    [self addSubview:backgroundImageView];
    [self sendSubviewToBack:backgroundImageView];
}


@end
