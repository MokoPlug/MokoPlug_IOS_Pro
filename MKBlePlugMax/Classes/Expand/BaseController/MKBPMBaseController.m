//
//  MKBPMBaseController.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/4/1.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMBaseController.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKBPMCentralManager.h"

@interface MKBPMBaseController ()

@end

@implementation MKBPMBaseController

- (void)dealloc {
    NSLog(@"MKBPMBaseController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotifications];
}

#pragma mark - note
- (void)receiveDeviceLoadChanged:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    if (![MKBaseViewController isCurrentViewControllerVisible:self]) {
        return;
    }
    BOOL load = [userInfo[@"load"] boolValue];
    NSString *msg = (load ? @"Load starts working now!" : @"Load stops working now!");
    [self.view showCentralToast:msg];
}

- (void)deviceOverload:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    if (![MKBaseViewController isCurrentViewControllerVisible:self]) {
        return;
    }
    BOOL overload = [userInfo[@"overload"] boolValue];
    if (!overload) {
        return;
    }
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bpm_needDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5f];
}

- (void)deviceOvercurrent:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    if (![MKBaseViewController isCurrentViewControllerVisible:self]) {
        return;
    }
    BOOL overcurrent = [userInfo[@"overcurrent"] boolValue];
    if (!overcurrent) {
        return;
    }
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bpm_needDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5f];
}

- (void)deviceOvervoltage:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    if (![MKBaseViewController isCurrentViewControllerVisible:self]) {
        return;
    }
    BOOL overvoltage = [userInfo[@"overvoltage"] boolValue];
    if (!overvoltage) {
        return;
    }
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bpm_needDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5f];
}

- (void)deviceUndervoltage:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    if (![MKBaseViewController isCurrentViewControllerVisible:self]) {
        return;
    }
    BOOL undervoltage = [userInfo[@"undervoltage"] boolValue];
    if (!undervoltage) {
        return;
    }
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bpm_needDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5f];
}

#pragma mark - Private method
- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceLoadChanged:)
                                                 name:mk_bpm_deviceLoadStatusChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOverload:)
                                                 name:mk_bpm_receiveOverloadNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOvercurrent:)
                                                 name:mk_bpm_receiveOverCurrentNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOvervoltage:)
                                                 name:mk_bpm_receiveOvervoltageNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceUndervoltage:)
                                                 name:mk_bpm_receiveUndervoltageNotification
                                               object:nil];
}

@end
