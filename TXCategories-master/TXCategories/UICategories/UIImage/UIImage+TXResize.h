// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
#import <UIKit/UIKit.h>

@interface UIImage (TXResize)

- (UIImage *)tx_croppedImage:(CGRect)bounds;
- (UIImage *)tx_thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)tx_resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)tx_resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
@end
