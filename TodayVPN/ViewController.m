//
//  ViewController.m
//  TodayVPN
//
//  Created by liulu on 14/10/11.
//  Copyright (c) 2014年 liulu. All rights reserved.
//

#import "ViewController.h"
#import "VPNConfigManager.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *serverTF;
@property (strong, nonatomic) IBOutlet UITextField *usernameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UITextField *secretTF;


@property (strong, nonatomic) IBOutlet UIButton *btnConnect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"TodayVPN";
    
    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.TodayVPN"];
    self.nameTF.text = [userDefaults objectForKey:@"Name"];
    self.serverTF.text = [userDefaults objectForKey:@"Server"];
    self.usernameTF.text = [userDefaults objectForKey:@"UserName"];
    self.passwordTF.text = [userDefaults objectForKey:@"Pwd"];
    self.secretTF.text = [userDefaults objectForKey:@"Secret"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnConnect:(UIButton *)sender {
    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.TodayVPN"];
    [userDefaults setObject:self.nameTF.text forKey:@"Name"];
    [userDefaults setObject:self.serverTF.text forKey:@"Server"];
    [userDefaults setObject:self.usernameTF.text forKey:@"UserName"];
    [userDefaults setObject:self.passwordTF.text forKey:@"Pwd"];
    [userDefaults setObject:self.secretTF.text forKey:@"Secret"];
    [userDefaults setBool:YES forKey:@"UpdateSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)TextFieldDidEndOnExit:(UITextField *)sender {
    if (sender.tag != 4) {
        [(UITextField*)[self.view viewWithTag:(sender.tag+1)] becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
    }
}


@end
