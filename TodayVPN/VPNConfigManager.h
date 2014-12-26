//
//  VPNConfigManager.h
//  TodayVPN
//
//  Created by liulu on 14/10/11.
//  Copyright (c) 2014年 liulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>
#import "TKeyChain.h"

@interface VPNConfigManager : NSObject

+(NEVPNProtocolIPSec*)newIPSecConfigWithServer:(NSString *)server andUsername:(NSString *)username andPwd:(NSString *)pwd andSecret:(NSString *)secret;

+(void)addConfig:(NEVPNProtocol *)config andDescription:(NSString *)localizedDescription;

@end
