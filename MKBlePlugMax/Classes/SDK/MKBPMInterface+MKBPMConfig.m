//
//  MKBPMInterface+MKBPMConfig.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMInterface+MKBPMConfig.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKBPMCentralManager.h"
#import "MKBPMOperationID.h"
#import "MKBPMOperation.h"
#import "CBPeripheral+MKBPMAdd.h"
#import "MKBPMSDKDataAdopter.h"

#define centralManager [MKBPMCentralManager shared]

@implementation MKBPMInterface (MKBPMConfig)

#pragma mark ****************************************Device Parmas************************************************

+ (void)bpm_configDeviceName:(NSString *)deviceName
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(deviceName) || deviceName.length > 20) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)deviceName.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"ed0111%@%@",lenString,tempString];
    [self configDataWithTaskID:mk_bpm_taskConfigDeviceNameOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configNeedPassword:(BOOL)need
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (need ? @"ed01120101" : @"ed01120100");
    [self configDataWithTaskID:mk_bpm_taskConfigNeedPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configPassword:(NSString *)password
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(password) || password.length != 8) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandData = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *commandString = [@"ed011308" stringByAppendingString:commandData];
    [self configDataWithTaskID:mk_bpm_taskConfigPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configPowerOnSwitchStatus:(mk_bpm_switchStatus)status
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *string = @"00";
    if (status == mk_bpm_switchStatusPowerOn) {
        string = @"01";
    }else if (status == mk_bpm_switchStatusRevertLast) {
        string = @"02";
    }
    NSString *commandString = [@"ed011401" stringByAppendingString:string];
    [self configDataWithTaskID:mk_bpm_taskConfigPowerOnSwitchStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configSwitchReportInterval:(NSInteger)interval
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 600) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed011502" stringByAppendingString:value];
    [self configDataWithTaskID:mk_bpm_taskConfigSwitchReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configPowerReportInterval:(NSInteger)interval
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 600) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed011602" stringByAppendingString:value];
    [self configDataWithTaskID:mk_bpm_taskConfigPowerReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configIndicatorBleAdvertisingStatus:(BOOL)isOn
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01170101" : @"ed01170100");
    [self configDataWithTaskID:mk_bpm_taskConfigIndicatorBleAdvertisingStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configIndicatorBleConnectedStatus:(mk_bpm_indicatorBleConnectedStatus)status
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = @"00";
    if (status == mk_bpm_indicatorBleConnectedStatus_solidBlueForFiveSeconds) {
        value = @"01";
    }else if (status == mk_bpm_indicatorBleConnectedStatus_solidBlue) {
        value = @"02";
    }
    NSString *commandString = [@"ed011801" stringByAppendingString:value];
    [self configDataWithTaskID:mk_bpm_taskConfigIndicatorBleConnectedStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configPowerIndicatorStatus:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01190101" : @"ed01190100");
    [self configDataWithTaskID:mk_bpm_taskConfigPowerIndicatorStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configPowerIndicatorProtectionSignal:(BOOL)isOn
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed011a0101" : @"ed011a0100");
    [self configDataWithTaskID:mk_bpm_taskConfigPowerIndicatorProtectionSignalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configTxPower:(mk_bpm_txPower)txPower
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [@"ed011b01" stringByAppendingString:[MKBPMSDKDataAdopter fetchTxPower:txPower]];
    [self configDataWithTaskID:mk_bpm_taskConfigTxPowerOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configButtonSwitchFunction:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed011d0101" : @"ed011d0100");
    [self configDataWithTaskID:mk_bpm_taskConfigButtonSwitchFunctionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configResetClearEnergy:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed011e0101" : @"ed011e0100");
    [self configDataWithTaskID:mk_bpm_taskConfigResetClearEnergyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configAdvInterval:(NSInteger)interval
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed013101" stringByAppendingString:value];
    [self configDataWithTaskID:mk_bpm_taskConfigAdvIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configConnectableStatus:(BOOL)connectable
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (connectable ? @"ed01320101" : @"ed01320100");
    [self configDataWithTaskID:mk_bpm_taskConfigConnectableStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configEnergyStorageInterval:(NSInteger)interval
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 60) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed013301" stringByAppendingString:value];
    [self configDataWithTaskID:mk_bpm_taskConfigEnergyStorageIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configEnergyStorageChangeThreshold:(NSInteger)threshold
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 1 || threshold > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *commandString = [@"ed013401" stringByAppendingString:value];
    [self configDataWithTaskID:mk_bpm_taskConfigEnergyStorageChangeThresholdOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configOverLoad:(BOOL)isOn
              productModel:(mk_bpm_productModel)productModel
             overThreshold:(NSInteger)overThreshold
             timeThreshold:(NSInteger)timeThreshold
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSInteger minValue = 10;
    NSInteger maxValue = 4416;
    if (productModel == mk_bpm_productModel_America) {
        //美规
        minValue = 10;
        maxValue = 2160;
    }else if (productModel == mk_bpm_productModel_UK) {
        //英规
        minValue = 10;
        maxValue = 3588;
    }
    if (overThreshold < minValue || overThreshold > maxValue || timeThreshold < 1 || timeThreshold > 30) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *status = (isOn ? @"01" : @"00");
    NSString *overValueString = [MKBLEBaseSDKAdopter fetchHexValue:overThreshold byteLen:2];
    NSString *timeValueString = [MKBLEBaseSDKAdopter fetchHexValue:timeThreshold byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed013504",status,overValueString,timeValueString];
    [self configDataWithTaskID:mk_bpm_taskConfigOverLoadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configOverVoltage:(BOOL)isOn
                 productModel:(mk_bpm_productModel)productModel
                overThreshold:(NSInteger)overThreshold
                timeThreshold:(NSInteger)timeThreshold
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSInteger minValue = 231;
    NSInteger maxValue = 264;
    if (productModel == mk_bpm_productModel_America) {
        //美规
        minValue = 121;
        maxValue = 138;
    }
    if (overThreshold < minValue || overThreshold > maxValue || timeThreshold < 1 || timeThreshold > 30) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *status = (isOn ? @"01" : @"00");
    NSString *overValueString = [MKBLEBaseSDKAdopter fetchHexValue:overThreshold byteLen:2];
    NSString *timeValueString = [MKBLEBaseSDKAdopter fetchHexValue:timeThreshold byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed013604",status,overValueString,timeValueString];
    [self configDataWithTaskID:mk_bpm_taskConfigOverVoltageOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configSagVoltage:(BOOL)isOn
                productModel:(mk_bpm_productModel)productModel
               overThreshold:(NSInteger)overThreshold
               timeThreshold:(NSInteger)timeThreshold
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSInteger minValue = 196;
    NSInteger maxValue = 229;
    if (productModel == mk_bpm_productModel_America) {
        //美规
        minValue = 102;
        maxValue = 119;
    }
    if (overThreshold < minValue || overThreshold > maxValue || timeThreshold < 1 || timeThreshold > 30) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *status = (isOn ? @"01" : @"00");
    NSString *overValueString = [MKBLEBaseSDKAdopter fetchHexValue:overThreshold byteLen:1];
    NSString *timeValueString = [MKBLEBaseSDKAdopter fetchHexValue:timeThreshold byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed013703",status,overValueString,timeValueString];
    [self configDataWithTaskID:mk_bpm_taskConfigSagVoltageOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configOverCurrent:(BOOL)isOn
                 productModel:(mk_bpm_productModel)productModel
                overThreshold:(NSInteger)overThreshold
                timeThreshold:(NSInteger)timeThreshold
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSInteger minValue = 1;
    NSInteger maxValue = 192;
    if (productModel == mk_bpm_productModel_America) {
        //美规
        minValue = 1;
        maxValue = 180;
    }else if (productModel == mk_bpm_productModel_UK) {
        //英规
        minValue = 1;
        maxValue = 156;
    }
    if (overThreshold < minValue || overThreshold > maxValue || timeThreshold < 1 || timeThreshold > 30) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *status = (isOn ? @"01" : @"00");
    NSString *overValueString = [MKBLEBaseSDKAdopter fetchHexValue:overThreshold byteLen:1];
    NSString *timeValueString = [MKBLEBaseSDKAdopter fetchHexValue:timeThreshold byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed013803",status,overValueString,timeValueString];
    [self configDataWithTaskID:mk_bpm_taskConfigOverCurrentOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configPowerIndicatorColor:(mk_bpm_ledColorType)colorType
                        colorProtocol:(nullable id <mk_bpm_ledColorConfigProtocol>)protocol
                         productModel:(mk_bpm_productModel)productModel
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKBPMSDKDataAdopter checkLEDColorParams:colorType colorProtocol:protocol productModel:productModel]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeString = [MKBLEBaseSDKAdopter fetchHexValue:colorType byteLen:1];
    NSString *blue = [MKBLEBaseSDKAdopter fetchHexValue:protocol.b_color byteLen:2];
    NSString *green = [MKBLEBaseSDKAdopter fetchHexValue:protocol.g_color byteLen:2];
    NSString *yellow = [MKBLEBaseSDKAdopter fetchHexValue:protocol.y_color byteLen:2];
    NSString *orange = [MKBLEBaseSDKAdopter fetchHexValue:protocol.o_color byteLen:2];
    NSString *red = [MKBLEBaseSDKAdopter fetchHexValue:protocol.r_color byteLen:2];
    NSString *purple = [MKBLEBaseSDKAdopter fetchHexValue:protocol.p_color byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"ed01390d",typeString,blue,green,yellow,orange,red,purple];
    [self configDataWithTaskID:mk_bpm_taskConfigPowerIndicatorColorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bpm_configLoadStatusNotifications:(BOOL)startIsOn
                                 stopIsOn:(BOOL)stopIsOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *startValue = (startIsOn ? @"01" : @"00");
    NSString *stopValue = (stopIsOn ? @"01" : @"00");
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed013a02",startValue,stopValue];
    [self configDataWithTaskID:mk_bpm_taskConfigLoadStatusNotificationsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************Control Parmas************************************************

+ (void)bpm_configSwitchState:(BOOL)isOn
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01510101" : @"ed01510100");
    [self configDeviceControlDataWithTaskID:mk_bpm_taskConfigSwitchStateOperation
                                       data:commandString
                                   sucBlock:sucBlock
                                failedBlock:failedBlock];
}

+ (void)bpm_clearOverloadWithSucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed015700";
    [self configDeviceControlDataWithTaskID:mk_bpm_taskClearOverloadOperation
                                       data:commandString
                                   sucBlock:sucBlock
                                failedBlock:failedBlock];
}

+ (void)bpm_clearOvercurrentWithSucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed015800";
    [self configDeviceControlDataWithTaskID:mk_bpm_taskClearOvercurrentOperation
                                       data:commandString
                                   sucBlock:sucBlock
                                failedBlock:failedBlock];
}

+ (void)bpm_clearOvervoltageWithSucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed015900";
    [self configDeviceControlDataWithTaskID:mk_bpm_taskClearOvervoltageOperation
                                       data:commandString
                                   sucBlock:sucBlock
                                failedBlock:failedBlock];
}

+ (void)bpm_clearUndervoltageWithSucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed015a00";
    [self configDeviceControlDataWithTaskID:mk_bpm_taskClearUndervoltageOperation
                                       data:commandString
                                   sucBlock:sucBlock
                                failedBlock:failedBlock];
}

+ (void)bpm_configCountdown:(NSInteger)second
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (second < 1 || second > 86400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:second byteLen:4];
    NSString *commandString = [@"ed015b04" stringByAppendingString:value];
    [self configDeviceControlDataWithTaskID:mk_bpm_taskConfigCountdownOperation
                                       data:commandString
                                   sucBlock:sucBlock
                                failedBlock:failedBlock];
}

+ (void)bpm_clearAllEnergyDatasWithSucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed015f00";
    [self configDeviceControlDataWithTaskID:mk_bpm_taskClearAllEnergyDatasOperation
                                       data:commandString
                                   sucBlock:sucBlock
                                failedBlock:failedBlock];
}

+ (void)bpm_configDeviceTime:(id <mk_bpm_deviceTimeProtocol>)protocol
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKBPMSDKDataAdopter validTimeProtocol:protocol]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    
    NSString *time = [MKBPMSDKDataAdopter getTimeString:protocol];
    if (!MKValidStr(time)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed016107" stringByAppendingString:time];
    [self configDeviceControlDataWithTaskID:mk_bpm_taskConfigDeviceTimeOperation
                                       data:commandString
                                   sucBlock:sucBlock
                                failedBlock:failedBlock];
}

+ (void)bpm_factoryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed016200";
    [self configDeviceControlDataWithTaskID:mk_bpm_taskFactoryResetOperation
                                       data:commandString
                                   sucBlock:sucBlock
                                failedBlock:failedBlock];
}

#pragma mark - private method
+ (void)configDataWithTaskID:(mk_bpm_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:centralManager.peripheral.bpm_paramConfig commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

+ (void)configDeviceControlDataWithTaskID:(mk_bpm_taskOperationID)taskID
                                     data:(NSString *)data
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:centralManager.peripheral.bpm_customConfig commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

@end
