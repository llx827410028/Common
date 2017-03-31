//
//  ZUtilsDevice.m
//  PaixieMall
//
//  Created by zhwx on 15/1/7.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import "LXUtilsDevice.h"
#import <SystemConfiguration/CaptiveNetwork.h>
//#include <sys/socket.h>
//#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>
#include <sys/utsname.h>

@implementation LXUtilsDevice
/**
 * 是否为Retina屏幕
 */
+ (BOOL)isRetina
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 * 是否为3.5吋Retina屏幕
 */
+ (BOOL)isRetina3Inch
{
    if ([[UIScreen mainScreen] bounds].size.height==480) {
        return [self isRetina];
    }
    return NO;
}

/**
 * 是否为4吋Retina屏幕
 */
+ (BOOL)isRetina4Inch
{
    if ([[UIScreen mainScreen] bounds].size.height==568) {
        return [self isRetina];
    }
    return NO;
}


/**
 * 是否为4.7吋Retina屏幕
 */
+ (BOOL)isRetina6pInch{
    NSLog(@"[UIScreen mainScreen] bounds].size.height -->%f",[[UIScreen mainScreen] bounds].size.height);
    if ([[UIScreen mainScreen] bounds].size.height==736) {
        return [self isRetina];
    }
    return NO;
}
/**
 * 是否为5.5吋Retina屏幕
 */
+ (BOOL)isRetina6Inch{
    if ([[UIScreen mainScreen] bounds].size.height==667) {
        return [self isRetina];
    }
    return NO;
}

/**
 * 获得设备操作系统版本
 */
+ (CGFloat)deviceSystemVersion
{
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    return systemVersion;
}

/**
 * 获得设备类型
 */
+ (NSString *)deviceModel
{
    NSString *device = [UIDevice currentDevice].model;
    return device;
}

/**
 * 获得设备型号
 */
- (NSString*)deviceMachine
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

/**
 * 获得设备当前连接到的WIFI SSID
 */
+ (NSString *)fetchCurrentSSID
{
    CFArrayRef cfArray = CNCopySupportedInterfaces();
    
    NSArray *ifs = (__bridge id)cfArray;
    
    id info = nil;
    
    for (NSString *ifnam in ifs) {
        
        CFDictionaryRef tInfo = CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        info = (__bridge id)tInfo;
        
        if (info && [info count]) {
            break;
            
        }
    }
    
    NSDictionary *dctySSID = (NSDictionary *)info;
    
    NSString *ssid = [[dctySSID objectForKey:@"SSID"] lowercaseString];
    
    CFRelease(cfArray);
    
    return ssid;
}

@end
