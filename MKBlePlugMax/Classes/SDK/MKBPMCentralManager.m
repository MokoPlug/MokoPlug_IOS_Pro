//
//  MKBPMCentralManager.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMCentralManager.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseLogManager.h"

#import "MKBPMPeripheral.h"
#import "MKBPMOperation.h"
#import "CBPeripheral+MKBPMAdd.h"
#import "MKBPMSDKDataAdopter.h"

NSString *const mk_bpm_peripheralConnectStateChangedNotification = @"mk_bpm_peripheralConnectStateChangedNotification";
NSString *const mk_bpm_centralManagerStateChangedNotification = @"mk_bpm_centralManagerStateChangedNotification";

NSString *const mk_bpm_deviceDisconnectTypeNotification = @"mk_bpm_deviceDisconnectTypeNotification";

NSString *const mk_bpm_deviceSwitchStatusChangedNotification = @"mk_bpm_deviceSwitchStatusChangedNotification";
NSString *const mk_bpm_deviceLoadStatusChangedNotification = @"mk_bpm_deviceLoadStatusChangedNotification";
NSString *const mk_bpm_receiveTotalEnergyDataNotification = @"mk_bpm_receiveTotalEnergyDataNotification";
NSString *const mk_bpm_receiveMonthlyEnergyDataNotification = @"mk_bpm_receiveMonthlyEnergyDataNotification";
NSString *const mk_bpm_receiveHourlyEnergyDataNotification = @"mk_bpm_receiveHourlyEnergyDataNotification";
NSString *const mk_bpm_receiveOverloadNotification = @"mk_bpm_receiveOverloadNotification";
NSString *const mk_bpm_receiveOverCurrentNotification = @"mk_bpm_receiveOverCurrentNotification";
NSString *const mk_bpm_receiveOvervoltageNotification = @"mk_bpm_receiveOvervoltageNotification";
NSString *const mk_bpm_receiveUndervoltageNotification = @"mk_bpm_receiveUndervoltageNotification";

NSString *const mk_bpm_deviceCountdownNotification = @"mk_bpm_deviceCountdownNotification";
NSString *const mk_bpm_devicePowerDataNotification = @"mk_bpm_devicePowerDataNotification";


static MKBPMCentralManager *manager = nil;
static dispatch_once_t onceToken;

//@interface NSObject (MKBPMCentralManager)
//
//@end
//
//@implementation NSObject (MKBPMCentralManager)
//
//+ (void)load{
//    [MKBPMCentralManager shared];
//}
//
//@end

@interface MKBPMCentralManager ()

@property (nonatomic, copy)NSString *password;

@property (nonatomic, copy)void (^sucBlock)(CBPeripheral *peripheral);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, assign)mk_bpm_centralConnectStatus connectStatus;

@end

@implementation MKBPMCentralManager

- (instancetype)init {
    if (self = [super init]) {
        [[MKBLEBaseCentralManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKBPMCentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKBPMCentralManager new];
        }
    });
    return manager;
}

+ (void)sharedDealloc {
    [MKBLEBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

+ (void)removeFromCentralList {
    [[MKBLEBaseCentralManager shared] removeDataManager:manager];
    manager = nil;
    onceToken = 0;
}

#pragma mark - MKBLEBaseScanProtocol
- (void)MKBLEBaseCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                                advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                             RSSI:(NSNumber *)RSSI {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@",advertisementData);
        NSDictionary *dataModel = [self parseModelWithRssi:RSSI advDic:advertisementData peripheral:peripheral];
        if (!MKValidDict(dataModel)) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(mk_bpm_receiveDevice:)]) {
                [self.delegate mk_bpm_receiveDevice:dataModel];
            }
        });
    });
}

- (void)MKBLEBaseCentralManagerStartScan {
    if ([self.delegate respondsToSelector:@selector(mk_bpm_startScan)]) {
        [self.delegate mk_bpm_startScan];
    }
}

- (void)MKBLEBaseCentralManagerStopScan {
    if ([self.delegate respondsToSelector:@selector(mk_bpm_stopScan)]) {
        [self.delegate mk_bpm_stopScan];
    }
}

#pragma mark - MKBLEBaseCentralManagerStateProtocol
- (void)MKBLEBaseCentralManagerStateChanged:(MKCentralManagerState)centralManagerState {
    NSLog(@"蓝牙中心改变");
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_centralManagerStateChangedNotification object:nil];
}

- (void)MKBLEBasePeripheralConnectStateChanged:(MKPeripheralConnectState)connectState {
    //连接成功的判断必须是发送密码成功之后
    if (connectState == MKPeripheralConnectStateUnknow) {
        self.connectStatus = mk_bpm_centralConnectStatusUnknow;
    }else if (connectState == MKPeripheralConnectStateConnecting) {
        self.connectStatus = mk_bpm_centralConnectStatusConnecting;
    }else if (connectState == MKPeripheralConnectStateConnectedFailed) {
        self.connectStatus = mk_bpm_centralConnectStatusConnectedFailed;
    }else if (connectState == MKPeripheralConnectStateDisconnect) {
        self.connectStatus = mk_bpm_centralConnectStatusDisconnect;
    }
    NSLog(@"当前连接状态发生改变了:%@",@(connectState));
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_peripheralConnectStateChangedNotification object:nil];
}

#pragma mark - MKBLEBaseCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        [self parseNotifications:characteristic.value];
        return;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        return;
    }
    
}

#pragma mark - public method
- (CBCentralManager *)centralManager {
    return [MKBLEBaseCentralManager shared].centralManager;
}

- (CBPeripheral *)peripheral {
    return [MKBLEBaseCentralManager shared].peripheral;
}

- (mk_bpm_centralManagerStatus )centralStatus {
    return ([MKBLEBaseCentralManager shared].centralStatus == MKCentralManagerStateEnable)
    ? mk_bpm_centralManagerStatusEnable
    : mk_bpm_centralManagerStatusUnable;
}

- (void)startScan {
    [[MKBLEBaseCentralManager shared] scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"AA06"]] options:nil];
}

- (void)stopScan {
    [[MKBLEBaseCentralManager shared] stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
                 sucBlock:(void (^)(CBPeripheral * _Nonnull))sucBlock
              failedBlock:(void (^)(NSError * error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    if (password.length != 8 || ![MKBLEBaseSDKAdopter asciiString:password]) {
        [self operationFailedBlockWithMsg:@"The password should be 8 characters." failedBlock:failedBlock];
        return;
    }
    self.password = @"";
    self.password = password;
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    self.password = @"";
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)disconnect {
    [[MKBLEBaseCentralManager shared] disconnect];
}

- (void)addTaskWithTaskID:(mk_bpm_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock {
    MKBPMOperation <MKBLEBaseOperationProtocol>*operation = [self generateOperationWithOperationID:operationID
                                                                                    characteristic:characteristic
                                                                                       commandData:commandData
                                                                                      successBlock:successBlock
                                                                                      failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addReadTaskWithTaskID:(mk_bpm_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock {
    MKBPMOperation <MKBLEBaseOperationProtocol>*operation = [self generateReadOperationWithOperationID:operationID
                                                                                        characteristic:characteristic
                                                                                          successBlock:successBlock
                                                                                          failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - password method
- (void)connectPeripheral:(CBPeripheral *)peripheral
             successBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    MKBPMPeripheral *trackerPeripheral = [[MKBPMPeripheral alloc] initWithPeripheral:peripheral];
    [[MKBLEBaseCentralManager shared] connectDevice:trackerPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        if (MKValidStr(self.password) && self.password.length == 8) {
            //需要密码登录
            [self sendPasswordToDevice];
            return;
        }
        //免密登录
        MKBLEBase_main_safe(^{
            self.connectStatus = mk_bpm_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_peripheralConnectStateChangedNotification object:nil];
            if (self.sucBlock) {
                self.sucBlock(peripheral);
            }
        });
    } failedBlock:failedBlock];
}

- (void)sendPasswordToDevice {
    NSString *commandData = @"ed010108";
    for (NSInteger i = 0; i < self.password.length; i ++) {
        int asciiCode = [self.password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    __weak typeof(self) weakSelf = self;
    MKBPMOperation *operation = [[MKBPMOperation alloc] initOperationWithID:mk_bpm_connectPasswordOperation commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBLEBaseCentralManager shared].peripheral.bpm_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error || !MKValidDict(returnData) || ![returnData[@"state"] isEqualToString:@"01"]) {
            //密码错误
            [sself operationFailedBlockWithMsg:@"Password Error" failedBlock:sself.failedBlock];
            return ;
        }
        //密码正确
        MKBLEBase_main_safe(^{
            sself.connectStatus = mk_bpm_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_peripheralConnectStateChangedNotification object:nil];
            if (sself.sucBlock) {
                sself.sucBlock([MKBLEBaseCentralManager shared].peripheral);
            }
        });
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - task method
- (MKBPMOperation <MKBLEBaseOperationProtocol>*)generateOperationWithOperationID:(mk_bpm_taskOperationID)operationID
                                                                  characteristic:(CBCharacteristic *)characteristic
                                                                     commandData:(NSString *)commandData
                                                                    successBlock:(void (^)(id returnData))successBlock
                                                                    failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!MKValidStr(commandData)) {
        [self operationFailedBlockWithMsg:@"The data sent to the device cannot be empty" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBPMOperation <MKBLEBaseOperationProtocol>*operation = [[MKBPMOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (MKBPMOperation <MKBLEBaseOperationProtocol>*)generateReadOperationWithOperationID:(mk_bpm_taskOperationID)operationID
                                                                      characteristic:(CBCharacteristic *)characteristic
                                                                        successBlock:(void (^)(id returnData))successBlock
                                                                        failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBPMOperation <MKBLEBaseOperationProtocol>*operation = [[MKBPMOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBLEBaseCentralManager shared].peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

#pragma mark - private method
- (NSDictionary *)parseModelWithRssi:(NSNumber *)rssi advDic:(NSDictionary *)advDic peripheral:(CBPeripheral *)peripheral {
    if ([rssi integerValue] == 127 || !MKValidDict(advDic) || !peripheral) {
        return @{};
    }
    
    NSData *manufacturerData = advDic[CBAdvertisementDataManufacturerDataKey];
    if (manufacturerData.length != 25) {
        return @{};
    }
    NSString *header = [[MKBLEBaseSDKAdopter hexStringFromData:manufacturerData] substringWithRange:NSMakeRange(0, 4)];
    if (![[header uppercaseString] isEqualToString:@"06AA"]) {
        return @{};
    }
    NSString *content = [[MKBLEBaseSDKAdopter hexStringFromData:manufacturerData] substringFromIndex:4];
    
    NSString *tempMac = [[content substringWithRange:NSMakeRange(0, 12)] uppercaseString];
    NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
    [tempMac substringWithRange:NSMakeRange(0, 2)],
    [tempMac substringWithRange:NSMakeRange(2, 2)],
    [tempMac substringWithRange:NSMakeRange(4, 2)],
    [tempMac substringWithRange:NSMakeRange(6, 2)],
    [tempMac substringWithRange:NSMakeRange(8, 2)],
    [tempMac substringWithRange:NSMakeRange(10, 2)]];
    
    NSInteger voltageValue = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(12, 4)];
    NSString *voltage = [NSString stringWithFormat:@"%.1f",(voltageValue * 0.1)];
    
    NSNumber *currentNumer = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(16, 4)]];
    NSString *current = [NSString stringWithFormat:@"%.3f",([currentNumer integerValue] * 0.001)];
    
    NSNumber *activePowerNumber = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(20, 8)]];
    NSString *power = [NSString stringWithFormat:@"%.1f",([activePowerNumber integerValue] * 0.1)];
    
    NSString *powerFactor = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(28, 2)];
    
    NSInteger currentFrequencyValue = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(30, 4)];
    NSString *frequencyOfCurrent = [NSString stringWithFormat:@"%.2f",(currentFrequencyValue * 0.01)];
    
    NSInteger totalEnergyValue = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(34, 8)];
    NSString *totalEnergy = [NSString stringWithFormat:@"%.3f",(totalEnergyValue * 0.001)];
    
    NSNumber *txPower = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(42, 2)]];
    
    NSString *state = [content substringWithRange:NSMakeRange(44, 2)];
    NSString *binary = [MKBLEBaseSDKAdopter binaryByhex:state];
    
    BOOL switchState = [[binary substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"];
    BOOL load = [[binary substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"1"];
    BOOL overLoad = [[binary substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"];
    BOOL overCurrent = [[binary substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"];
    BOOL overVoltage = [[binary substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
    BOOL underVoltage = [[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
    BOOL needPassword = [[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
    BOOL connectable = [[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
     
    return @{
        @"rssi":rssi,
        @"peripheral":peripheral,
        @"deviceName":(advDic[CBAdvertisementDataLocalNameKey] ? advDic[CBAdvertisementDataLocalNameKey] : @""),
        @"macAddress":macAddress,
        @"voltage":voltage,
        @"current":current,
        @"power":power,
        @"powerFactor":powerFactor,
        @"frequencyOfCurrent":frequencyOfCurrent,
        @"energy":totalEnergy,
        @"switchStatus":@(switchState),
        @"load":@(load),
        @"overPressure":@(overVoltage),
        @"underVoltage":@(underVoltage),
        @"overCurrent":@(overCurrent),
        @"overLoad":@(overLoad),
        @"needPassword":@(needPassword),
        @"connectable":@(connectable),
        @"txPower":txPower,
    };
}
- (void)parseNotifications:(NSData *)characteristicData {
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristicData];
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(6, 2)];
    if (characteristicData.length != dataLen + 4) {
        return ;
    }
    NSString *cmd = [content substringWithRange:NSMakeRange(4, 2)];
    NSString *dataContent = [content substringFromIndex:8];
    if ([cmd isEqualToString:@"01"]) {
        //引起设备断开连接的类型
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_deviceDisconnectTypeNotification
                                                            object:nil
                                                          userInfo:@{@"type":dataContent}];
        return;
    }
    if ([cmd isEqualToString:@"02"]) {
        //开关状态通知
        BOOL isOn = [[dataContent substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_deviceSwitchStatusChangedNotification
                                                            object:nil
                                                          userInfo:@{@"isOn":@(isOn)}];
        return;
    }
    if ([cmd isEqualToString:@"03"]) {
        //电量信息
        NSInteger voltageValue = [MKBLEBaseSDKAdopter getDecimalWithHex:dataContent range:NSMakeRange(0, 4)];
        NSString *voltage = [NSString stringWithFormat:@"%.1f",(voltageValue * 0.1)];
        
        NSNumber *currentNumer = [MKBLEBaseSDKAdopter signedHexTurnString:[dataContent substringWithRange:NSMakeRange(4, 4)]];
        NSString *current = [NSString stringWithFormat:@"%ld",(long)[currentNumer integerValue]];
        
        NSNumber *activePowerNumber = [MKBLEBaseSDKAdopter signedHexTurnString:[dataContent substringWithRange:NSMakeRange(8, 8)]];
        NSString *power = [NSString stringWithFormat:@"%.1f",([activePowerNumber integerValue] * 0.1)];
        
        NSInteger currentFrequencyValue = [MKBLEBaseSDKAdopter getDecimalWithHex:dataContent range:NSMakeRange(16, 4)];
        NSString *frequencyOfCurrent = [NSString stringWithFormat:@"%.2f",(currentFrequencyValue * 0.01)];
        
        NSInteger powerFactorValue = [MKBLEBaseSDKAdopter getDecimalWithHex:dataContent range:NSMakeRange(20, 2)];
        NSString *powerFactor = [NSString stringWithFormat:@"%.2f",(powerFactorValue * 0.01)];
        
        NSDictionary *dic = @{
            @"voltage":voltage,
            @"current":current,
            @"power":power,
            @"frequencyOfCurrent":frequencyOfCurrent,
            @"powerFactor":powerFactor,
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_devicePowerDataNotification
                                                            object:nil
                                                          userInfo:dic];
        return;
    }
    if ([cmd isEqualToString:@"04"]) {
        //负载变化通知
        BOOL load = [dataContent isEqualToString:@"01"];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_deviceLoadStatusChangedNotification
                                                            object:nil
                                                          userInfo:@{@"load":@(load)}];
        return;
    }
    if ([cmd isEqualToString:@"05"]) {
        //总累计电能
        NSInteger energy = [MKBLEBaseSDKAdopter getDecimalWithHex:dataContent range:NSMakeRange(0, dataContent.length)];
        NSString *energyValue = [NSString stringWithFormat:@"%.3f",(energy * 0.001)];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_receiveTotalEnergyDataNotification
                                                            object:nil
                                                          userInfo:@{@"total":energyValue}];
        return;
    }
    if ([cmd isEqualToString:@"06"]) {
        //最近30天电能
        NSDictionary *dic = [MKBPMSDKDataAdopter parseDailyEnergyDatas:dataContent];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_receiveMonthlyEnergyDataNotification
                                                            object:nil
                                                          userInfo:dic];
        return;
    }
    if ([cmd isEqualToString:@"07"]) {
        //当天每小时电能
        NSDictionary *dic = [MKBPMSDKDataAdopter parseHourlyEnergyDatas:dataContent];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_receiveHourlyEnergyDataNotification
                                                            object:nil
                                                          userInfo:dic];
        return;
    }
    if ([cmd isEqualToString:@"08"]) {
        //过载
        BOOL overload = [[dataContent substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"];
        NSInteger currentPower = [MKBLEBaseSDKAdopter getDecimalWithHex:dataContent range:NSMakeRange(2, 8)];
        NSString *currentPowerValue = [NSString stringWithFormat:@"%.1f",(currentPower * 0.1)];
        NSInteger protectionPower = [MKBLEBaseSDKAdopter getDecimalWithHex:dataContent range:NSMakeRange(10, 4)];
        NSString *protectionPowerValue = [NSString stringWithFormat:@"%.1f",(protectionPower * 0.1)];
        NSDictionary *dic = @{
            @"overload":@(overload),
            @"currentPowerValue":currentPowerValue,
            @"protectionPowerValue":protectionPowerValue,
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_receiveOverloadNotification
                                                            object:nil
                                                          userInfo:dic];
        return;
    }
    if ([cmd isEqualToString:@"09"]) {
        //过流
        BOOL overcurrent = [[dataContent substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"];
        NSString *current = [MKBLEBaseSDKAdopter getDecimalStringWithHex:dataContent range:NSMakeRange(2, 4)];
        NSString *protectionCurrent = [MKBLEBaseSDKAdopter getDecimalStringWithHex:dataContent range:NSMakeRange(6, 4)];
        NSDictionary *dic = @{
            @"overcurrent":@(overcurrent),
            @"current":current,
            @"protectionCurrent":protectionCurrent,
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_receiveOverCurrentNotification
                                                            object:nil
                                                          userInfo:dic];
        return;
    }
    if ([cmd isEqualToString:@"0a"]) {
        //过压
        BOOL overvoltage = [[dataContent substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"];
        NSInteger voltage = [MKBLEBaseSDKAdopter getDecimalWithHex:dataContent range:NSMakeRange(2, 4)];
        NSString *voltageValue = [NSString stringWithFormat:@"%.1f",(voltage * 0.1)];
        NSInteger protectionVoltage = [MKBLEBaseSDKAdopter getDecimalWithHex:dataContent range:NSMakeRange(6, 4)];
        NSString *protectionVoltageValue = [NSString stringWithFormat:@"%.1f",(protectionVoltage * 0.1)];
        NSDictionary *dic = @{
            @"overvoltage":@(overvoltage),
            @"voltage":voltageValue,
            @"protectionVoltage":protectionVoltageValue,
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_receiveOvervoltageNotification
                                                            object:nil
                                                          userInfo:dic];
        return;
    }
    if ([cmd isEqualToString:@"0b"]) {
        //欠压
        BOOL undervoltage = [[dataContent substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"];
        NSInteger voltage = [MKBLEBaseSDKAdopter getDecimalWithHex:dataContent range:NSMakeRange(2, 4)];
        NSString *voltageValue = [NSString stringWithFormat:@"%.1f",(voltage * 0.1)];
        NSInteger protectionVoltage = [MKBLEBaseSDKAdopter getDecimalWithHex:dataContent range:NSMakeRange(6, 4)];
        NSString *protectionVoltageValue = [NSString stringWithFormat:@"%.1f",(protectionVoltage * 0.1)];
        NSDictionary *dic = @{
            @"undervoltage":@(undervoltage),
            @"voltage":voltageValue,
            @"protectionVoltage":protectionVoltageValue,
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_receiveUndervoltageNotification
                                                            object:nil
                                                          userInfo:dic];
        return;
    }
    if ([cmd isEqualToString:@"0c"]) {
        //倒计时
        BOOL isOn = [[dataContent substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"];
        NSString *remainingTime = [MKBLEBaseSDKAdopter getDecimalStringWithHex:dataContent range:NSMakeRange(2, dataContent.length - 2)];
        NSDictionary *dic = @{
            @"isOn":@(isOn),
            @"remainingTime":remainingTime,
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bpm_deviceCountdownNotification
                                                            object:nil
                                                          userInfo:dic];
        return;
    }
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.MPCentralManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    MKBLEBase_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

@end
