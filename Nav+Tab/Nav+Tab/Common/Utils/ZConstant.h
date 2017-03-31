//
//  ZConstant.h
//  PaixieMall
//
//  Created by zhwx on 15/1/8.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#ifndef PaixieMall_ZConstant_h
#define PaixieMall_ZConstant_h

#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IPHONE5  ( fabsl( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //全局并发队列
#define kMainQueue dispatch_get_main_queue() //主线程队列

//格式化 字符串
#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

//编码
#define ENC_GB1832 CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000)


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBSINGLE(v) [UIColor colorWithRed:(v)/255.0f green:(v)/255.0f blue:(v)/255.0f alpha:1]


#define weakSelf(weakSelf)  __weak __typeof(self)weakSelf = self;

#define screenHeight [[UIScreen mainScreen]bounds].size.height //屏幕高度
#define screenWidth [[UIScreen mainScreen]bounds].size.width

#define M_PI   3.14159265358979323846264338327950288
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


#endif
