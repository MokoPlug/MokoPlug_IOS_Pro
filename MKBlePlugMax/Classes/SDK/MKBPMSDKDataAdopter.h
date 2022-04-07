//
//  MKBPMSDKDataAdopter.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBPMSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMSDKDataAdopter : NSObject

+ (NSString *)fetchTxPowerValueString:(NSString *)content;

+ (NSString *)fetchTxPower:(mk_bpm_txPower)txPower;

+ (BOOL)checkLEDColorParams:(mk_bpm_ledColorType)colorType
              colorProtocol:(nullable id <mk_bpm_ledColorConfigProtocol>)protocol
               productModel:(mk_bpm_productModel)productModel;

+ (NSDictionary *)parseHourlyEnergyDatas:(NSString *)content;

+ (BOOL)validTimeProtocol:(id <mk_bpm_deviceTimeProtocol>)protocol;

+ (NSString *)getTimeString:(id <mk_bpm_deviceTimeProtocol>)protocol;

@end

NS_ASSUME_NONNULL_END
