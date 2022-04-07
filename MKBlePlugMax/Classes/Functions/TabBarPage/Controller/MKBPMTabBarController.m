//
//  MKBPMTabBarController.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMTabBarController.h"

#import "MKMacroDefines.h"
#import "MKBaseNavigationController.h"

#import "MKAlertController.h"

#import "MKBPMSwitchController.h"
#import "MKBPMPowerController.h"
#import "MKBPMEnergyController.h"

#import "MKBPMCentralManager.h"

@interface MKBPMTabBarController ()

/// 当触发
/// 01:表示连接成功后，1分钟内没有通过密码验证（未输入密码，或者连续输入密码错误）认为超时，返回结果， 然后断开连接
/// 02:修改密码成功后，返回结果，断开连接
/// 04:重启设备，就不需要显示断开连接的弹窗了，只需要显示对应的弹窗
@property (nonatomic, assign)BOOL disconnectType;

@end

@implementation MKBPMTabBarController

- (void)dealloc {
    NSLog(@"MKBPMTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKBPMCentralManager shared] disconnect];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubPages];
    [self addNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leftButtonMethod)
                                                 name:@"mk_bpm_popToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dfuUpdateComplete)
                                                 name:@"mk_bpm_centralDeallocNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:mk_bpm_centralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:mk_bpm_deviceDisconnectTypeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_bpm_peripheralConnectStateChangedNotification
                                               object:nil];
}

#pragma mark - notes
- (void)leftButtonMethod {
    NSString *msg = @"Please confirm again whether to disconnect the device";
    MKAlertController *alert = [MKAlertController alertControllerWithTitle:@""
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    alert.notificationName = @"mk_bpm_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self gotoScanPage];
    }];
    [alert addAction:moreAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)gotoScanPage {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_bpm_needResetScanDelegate:)]) {
            [self.delegate mk_bpm_needResetScanDelegate:NO];
        }
    }];
}

- (void)dfuUpdateComplete {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_bpm_needResetScanDelegate:)]) {
            [self.delegate mk_bpm_needResetScanDelegate:YES];
        }
    }];
}

- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    /// 01:表示连接成功后，1分钟内没有通过密码验证（未输入密码，或者连续输入密码错误）认为超时，返回结果， 然后断开连接
    /// 02:修改密码成功后，返回结果，断开连接
    /// 04:重启设备，就不需要显示断开连接的弹窗了，只需要显示对应的弹窗
    self.disconnectType = YES;
    if ([type isEqualToString:@"02"]) {
        [self showAlertWithMsg:@"Password changed successfully! Please reconnect the device." title:@"Change Password"];
        return;
    }
    if ([type isEqualToString:@"04"]) {
        [self showAlertWithMsg:@"Reboot successfully!Please reconnect the device." title:@"Dismiss"];
        return;
    }
}

- (void)centralManagerStateChanged{
    if (self.disconnectType) {
        return;
    }
    if ([MKBPMCentralManager shared].centralStatus != mk_bpm_centralManagerStatusEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!" title:@"Dismiss"];
    }
}

- (void)deviceConnectStateChanged {
     if (self.disconnectType) {
        return;
    }
    [self showAlertWithMsg:@"The device is disconnected." title:@"Dismiss"];
    return;
}

#pragma mark - private method
- (void)showAlertWithMsg:(NSString *)msg title:(NSString *)title{
    MKAlertController *alertController = [MKAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self gotoScanPage];
    }];
    [alertController addAction:moreAction];
    
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bpm_needDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    [self performSelector:@selector(presentAlert:) withObject:alertController afterDelay:2.0f];
}

- (void)presentAlert:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadSubPages {
    MKBPMSwitchController *switchPage = [[MKBPMSwitchController alloc] init];
    switchPage.tabBarItem.title = @"Switch";
    switchPage.tabBarItem.image = LOADICON(@"MKBlePlugMax", @"MKBPMTabBarController", @"bpm_switchTabBarItemUnselectedIcon.png");
    switchPage.tabBarItem.selectedImage = LOADICON(@"MKBlePlugMax", @"MKBPMTabBarController", @"bpm_switchTabBarItemSelectedIcon.png");
    MKBaseNavigationController *switchNav = [[MKBaseNavigationController alloc] initWithRootViewController:switchPage];

    MKBPMPowerController *powerPage = [[MKBPMPowerController alloc] init];
    powerPage.tabBarItem.title = @"Power";
    powerPage.tabBarItem.image = LOADICON(@"MKBlePlugMax", @"MKBPMTabBarController", @"bpm_powerTabBarItemUnselected.png");
    powerPage.tabBarItem.selectedImage = LOADICON(@"MKBlePlugMax", @"MKBPMTabBarController", @"bpm_powerTabBarItemSelected.png");
    MKBaseNavigationController *powerNav = [[MKBaseNavigationController alloc] initWithRootViewController:powerPage];

    MKBPMEnergyController *energyPage = [[MKBPMEnergyController alloc] init];
    energyPage.tabBarItem.title = @"Energy";
    energyPage.tabBarItem.image = LOADICON(@"MKBlePlugMax", @"MKBPMTabBarController", @"bpm_energyTabBarItemUnselected.png");
    energyPage.tabBarItem.selectedImage = LOADICON(@"MKBlePlugMax", @"MKBPMTabBarController", @"bpm_energyTabBarItemSelected.png");
    MKBaseNavigationController *energyNav = [[MKBaseNavigationController alloc] initWithRootViewController:energyPage];
    
    self.viewControllers = @[switchNav,powerNav,energyNav];
}

@end
