//
//  MKBPMInterface.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMInterface.h"

#import "MKBPMCentralManager.h"
#import "MKBPMOperationID.h"
#import "MKBPMOperation.h"
#import "CBPeripheral+MKBPMAdd.h"

#define centralManager [MKBPMCentralManager shared]
#define peripheral ([MKBPMCentralManager shared].peripheral)

@implementation MKBPMInterface

#pragma mark ****************************************Device Service Information************************************************

+ (void)bpm_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bpm_taskReadDeviceModelOperation
                           characteristic:peripheral.bpm_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bpm_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bpm_taskReadMacAddressOperation
                           characteristic:peripheral.bpm_macAddress
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bpm_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bpm_taskReadFirmwareOperation
                           characteristic:peripheral.bpm_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bpm_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bpm_taskReadHardwareOperation
                           characteristic:peripheral.bpm_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bpm_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bpm_taskReadSoftwareOperation
                           characteristic:peripheral.bpm_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bpm_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bpm_taskReadManufacturerOperation
                           characteristic:peripheral.bpm_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark ****************************************Device Parmas************************************************

+ (void)bpm_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadDeviceNameOperation
                     cmdFlag:@"11"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readConnectationNeedPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadConnectationNeedPasswordOperation
                     cmdFlag:@"12"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadPasswordOperation
                     cmdFlag:@"13"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readPowerOnSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadPowerOnSwitchStatusOperation
                     cmdFlag:@"14"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readSwitchReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadSwitchReportIntervalOperation
                     cmdFlag:@"15"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readPowerReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadPowerReportIntervalOperation
                     cmdFlag:@"16"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readIndicatorBleAdvertisingStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadIndicatorBleAdvertisingStatusOperation
                     cmdFlag:@"17"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readIndicatorBleConnectedStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadIndicatorBleConnectedStatusOperation
                     cmdFlag:@"18"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readPowerIndicatorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadPowerIndicatorStatusOperation
                     cmdFlag:@"19"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readPowerIndicatorProtectionSignalWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadPowerIndicatorProtectionSignalOperation
                     cmdFlag:@"1a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadTxPowerOperation
                     cmdFlag:@"1b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readButtonSwitchFunctionWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadButtonSwitchFunctionOperation
                     cmdFlag:@"1d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readResetClearEnergyWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadResetClearEnergyOperation
                     cmdFlag:@"1e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readSpecificationsOfDeviceWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadSpecificationsOfDeviceOperation
                     cmdFlag:@"21"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadAdvIntervalOperation
                     cmdFlag:@"31"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readDeviceConnectableWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadDeviceConnectableOperation
                     cmdFlag:@"32"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readEnergyStorageIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadEnergyStorageIntervalOperation
                     cmdFlag:@"33"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readEnergyStorageChangeThresholdWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadEnergyStorageChangeThresholdOperation
                     cmdFlag:@"34"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readOverLoadProtectionWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadOverLoadProtectionOperation
                     cmdFlag:@"35"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readOverVoltageProtectionWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadOverVoltageProtectionOperation
                     cmdFlag:@"36"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readSagVoltageProtectionWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadSagVoltageProtectionOperation
                     cmdFlag:@"37"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readOverCurrentProtectionWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadOverCurrentProtectionOperation
                     cmdFlag:@"38"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readPowerIndicatorColorWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadPowerIndicatorColorOperation
                     cmdFlag:@"39"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bpm_readLoadStatusNotificationsWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bpm_taskReadLoadStatusNotificationsOperation
                     cmdFlag:@"3a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************Control Parmas************************************************

+ (void)bpm_readSwitchStateWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDeviceControlDataWithTaskID:mk_bpm_taskReadSwitchStateOperation
                                  cmdFlag:@"51"
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bpm_readPowerDataWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDeviceControlDataWithTaskID:mk_bpm_taskReadPowerDataOperation
                                  cmdFlag:@"52"
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bpm_readTotalEnergyDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDeviceControlDataWithTaskID:mk_bpm_taskReadTotalEnergyDataOperation
                                  cmdFlag:@"5c"
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bpm_readMonthlyEnergyDataWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDeviceControlDataWithTaskID:mk_bpm_taskReadMonthlyEnergyDataOperation
                                  cmdFlag:@"5d"
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bpm_readHourlyEnergyDataWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDeviceControlDataWithTaskID:mk_bpm_taskReadHourlyEnergyDataOperation
                                  cmdFlag:@"5e"
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

#pragma mark - private method

+ (void)readDataWithTaskID:(mk_bpm_taskOperationID)taskID
                   cmdFlag:(NSString *)flag
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.bpm_paramConfig
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readDeviceControlDataWithTaskID:(mk_bpm_taskOperationID)taskID
                                cmdFlag:(NSString *)flag
                               sucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.bpm_customConfig
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
