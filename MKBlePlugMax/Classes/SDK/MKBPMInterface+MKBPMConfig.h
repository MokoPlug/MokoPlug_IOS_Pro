//
//  MKBPMInterface+MKBPMConfig.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMInterface (MKBPMConfig)

#pragma mark ****************************************Device Parmas************************************************
/// Configure the broadcast name of the device.
/// @param deviceName 1~20 ascii characters
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configDeviceName:(NSString *)deviceName
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Do you need a password when configuring the device connection.
/// @param need need
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configNeedPassword:(BOOL)need
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the connection password of device.
/// @param password 8-character ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configPassword:(NSString *)password
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the power-on status of the device
/// @param status status
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configPowerOnSwitchStatus:(mk_bpm_switchStatus)status
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status reporting interval.
/// @param interval 1s~600s.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configSwitchReportInterval:(NSInteger)interval
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Power reporting interval.
/// @param interval 1s~600s.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configPowerReportInterval:(NSInteger)interval
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Whether the network indicator is turned on when the device is broadcasting.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configIndicatorBleAdvertisingStatus:(BOOL)isOn
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Network indicator status after the device is connected.
/// @param status status
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configIndicatorBleConnectedStatus:(mk_bpm_indicatorBleConnectedStatus)status
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Power indicator switch status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configPowerIndicatorStatus:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Power indicator light protection trigger indication function.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configPowerIndicatorProtectionSignal:(BOOL)isOn
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the txPower of device.
/// @param txPower txPower
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configTxPower:(mk_bpm_txPower)txPower
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Button control function switch.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configButtonSwitchFunction:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Whether to clear the stored energy when restoring to factory settings.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configResetClearEnergy:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure device broadcast time interval.
/// @param interval 1 x 100ms ~ 100 x 100ms
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configAdvInterval:(NSInteger)interval
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the connectable status of the device.
/// @param connectable connectable
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configConnectableStatus:(BOOL)connectable
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Time interval for energy storage.
/// @param interval 1min ~ 60mins.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configEnergyStorageInterval:(NSInteger)interval
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Threshold for power change storage.
/// @param threshold 1%~100%.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configEnergyStorageChangeThreshold:(NSInteger)threshold
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure device overload protection information.
/// @param isOn Open function
/// @param productModel Specification and model of the equipment
/// @param overThreshold Overload protection value, Europe and France: 10~4416W, U.K: 10~3558W, America: 10~2160W.
/// @param timeThreshold 1s~30s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configOverLoad:(BOOL)isOn
              productModel:(mk_bpm_productModel)productModel
             overThreshold:(NSInteger)overThreshold
             timeThreshold:(NSInteger)timeThreshold
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure device overvoltage protection information.
/// @param isOn Open function
/// @param productModel Specification and model of the equipment
/// @param overThreshold Overvoltage protection value, Europe and France: 231~264V, U.K: 231~264V, America: 121~138V.
/// @param timeThreshold 1s~30s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configOverVoltage:(BOOL)isOn
                 productModel:(mk_bpm_productModel)productModel
                overThreshold:(NSInteger)overThreshold
                timeThreshold:(NSInteger)timeThreshold
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure device sagvoltage protection information.
/// @param isOn Open function
/// @param productModel Specification and model of the equipment
/// @param overThreshold Sagvoltage protection value, Europe and France: 196~229V, U.K: 196~229V, America: 102~119V.
/// @param timeThreshold 1s~30s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configSagVoltage:(BOOL)isOn
                productModel:(mk_bpm_productModel)productModel
               overThreshold:(NSInteger)overThreshold
               timeThreshold:(NSInteger)timeThreshold
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure device overcurrent protection information.
/// @param isOn Open function
/// @param productModel Specification and model of the equipment
/// @param overThreshold Overcurrent protection value, Europe and France: 1~192(0.1A), U.K: 1~156(0.1A), America: 1~180(0.1A).
/// @param timeThreshold 1s~30s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configOverCurrent:(BOOL)isOn
                 productModel:(mk_bpm_productModel)productModel
                overThreshold:(NSInteger)overThreshold
                timeThreshold:(NSInteger)timeThreshold
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Power Indicator Color
/// @param colorType colorType
/// @param protocol  mk_bpm_ledColorConfigProtocol,Note: When colorType is one of mk_bpm_ledColorTransitionSmoothly and mk_bpm_ledColorTransitionDirectly, it cannot be empty, other types are not checked.
/// @param productModel Product model of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configPowerIndicatorColor:(mk_bpm_ledColorType)colorType
                        colorProtocol:(nullable id <mk_bpm_ledColorConfigProtocol>)protocol
                         productModel:(mk_bpm_productModel)productModel
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the notification status when the device load status changes.
/// @param startIsOn Load Start Notification Is On.
/// @param stopIsOn Load Stop Notification Is On.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configLoadStatusNotifications:(BOOL)startIsOn
                                 stopIsOn:(BOOL)stopIsOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************Control Parmas************************************************
    
/// Configure the state of the switch.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configSwitchState:(BOOL)isOn
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear overload status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_clearOverloadWithSucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear overcurrent status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_clearOvercurrentWithSucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear overvoltage status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_clearOvervoltageWithSucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear undervoltage status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_clearUndervoltageWithSucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// After the countdown is over, the current switch state is reversed.
/// @param second 1s~86400s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configCountdown:(NSInteger)second
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear all energy data.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_clearAllEnergyDatasWithSucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Sync device time.
/// @param protocol protocol
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_configDeviceTime:(id <mk_bpm_deviceTimeProtocol>)protocol
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_factoryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
