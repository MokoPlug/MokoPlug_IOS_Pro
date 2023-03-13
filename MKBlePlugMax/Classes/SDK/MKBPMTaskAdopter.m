//
//  MKBPMTaskAdopter.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMTaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKBPMOperationID.h"
#import "MKBPMSDKDataAdopter.h"

@implementation MKBPMTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"modeID":tempString} operationID:mk_bpm_taskReadDeviceModelOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]]) {
        //Mac地址
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"macAddress":tempString} operationID:mk_bpm_taskReadMacAddressOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"firmware":tempString} operationID:mk_bpm_taskReadFirmwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"hardware":tempString} operationID:mk_bpm_taskReadHardwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
        //soft ware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"software":tempString} operationID:mk_bpm_taskReadSoftwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"manufacturer":tempString} operationID:mk_bpm_taskReadManufacturerOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //密码相关
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *state = @"";
        if (content.length == 10) {
            state = [content substringWithRange:NSMakeRange(8, 2)];
        }
        return [self dataParserGetDataSuccess:@{@"state":state} operationID:mk_bpm_connectPasswordOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        return [self parseCustomData:readData];
    }
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    return @{};
}

#pragma mark - 数据解析
+ (NSDictionary *)parseCustomData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    if (![[readString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"ed"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parseCustomReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseCustomConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_bpm_taskOperationID operationID = mk_bpm_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    
    if ([cmd isEqualToString:@"01"]) {
        
    }else if ([cmd isEqualToString:@"11"]) {
        //读取设备广播名称
        NSData *nameData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
        NSString *deviceName = [[NSString alloc] initWithData:nameData encoding:NSUTF8StringEncoding];
        resultDic = @{
            @"deviceName":(MKValidStr(deviceName) ? deviceName : @""),
        };
        operationID = mk_bpm_taskReadDeviceNameOperation;
    }else if ([cmd isEqualToString:@"12"]) {
        //读取密码开关
        BOOL need = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"need":@(need)
        };
        operationID = mk_bpm_taskReadConnectationNeedPasswordOperation;
    }else if ([cmd isEqualToString:@"13"]) {
        //读取密码
        NSData *passwordData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
        NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        resultDic = @{
            @"password":(MKValidStr(password) ? password : @""),
        };
        operationID = mk_bpm_taskReadPasswordOperation;
    }else if ([cmd isEqualToString:@"14"]) {
        //读取默认开关状态
        resultDic = @{
            @"mode":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_bpm_taskReadPowerOnSwitchStatusOperation;
    }else if ([cmd isEqualToString:@"15"]) {
        //读取开关状态上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_bpm_taskReadSwitchReportIntervalOperation;
    }else if ([cmd isEqualToString:@"16"]) {
        //读取电量上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_bpm_taskReadPowerReportIntervalOperation;
    }else if ([cmd isEqualToString:@"17"]) {
        //读取网络指示灯广播状态开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_bpm_taskReadIndicatorBleAdvertisingStatusOperation;
    }else if ([cmd isEqualToString:@"18"]) {
        //读取网络指示灯连接状态
        resultDic = @{
            @"status":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_bpm_taskReadIndicatorBleConnectedStatusOperation;
    }else if ([cmd isEqualToString:@"19"]) {
        //读取电源指示灯开关指示
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_bpm_taskReadPowerIndicatorStatusOperation;
    }else if ([cmd isEqualToString:@"1a"]) {
        //读取电源指示灯保护触发指示
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_bpm_taskReadPowerIndicatorProtectionSignalOperation;
    }else if ([cmd isEqualToString:@"1b"]) {
        //读取设备Tx Power
        NSString *txPower = [MKBPMSDKDataAdopter fetchTxPowerValueString:content];
        resultDic = @{@"txPower":txPower};
        operationID = mk_bpm_taskReadTxPowerOperation;
    }else if ([cmd isEqualToString:@"1c"]) {
        //读取按键恢复出厂设置
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_bpm_taskReadResetByButtonOperation;
    }else if ([cmd isEqualToString:@"1d"]) {
        //读取按键控制功能开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_bpm_taskReadButtonSwitchFunctionOperation;
    }else if ([cmd isEqualToString:@"1e"]) {
        //读取恢复出厂设置的时候是否清除电能
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_bpm_taskReadResetClearEnergyOperation;
    }else if ([cmd isEqualToString:@"21"]) {
        //读取设备规格
        resultDic = @{
            @"specification":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_bpm_taskReadSpecificationsOfDeviceOperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //读取广播间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_bpm_taskReadAdvIntervalOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //读取可连接状态
        BOOL connectable = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"connectable":@(connectable)
        };
        operationID = mk_bpm_taskReadDeviceConnectableOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //读取电能存储间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_bpm_taskReadEnergyStorageIntervalOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //读取功率变化存储阈值
        resultDic = @{
            @"threshold":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_bpm_taskReadEnergyStorageChangeThresholdOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //读取过载保护信息
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *overThreshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *timeThreshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 2)];
        resultDic = @{
            @"isOn":@(isOn),
            @"overThreshold":overThreshold,
            @"timeThreshold":timeThreshold,
        };
        operationID = mk_bpm_taskReadOverLoadProtectionOperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //读取过压保护信息
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *overThreshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *timeThreshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 2)];
        resultDic = @{
            @"isOn":@(isOn),
            @"overThreshold":overThreshold,
            @"timeThreshold":timeThreshold,
        };
        operationID = mk_bpm_taskReadOverVoltageProtectionOperation;
    }else if ([cmd isEqualToString:@"37"]) {
        //读取欠压保护信息
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *overThreshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        NSString *timeThreshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)];
        resultDic = @{
            @"isOn":@(isOn),
            @"overThreshold":overThreshold,
            @"timeThreshold":timeThreshold,
        };
        operationID = mk_bpm_taskReadUnderVoltageProtectionOperation;
    }else if ([cmd isEqualToString:@"38"]) {
        //读取过流保护信息
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *overThreshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        NSString *timeThreshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)];
        resultDic = @{
            @"isOn":@(isOn),
            @"overThreshold":overThreshold,
            @"timeThreshold":timeThreshold,
        };
        operationID = mk_bpm_taskReadOverCurrentProtectionOperation;
    }else if ([cmd isEqualToString:@"39"]) {
        //读取功率指示灯
        NSString *colorType = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *blue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *green = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        NSString *yellow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 4)];
        NSString *orange = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(14, 4)];
        NSString *red = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(18, 4)];
        NSString *purple = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(22, 4)];
        resultDic = @{
            @"colorType":colorType,
            @"blue":blue,
            @"green":green,
            @"yellow":yellow,
            @"orange":orange,
            @"red":red,
            @"purple":purple,
        };
        operationID = mk_bpm_taskReadPowerIndicatorColorOperation;
    }else if ([cmd isEqualToString:@"3a"]) {
        //读取负载通知开关
        BOOL loadStart = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        BOOL loadStop = ([[content substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"01"]);
        resultDic = @{
            @"loadStart":@(loadStart),
            @"loadStop":@(loadStop),
        };
        operationID = mk_bpm_taskReadLoadStatusNotificationsOperation;
    }else if ([cmd isEqualToString:@"51"]) {
        //读取开关状态
        BOOL switchIsOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        BOOL overload = ([[content substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"01"]);
        BOOL overcurrent = ([[content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"01"]);
        BOOL overvoltage = ([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"]);
        BOOL undervoltage = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"]);
        resultDic = @{
            @"switchIsOn":@(switchIsOn),
            @"overload":@(overload),
            @"overcurrent":@(overcurrent),
            @"overvoltage":@(overvoltage),
            @"undervoltage":@(undervoltage),
        };
        operationID = mk_bpm_taskReadSwitchStateOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //读取电量数据
        NSInteger voltageValue = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(0, 4)];
        NSString *voltage = [NSString stringWithFormat:@"%.1f",(voltageValue * 0.1)];
        
        NSNumber *currentNumer = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(4, 4)]];
        NSString *current = [NSString stringWithFormat:@"%ld",(long)[currentNumer integerValue]];
        
        NSNumber *activePowerNumber = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(8, 8)]];
        NSString *power = [NSString stringWithFormat:@"%.1f",([activePowerNumber integerValue] * 0.1)];
        
        NSInteger currentFrequencyValue = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(16, 4)];
        NSString *frequencyOfCurrent = [NSString stringWithFormat:@"%.2f",(currentFrequencyValue * 0.01)];
        
        NSInteger powerFactorValue = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(20, 2)];
        NSString *powerFactor = [NSString stringWithFormat:@"%.2f",(powerFactorValue * 0.01)];
        
        resultDic = @{
            @"voltage":voltage,
            @"current":current,
            @"power":power,
            @"frequencyOfCurrent":frequencyOfCurrent,
            @"powerFactor":powerFactor,
        };
        operationID = mk_bpm_taskReadPowerDataOperation;
    }else if ([cmd isEqualToString:@"5c"]) {
        //查询总累计电能数据
        NSInteger energy = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"total":[NSString stringWithFormat:@"%.3f",(energy * 0.001)],
        };
        operationID = mk_bpm_taskReadTotalEnergyDataOperation;
    }else if ([cmd isEqualToString:@"5d"]) {
        //查询最近30天的电能数据
        resultDic = [MKBPMSDKDataAdopter parseDailyEnergyDatas:content];
        operationID = mk_bpm_taskReadMonthlyEnergyDataOperation;
    }else if ([cmd isEqualToString:@"5e"]) {
        //查询当天每小时电能数据
        resultDic = [MKBPMSDKDataAdopter parseHourlyEnergyDatas:content];
        operationID = mk_bpm_taskReadHourlyEnergyDataOperation;
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_bpm_taskOperationID operationID = mk_bpm_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"01"];
    
    if ([cmd isEqualToString:@"01"]) {
//        配置LoRaWAN入网类型
//        operationID = mk_bpm_taskConfigModemOperation;
    }else if ([cmd isEqualToString:@"11"]) {
        //配置设备名称
        operationID = mk_bpm_taskConfigDeviceNameOperation;
    }else if ([cmd isEqualToString:@"12"]) {
        //配置密码开关
        operationID = mk_bpm_taskConfigNeedPasswordOperation;
    }else if ([cmd isEqualToString:@"13"]) {
        //修改密码
        operationID = mk_bpm_taskConfigPasswordOperation;
    }else if ([cmd isEqualToString:@"14"]) {
        //配置默认开关状态
        operationID = mk_bpm_taskConfigPowerOnSwitchStatusOperation;
    }else if ([cmd isEqualToString:@"15"]) {
        //配置开关状态上报间隔
        operationID = mk_bpm_taskConfigSwitchReportIntervalOperation;
    }else if ([cmd isEqualToString:@"16"]) {
        //配置电量上报间隔
        operationID = mk_bpm_taskConfigPowerReportIntervalOperation;
    }else if ([cmd isEqualToString:@"17"]) {
        //配置网络指示灯广播状态开关
        operationID = mk_bpm_taskConfigIndicatorBleAdvertisingStatusOperation;
    }else if ([cmd isEqualToString:@"18"]) {
        //配置网络指示灯连接状态
        operationID = mk_bpm_taskConfigIndicatorBleConnectedStatusOperation;
    }else if ([cmd isEqualToString:@"19"]) {
        //配置电源指示灯开关指示
        operationID = mk_bpm_taskConfigPowerIndicatorStatusOperation;
    }else if ([cmd isEqualToString:@"1a"]) {
        //配置电源指示灯保护触发指示
        operationID = mk_bpm_taskConfigPowerIndicatorProtectionSignalOperation;
    }else if ([cmd isEqualToString:@"1b"]) {
        //配置TxPower
        operationID = mk_bpm_taskConfigTxPowerOperation;
    }else if ([cmd isEqualToString:@"1c"]) {
        //配置按键恢复出厂设置
        operationID = mk_bpm_taskConfigResetByButtonOperation;
    }else if ([cmd isEqualToString:@"1d"]) {
        //配置按键控制功能开关
        operationID = mk_bpm_taskConfigButtonSwitchFunctionOperation;
    }else if ([cmd isEqualToString:@"1e"]) {
        //配置恢复出厂设置是否清除电能数据
        operationID = mk_bpm_taskConfigResetClearEnergyOperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //配置广播间隔
        operationID = mk_bpm_taskConfigAdvIntervalOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //配置可连接状态
        operationID = mk_bpm_taskConfigConnectableStatusOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //配置电能存储间隔
        operationID = mk_bpm_taskConfigEnergyStorageIntervalOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //配置功率变化存储阈值
        operationID = mk_bpm_taskConfigEnergyStorageChangeThresholdOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //配置过载保护信息
        operationID = mk_bpm_taskConfigOverLoadOperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //配置过压保护信息
        operationID = mk_bpm_taskConfigOverVoltageOperation;
    }else if ([cmd isEqualToString:@"37"]) {
        //配置欠压保护信息
        operationID = mk_bpm_taskConfigUnderVoltageOperation;
    }else if ([cmd isEqualToString:@"38"]) {
        //配置过流保护信息
        operationID = mk_bpm_taskConfigOverCurrentOperation;
    }else if ([cmd isEqualToString:@"39"]) {
        //配置功率指示灯颜色
        operationID = mk_bpm_taskConfigPowerIndicatorColorOperation;
    }else if ([cmd isEqualToString:@"3a"]) {
        //配置负载通知开关
        operationID = mk_bpm_taskConfigLoadStatusNotificationsOperation;
    }else if ([cmd isEqualToString:@"51"]) {
        //配置开关状态
        operationID = mk_bpm_taskConfigSwitchStateOperation;
    }else if ([cmd isEqualToString:@"57"]) {
        //解除过载状态
        operationID = mk_bpm_taskClearOverloadOperation;
    }else if ([cmd isEqualToString:@"58"]) {
        //解除过流状态
        operationID = mk_bpm_taskClearOvercurrentOperation;
    }else if ([cmd isEqualToString:@"59"]) {
        //解除过压状态
        operationID = mk_bpm_taskClearOvervoltageOperation;
    }else if ([cmd isEqualToString:@"5a"]) {
        //解除欠压状态
        operationID = mk_bpm_taskClearUndervoltageOperation;
    }else if ([cmd isEqualToString:@"5b"]) {
        //配置倒计时
        operationID = mk_bpm_taskConfigCountdownOperation;
    }else if ([cmd isEqualToString:@"5f"]) {
        //清除电能数据
        operationID = mk_bpm_taskClearAllEnergyDatasOperation;
    }else if ([cmd isEqualToString:@"61"]) {
        //同步时间
        operationID = mk_bpm_taskConfigDeviceTimeOperation;
    }else if ([cmd isEqualToString:@"62"]) {
        //恢复出厂设置
        operationID = mk_bpm_taskFactoryResetOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

#pragma mark - private method

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_bpm_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
