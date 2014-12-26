//
//  TodayViewController.m
//  TodayVPNExtension
//
//  Created by liulu on 14/10/11.
//  Copyright (c) 2014年 liulu. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "VPNConfigManager.h"

#define BTN_NORMAL_COLOR [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:105.0f/255.0f alpha:0.6f]
#define BTN_HIGHTLIGHT_COLOR [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:210.0f/255.0f alpha:0.8f]

@interface TodayViewController () <NCWidgetProviding>
@property (strong, nonatomic) IBOutlet UILabel *lblState;
@property (strong, nonatomic) IBOutlet UIButton *btnConnect;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.preferredContentSize = CGSizeMake(self.preferredContentSize.width, 52);
    self.btnConnect.layer.cornerRadius = 24.0f;
    self.btnConnect.layer.masksToBounds = YES;
    self.btnConnect.backgroundColor = BTN_NORMAL_COLOR;
    
    [self vpnConnectionStatusChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnConnectionStatusChanged) name:NEVPNStatusDidChangeNotification object:nil];
    
    NEVPNManager *mgr = [NEVPNManager sharedManager];
    [mgr loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if(error) {
            NSLog(@"Load error: %@", error);
        } else {
            NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.TodayVPN"];
            BOOL update = [userDefaults boolForKey:@"UpdateSetting"];
            if ((!mgr.protocol && [userDefaults objectForKey:@"Server"]) || update) {
                [userDefaults setBool:NO forKey:@"UpdateSetting"];
                NSString *server = [userDefaults objectForKey:@"Server"];
                NSString *username = [userDefaults objectForKey:@"UserName"];
                NSString *pwd = [userDefaults objectForKey:@"Pwd"];
                NSString *secret = [userDefaults objectForKey:@"Secret"];
                NSString *name = [userDefaults objectForKey:@"Name"];
                NEVPNProtocolIPSec *p = [VPNConfigManager newIPSecConfigWithServer:server andUsername:username andPwd:pwd andSecret:secret];
                [VPNConfigManager addConfig:p andDescription:name];
            }
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    [self vpnConnectionStatusChanged];
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    completionHandler(NCUpdateResultNewData);
}


- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(10, 5, 10, 10);
}

- (IBAction)btnConnect:(UIButton *)sender {
    NSError *startError;
    if ([NEVPNManager sharedManager].connection.status == NEVPNStatusConnected) {
        [[NEVPNManager sharedManager].connection stopVPNTunnel];
    } else if([NEVPNManager sharedManager].connection.status == NEVPNStatusDisconnected){
        [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:&startError];
        if(startError) {
            NSLog(@"Start error: %@", startError.localizedDescription);
        } else {
        }
    }
}

- (void)vpnConnectionStatusChanged
{
    switch ([NEVPNManager sharedManager].connection.status) {
        case NEVPNStatusInvalid:
        {
            self.lblState.text = @"Invalid";
            self.btnConnect.backgroundColor = BTN_NORMAL_COLOR;
        }
            break;
        case NEVPNStatusDisconnected:
        {
            self.lblState.text = @"Disconnected";
            self.btnConnect.backgroundColor = BTN_NORMAL_COLOR;
        }
            break;
        case NEVPNStatusConnecting:
        {
            self.lblState.text = @"Connecting";
            self.btnConnect.backgroundColor = BTN_HIGHTLIGHT_COLOR;
        }
            break;
        case NEVPNStatusConnected:
        {
            self.lblState.text = @"Connected";
            self.btnConnect.backgroundColor = BTN_HIGHTLIGHT_COLOR;
        }
            break;
        case NEVPNStatusReasserting:
        {
            self.lblState.text = @"Reasserting";
            self.btnConnect.backgroundColor = BTN_HIGHTLIGHT_COLOR;
        }
            break;
        case NEVPNStatusDisconnecting:
        {
            self.lblState.text = @"Disconnecting";
            self.btnConnect.backgroundColor = BTN_HIGHTLIGHT_COLOR;
        }
            break;
        default:
        {
            self.lblState.text = @"Status";
            self.btnConnect.backgroundColor = BTN_NORMAL_COLOR;
        }
            break;
    }
}

@end
