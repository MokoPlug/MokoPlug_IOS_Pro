//
//  MKBPMCentralManager.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

#import "MKBPMOperationID.h"
#import "MKBPMSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

//Notification of device connection status changes.
extern NSString *const mk_bpm_peripheralConnectStateChangedNotification;

//Notification of changes in the status of the Bluetooth Center.
extern NSString *const mk_bpm_centralManagerStateChangedNotification;

/*
 After connecting the device, if no password is entered within one minute, it returns 0x01. After successful password change, it returns 0x02.The device restart ,it returns 0x04.
 */
extern NSString *const mk_bpm_deviceDisconnectTypeNotification;

//Notification of device switch state change.
extern NSString *const mk_bpm_deviceSwitchStatusChangedNotification;

//Notification of load status change
extern NSString *const mk_bpm_deviceLoadStatusChangedNotification;

//Receive notification of total accumulated energy data of data
extern NSString *const mk_bpm_receiveTotalEnergyDataNotification;

//Receive notification of last 30 days of energy data.
extern NSString *const mk_bpm_receiveMonthlyEnergyDataNotification;

//Receive notification of hourly energy data for the day
extern NSString *const mk_bpm_receiveHourlyEnergyDataNotification;

//Overload(Unit:W)
extern NSString *const mk_bpm_receiveOverloadNotification;

//Overcurrent(Unit:mA)
extern NSString *const mk_bpm_receiveOverCurrentNotification;

//Overvaltage(Unit:V)
extern NSString *const mk_bpm_receiveOvervoltageNotification;

//undervoltage(Unit:V)
extern NSString *const mk_bpm_receiveUndervoltageNotification;

//Notification of device switch state countdown change.
extern NSString *const mk_bpm_deviceCountdownNotification;

//Device current power data notification
extern NSString *const mk_bpm_devicePowerDataNotification;

@class CBCentralManager,CBPeripheral;

@interface MKBPMCentralManager : NSObject<MKBLEBaseCentralManagerProtocol>

@property (nonatomic, weak)id <mk_bpm_centralManagerScanDelegate>delegate;

/// Current connection status
@property (nonatomic, assign, readonly)mk_bpm_centralConnectStatus connectStatus;

+ (MKBPMCentralManager *)shared;

/// Destroy the MKLoRaTHCentralManager singleton and the MKBLEBaseCentralManager singleton. After the dfu upgrade, you need to destroy these two and then reinitialize.
+ (void)sharedDealloc;

/// Destroy the MKLoRaTHCentralManager singleton and remove the manager list of MKBLEBaseCentralManager.
+ (void)removeFromCentralList;

- (nonnull CBCentralManager *)centralManager;

/// Currently connected devices
- (nullable CBPeripheral *)peripheral;

/// Current Bluetooth center status
- (mk_bpm_centralManagerStatus )centralStatus;

/// Bluetooth Center starts scanning
- (void)startScan;

/// Bluetooth center stops scanning
- (void)stopScan;

/// Connect device function.
/// @param peripheral peripheral
/// @param password Device connection password,8 characters long ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 password:(nonnull NSString *)password
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Connect device function.
/// @param peripheral peripheral
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

- (void)disconnect;

/// Start a task for data communication with the device
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param commandData Data to be sent to the device for this communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addTaskWithTaskID:(mk_bpm_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock;

/// Start a task to read device characteristic data
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addReadTaskWithTaskID:(mk_bpm_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
