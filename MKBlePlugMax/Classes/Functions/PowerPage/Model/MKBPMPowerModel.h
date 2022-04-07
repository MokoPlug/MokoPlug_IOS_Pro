//
//  MKBPMPowerModel.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMPowerModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

/// 电压，v
@property (nonatomic, copy)NSString *voltage;

/// 电流，mA
@property (nonatomic, copy)NSString *current;

/// 有功功率，w
@property (nonatomic, copy)NSString *power;

/// 功率因数，单位1%
@property (nonatomic, copy)NSString *powerFactor;

/// 当前电流频率，单位Hz
@property (nonatomic, copy)NSString *frequencyOfCurrent;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
