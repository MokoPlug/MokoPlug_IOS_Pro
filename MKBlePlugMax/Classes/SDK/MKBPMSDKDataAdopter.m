//
//  MKBPMSDKDataAdopter.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMSDKDataAdopter.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

@implementation MKBPMSDKDataAdopter

+ (NSString *)fetchTxPowerValueString:(NSString *)content {
    if ([content isEqualToString:@"08"]) {
        return @"8dBm";
    }
    if ([content isEqualToString:@"04"]) {
        return @"4dBm";
    }
    if ([content isEqualToString:@"00"]) {
        return @"0dBm";
    }
    if ([content isEqualToString:@"fc"]) {
        return @"-4dBm";
    }
    if ([content isEqualToString:@"f8"]) {
        return @"-8dBm";
    }
    if ([content isEqualToString:@"ec"]) {
        return @"-20dBm";
    }
    if ([content isEqualToString:@"d8"]) {
        return @"-40dBm";
    }
    return @"0dBm";
}

+ (NSString *)fetchTxPower:(mk_bpm_txPower)txPower {
    switch (txPower) {
        case mk_bpm_txPower8dBm:
            return @"08";
            
        case mk_bpm_txPower4dBm:
            return @"04";
            
        case mk_bpm_txPower0dBm:
            return @"00";
            
        case mk_bpm_txPowerNeg4dBm:
            return @"fc";
            
        case mk_bpm_txPowerNeg8dBm:
            return @"f8";
    
        case mk_bpm_txPowerNeg20dBm:
            return @"ec";
            
        case mk_bpm_txPowerNeg40dBm:
            return @"d8";
    }
}

+ (BOOL)checkLEDColorParams:(mk_bpm_ledColorType)colorType
              colorProtocol:(nullable id <mk_bpm_ledColorConfigProtocol>)protocol
               productModel:(mk_bpm_productModel)productModel {
    if (colorType == mk_bpm_ledColorTransitionSmoothly || colorType == mk_bpm_ledColorTransitionDirectly) {
        if (!protocol || ![protocol conformsToProtocol:@protocol(mk_bpm_ledColorConfigProtocol)]) {
            return NO;
        }
        NSInteger maxValue = 4416;
        if (productModel == mk_bpm_productModel_America) {
            maxValue = 2160;
        }else if (productModel == mk_bpm_productModel_UK) {
            maxValue = 3588;
        }
        if (protocol.b_color < 1 || protocol.b_color > (maxValue - 5)) {
            return NO;
        }
        if (protocol.g_color <= protocol.b_color || protocol.g_color > (maxValue - 4)) {
            return NO;
        }
        if (protocol.y_color <= protocol.g_color || protocol.y_color > (maxValue - 3)) {
            return NO;
        }
        if (protocol.o_color <= protocol.y_color || protocol.o_color > (maxValue - 2)) {
            return NO;
        }
        if (protocol.r_color <= protocol.o_color || protocol.r_color > (maxValue - 1)) {
            return NO;
        }
        if (protocol.p_color <= protocol.r_color || protocol.p_color > maxValue) {
            return NO;
        }
    }
    return YES;
}

+ (NSDictionary *)parseHourlyEnergyDatas:(NSString *)content {
    if (!MKValidStr(content) || content.length < 16) {
        return @{};
    }
    NSString *year = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
    NSString *month = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)];
    if (month.length == 1) {
        month = [@"0" stringByAppendingString:month];
    }
    NSString *day = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 2)];
    if (day.length == 1) {
        day = [@"0" stringByAppendingString:day];
    }
    NSString *hour = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)];
    if (hour.length == 1) {
        hour = [@"0" stringByAppendingString:hour];
    }
    NSString *number = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 2)];
    NSString *subContent = [content substringFromIndex:12];
    NSMutableArray *energyList = [NSMutableArray array];
    for (NSInteger i = 0; i < [number integerValue]; i ++) {
        NSInteger energyValue = [MKBLEBaseSDKAdopter getDecimalWithHex:subContent range:NSMakeRange(i * 4, 4)];
        NSString *energy = [NSString stringWithFormat:@"%.2f",(energyValue * 0.01)];
        [energyList addObject:energy];
    }
    return @{
        @"year":year,
        @"month":month,
        @"day":day,
        @"hour":hour,
        @"number":number,
        @"energyList":energyList
    };
}

+ (BOOL)validTimeProtocol:(id <mk_bpm_deviceTimeProtocol>)protocol {
    if (!protocol) {
        return NO;
    }
    if (protocol.year < 2000 || protocol.year > 2099) {
        return NO;
    }
    if (protocol.month < 1 || protocol.month > 12) {
        return NO;
    }
    if (protocol.day < 1 || protocol.day > 31) {
        return NO;
    }
    if (protocol.hour < 0 || protocol.hour > 23) {
        return NO;
    }
    if (protocol.minutes < 0 || protocol.minutes > 59) {
        return NO;
    }
    if (protocol.seconds < 0 || protocol.seconds > 59) {
        return NO;
    }
    return YES;
}

+ (NSString *)getTimeString:(id <mk_bpm_deviceTimeProtocol>)protocol {
    if (!protocol) {
        return @"";
    }
    
    NSString *yearString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.year byteLen:2];
    NSString *monthString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.month byteLen:1];
    NSString *dayString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.day byteLen:1];
    NSString *hourString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.hour byteLen:1];
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.minutes byteLen:1];
    NSString *secString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.seconds byteLen:1];
    return [NSString stringWithFormat:@"%@%@%@%@%@%@",yearString,monthString,dayString,hourString,minString,secString];
}

@end
