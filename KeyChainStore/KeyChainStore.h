//
//  KeyChainStore.h
//  CYUUIDByKeychainSave
//
//  Created by 须臾以北 on 16/5/10.
//  Copyright © 2016年 com.cy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
