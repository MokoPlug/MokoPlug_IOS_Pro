//
//  MKBPMInterface.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBPMSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMInterface : NSObject

#pragma mark ****************************************Device Service Information************************************************

/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the mac address of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************Device Parmas************************************************

/// Read the broadcast name of the device.
/*
 @{
 @"deviceName":@"MOKO"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Is a password required when the device is connected.
/*
 @{
 @"need":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readConnectationNeedPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

/// When the connected device requires a password, read the current connection password.
/*
 @{
 @"password":@"xxxxxxxxx"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the switch state when the device is just powered on.
/*
 @{
 @"mode":@"0",  //@"0":off  @"1":on  @"2":Restore to last status
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readPowerOnSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status reporting interval
/*
 @{
 @"interval":@"10",         //Unit:s
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readSwitchReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Power reporting interval.
/*
 @{
 @"interval":@"1",      //Unit:s
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readPowerReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Whether the network indicator is turned on when the device is broadcasting.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readIndicatorBleAdvertisingStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Network indicator status after the device is connected.
/*
 @{
 @"status":@"2",        //@"0":OFF      @"1":Solid blue for 5 seconds        @"2":Solid blue
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readIndicatorBleConnectedStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Power indicator switch status.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readPowerIndicatorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Power indicator light protection trigger indication function.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readPowerIndicatorProtectionSignalWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the txPower of device.
/*
 @{
 @"txPower":@"0dBm"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset by button functions is on.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readResetByButtonWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Button control function switch.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readButtonSwitchFunctionWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Whether to clear the stored energy when restoring to factory settings.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readResetClearEnergyWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the specifications of the device.
/*
 @{
 @"specification":0             //0:European and French specifications    1:U.S. specifications   2:U.K specifications
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readSpecificationsOfDeviceWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device broadcast time interval.(Unit:100ms)
/*
 @{
 @"interval":@"10"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the Bluetooth connection status of the device.When the device is set to be unconnectable, 3min is allowed to connect after the beacon mode is turned on.
/*
 @{
 @"connectable":@(YES),
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readDeviceConnectableWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Time interval for energy storage.
/*
 @{
 @"interval":@"1",      //Unit:Min
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readEnergyStorageIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Threshold for power change storage.
/*
 @{
 @"threshold":@"15",     //Unit:%
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readEnergyStorageChangeThresholdWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device overload protection information.
/*
 @{
     @"isOn":@(isOn),
     @"overThreshold":@"100",           //W
     @"timeThreshold":@"10",
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readOverLoadProtectionWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device overvoltage protection information.
/*
 @{
     @"isOn":@(isOn),
     @"overThreshold":@"100",           //V
     @"timeThreshold":@"10",
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readOverVoltageProtectionWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device underVoltage protection information.
/*
 @{
     @"isOn":@(isOn),
     @"overThreshold":@"10",            //V
     @"timeThreshold":@"10",
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readUnderVoltageProtectionWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device overcurrent protection information.
/*
 @{
     @"isOn":@(isOn),
     @"overThreshold":@"10",        //Unit:0.1A
     @"timeThreshold":@"10",
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readOverCurrentProtectionWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Power Indicator Color
/*
 @{
     @"colorType":@"0",
     @"blue":@"66",
     @"green":@"77",
     @"yellow":@"88",
     @"orange":@"99",
     @"red":@"100",
     @"purple":@"110",
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readPowerIndicatorColorWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the notification status when the device load status changes.
/*
 @{
     @"loadStart":@(NO),
     @"loadStop":@(YES),
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readLoadStatusNotificationsWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************Control Parmas************************************************

/// Read the state of the switch.
/*
 @{
 @"switchIsOn":@(YES),
 @"overload":@(NO),
 @"overcurrent":@(NO),
 @"overvoltage":@(NO),
 @"undervoltage":@(NO),
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readSwitchStateWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the current power data of the device.
/*
 @{
     @"voltage":@"220.2",       //V
     @"current":@"105",         //mA
     @"power":@"100.5",         //W
     @"frequencyOfCurrent":@"66.66",    //Hz
     @"powerFactor":@"0.55",    //
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readPowerDataWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Query the total accumulated energy data.
/*
 @{
 @"total":@"55.88",     //kW*h
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readTotalEnergyDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Query the energy data of the last 30 days.
/*
 @{
     @"year":year,
     @"month":month,
     @"day":day,
     @"hour":hour,
     @"number":@"1",        //How many days of energy data are currently stored.
     @"energyList":energyList,      //The first one in the array represents the energy data of the current day (year-month-day), the second represents the energy data of the previous day, the third represents the energy data of the previous two days, and so on.
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readMonthlyEnergyDataWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Query the hourly energy data of the day.
/*
 @{
     @"year":year,
     @"month":month,
     @"day":day,
     @"hour":hour,
     @"number":@"1",        //How many hours of energy data have been accumulated for the day.
     @"energyList":energyList,      //Each data represents one hour's electric energy data, the first one represents 0:00-1:00, the second 2:00-2:00, and so on.
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bpm_readHourlyEnergyDataWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
