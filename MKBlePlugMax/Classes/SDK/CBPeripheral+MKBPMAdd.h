//
//  CBPeripheral+MKBPMAdd.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKBPMAdd)

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bpm_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bpm_deviceModel;

@property (nonatomic, strong, readonly)CBCharacteristic *bpm_macAddress;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bpm_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bpm_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bpm_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *bpm_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *bpm_notify;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *bpm_paramConfig;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *bpm_customConfig;

- (void)bpm_updateCharacterWithService:(CBService *)service;

- (void)bpm_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)bpm_connectSuccess;

- (void)bpm_setNil;

@end

NS_ASSUME_NONNULL_END
