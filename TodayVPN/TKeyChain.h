//
//  TKeyChain.h
//  TodayVPN
//
//  Created by liulu on 14/10/11.
//  Copyright (c) 2014年 liulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service ;

+ (void)save:(NSString *)service data:(id)data ;

+ (id)load:(NSString *)service;
+(NSData *)loadData:(NSString*)service;

+ (void)delete:(NSString *)service;
@end
