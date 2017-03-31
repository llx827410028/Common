//
//  LXdefine.h
//  Nav+Tab
//
//  Created by ugamehome on 2017/3/31.
//  Copyright © 2017年 ugamehome. All rights reserved.
//

#ifndef LXdefine_h
#define LXdefine_h
#ifdef DEBUG

#define LXLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define LXLog( s, ... )

#endif

#pragma mark- 弱引用

#define LX_WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

/***** 设备信息 *****/
#pragma mark- 设备信息

#define LX_IOS7    ([[[UIDevice currentDevice] systemVersion] floatValue] = 7.0)
#define LX_IOS8    ([[[UIDevice currentDevice] systemVersion] floatValue] = 8.0)
#define LX_IOS9    ([[[UIDevice currentDevice] systemVersion] floatValue] = 9.0)

#define LX_IOS7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define LX_IOS8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define LX_IOS9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define LX_SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define LX_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define LX_NAV_HEIGHT 64
#define LX_TABBAR_HEIGHT 49

// 沙盒路径
#define LX_PATH_OF_APP_HOME    NSHomeDirectory()
#define LX_PATH_OF_TEMP        NSTemporaryDirectory()
#define LX_PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// 当前版本
#define LX_SystemVersion       ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define LX_SystemBuild         ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

/***** 颜色相关 *****/
#pragma mark- 颜色相关

// 颜色
#define LX_RGB(r, g, b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define LX_RGB2(r, g, b) [UIColor colorWithRed:r green:g blue:b alpha:1]

#define LX_RGBA(r, g, b, al)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]
#define LX_RGBA2(r, g, b, al) [UIColor colorWithRed:r green:g blue:b alpha:al]

#define LX_GlobeColor JF_RGBA(241, 14, 27, 1)           // 全局颜色
#define LX_GlobeOrangeColor JF_RGBA(246, 116, 45, 1)    // 全局橙色颜色
#define LX_GlobeBgColor JF_RGBA(246, 246, 246, 1)       // 灰色底色
#define LX_GlobeTextBorderColor JF_RGB(187, 187, 187)   // 灰色文本边框颜色

#define LX_WhiteColor [UIColor whiteColor]


/***** Tag *****/
#pragma mark- Tag

#define K_LabelTxtCellTitle_Tag 100
#define K_LabelTxtCellDetail_Tag 101

/***** 通知 *****/
#pragma mark- 通知

#define N_MeHeadIconClick   @"N_MeHeadIconClick"    // 头像点击通知
#define N_ClickTabbar       @"N_ClickTabbar"        // 点击Tabbar我的事件

/***** Count *****/
#pragma mark- Count

#define K_PageCount 20  //每行显示的数量

#pragma mark- key

#endif /* LXdefine_h */
