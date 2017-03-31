//
//  UILabel+TXEstimate.h
//  WordPress
//
//  Created by Eric J on 6/18/13.
//  Copyright (c) 2013 WordPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TXEstimate)

- (CGFloat )tx_estimateWidth;
- (CGFloat )tx_estimateHeightByWidth:(CGFloat )width;

- (CGSize)tx_estimateSizeByWidth:(CGFloat)width;

@end
