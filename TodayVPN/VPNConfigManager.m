//
//  VPNConfigManager.m
//  TodayVPN
//
//  Created by liulu on 14/10/11.
//  Copyright (c) 2014年 liulu. All rights reserved.
//

#import "VPNConfigManager.h"


@implementation VPNConfigManager

+(NEVPNProtocolIPSec*)newIPSecConfigWithServer:(NSString *)server andUsername:(NSString *)username andPwd:(NSString *)pwd andSecret:(NSString *)secret
{
    [TKeyChain save:@"pwd" data:pwd];
    [TKeyChain save:@"secret" data:secret];
    NEVPNProtocolIPSec *p = [[NEVPNProtocolIPSec alloc] init];
    p.username = username;
    p.passwordReference = [TKeyChain loadData:@"pwd"];
    p.serverAddress = server;
    p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
    p.sharedSecretReference = [TKeyChain loadData:@"secret"];
//    p.localIdentifier = @"";@"
//    p.remoteIdentifier = @"";@"
    p.useExtendedAuthentication = YES;
    p.disconnectOnSleep = NO;
    return p;
}

+(void)addConfig:(NEVPNProtocol *)config andDescription:(NSString *)localizedDescription
{
    NEVPNManager* mgr =  [NEVPNManager sharedManager];
    [mgr loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if(error) {
            NSLog(@"Load error: %@", error);
        } else {
            if (mgr.protocol) {
                [mgr removeFromPreferencesWithCompletionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Remove error: %@", error);
                    } else {
                        mgr.protocol = config;
                        mgr.localizedDescription = localizedDescription;
                        [mgr saveToPreferencesWithCompletionHandler:^(NSError *error) {
                            if(error) {
                                NSLog(@"Save error: %@", error);
                            }
                            else {
                                NSLog(@"Saved!");
                            }
                        }];
                    }
                }];
            } else {
                mgr.protocol = config;
                mgr.localizedDescription = localizedDescription;
                [mgr saveToPreferencesWithCompletionHandler:^(NSError *error) {
                    if(error) {
                        NSLog(@"Save error: %@", error);
                    }
                    else {
                        NSLog(@"Saved!");
                    }
                }];
            }
        }
    }];
}

@end
