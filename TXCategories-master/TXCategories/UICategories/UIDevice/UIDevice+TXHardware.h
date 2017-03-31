//
//  UIDevice+Hardware.h
//  TestTable
//
//  Created by Inder Kumar Rathore on 19/01/13.
//  Copyright (c) 2013 Rathore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDevice (TXHardware)
+ (NSString *)tx_platform;
+ (NSString *)tx_platformString;


+ (NSString *)tx_macAddress;

//Return the current device CPU frequency
+ (NSUInteger)tx_cpuFrequency;
// Return the current device BUS frequency
+ (NSUInteger)tx_busFrequency;
//current device RAM size
+ (NSUInteger)tx_ramSize;
//Return the current device CPU number
+ (NSUInteger)tx_cpuNumber;
//Return the current device total memory

/// 获取iOS系统的版本号
+ (NSString *)tx_systemVersion;
/// 判断当前系统是否有摄像头
+ (BOOL)tx_hasCamera;
/// 获取手机内存总量, 返回的是字节数
+ (NSUInteger)tx_totalMemoryBytes;
/// 获取手机可用内存, 返回的是字节数
+ (NSUInteger)tx_freeMemoryBytes;

/// 获取手机硬盘空闲空间, 返回的是字节数
+ (long long)tx_freeDiskSpaceBytes;
/// 获取手机硬盘总空间, 返回的是字节数
+ (long long)tx_totalDiskSpaceBytes;
@end
