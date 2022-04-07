//
//  MKBPMScanPageModel.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKBPMScanPageModel : NSObject

/**
 当前model所在的row
 */
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, assign)NSInteger rssi;

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *macAddress;

/// 电压，v
@property (nonatomic, copy)NSString *voltage;

/// 电流，A
@property (nonatomic, copy)NSString *current;

/// 有功功率，w
@property (nonatomic, copy)NSString *power;

/// 功率因数，单位1%
@property (nonatomic, copy)NSString *powerFactor;

/// 当前电流频率，单位Hz
@property (nonatomic, copy)NSString *frequencyOfCurrent;

/// 设备总累计电能
@property (nonatomic, copy)NSString *energy;

/// 开关状态
@property (nonatomic, assign)BOOL switchStatus;

/// 有无负载
@property (nonatomic, assign)BOOL load;

/// 是否过压
@property (nonatomic, assign)BOOL overPressure;

/// 是否欠压
@property (nonatomic, assign)BOOL underVoltage;

/// 是否过流
@property (nonatomic, assign)BOOL overCurrent;

/// 是否过载
@property (nonatomic, assign)BOOL overLoad;

/// 是否需要密码连接
@property (nonatomic, assign)BOOL needPassword;

/// 是否可连接
@property (nonatomic, assign)BOOL connectable;

@property (nonatomic, strong)NSNumber *txPower;

/// cell上面显示的时间
@property (nonatomic, copy)NSString *scanTime;

/**
 上一次扫描到的时间
 */
@property (nonatomic, copy)NSString *lastScanDate;

@end

NS_ASSUME_NONNULL_END
