//
//  MKBPMProtectionConfigModel.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/30.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMProtectionConfigModel.h"

#import "MKMacroDefines.h"

#import "MKBPMInterface.h"
#import "MKBPMInterface+MKBPMConfig.h"

@interface MKBPMProtectionConfigModel ()

@property (nonatomic, assign)bpm_protectionConfigType type;

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBPMProtectionConfigModel

- (instancetype)initWithType:(bpm_protectionConfigType)type {
    if (self = [self init]) {
        self.type = type;
    }
    return self;
}

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readSpecification]) {
            [self operationFailedBlockWithMsg:@"Read Specification Error" block:failedBlock];
            return;
        }
        if (self.type == bpm_protectionConfigType_overload) {
            //过载
            if (![self readOverLoadProtectionData]) {
                [self operationFailedBlockWithMsg:@"Read Over Value Error" block:failedBlock];
                return;
            }
        }else if (self.type == bpm_protectionConfigType_overvoltage) {
            //过压
            if (![self readOverVoltageProtectionData]) {
                [self operationFailedBlockWithMsg:@"Read Over Value Error" block:failedBlock];
                return;
            }
        }else if (self.type == bpm_protectionConfigType_undervoltage) {
            //欠压
            if (![self readUnderVoltageProtectionData]) {
                [self operationFailedBlockWithMsg:@"Read Over Value Error" block:failedBlock];
                return;
            }
        }else if (self.type == bpm_protectionConfigType_overcurrent) {
            //过流
            if (![self readOverCurrentProtectionData]) {
                [self operationFailedBlockWithMsg:@"Read Over Value Error" block:failedBlock];
                return;
            }
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (self.type == bpm_protectionConfigType_overload) {
            //过载
            if (![self configOverLoadProtection]) {
                [self operationFailedBlockWithMsg:@"Config Over Value Error" block:failedBlock];
                return;
            }
        }else if (self.type == bpm_protectionConfigType_overvoltage) {
            //过压
            if (![self configOverVoltageProtection]) {
                [self operationFailedBlockWithMsg:@"Config Over Value Error" block:failedBlock];
                return;
            }
        }else if (self.type == bpm_protectionConfigType_undervoltage) {
            //欠压
            if (![self configUnderVoltageProtection]) {
                [self operationFailedBlockWithMsg:@"Config Over Value Error" block:failedBlock];
                return;
            }
        }else if (self.type == bpm_protectionConfigType_overcurrent) {
            //过流
            if (![self configOverCurrentProtection]) {
                [self operationFailedBlockWithMsg:@"Config Over Value Error" block:failedBlock];
                return;
            }
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readSpecification {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readSpecificationsOfDeviceWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.specification = [returnData[@"result"][@"specification"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOverVoltageProtectionData {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readOverVoltageProtectionWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        self.overThreshold = returnData[@"result"][@"overThreshold"];
        self.timeThreshold = returnData[@"result"][@"timeThreshold"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configOverVoltageProtection {
    __block BOOL success = NO;
    [MKBPMInterface bpm_configOverVoltage:self.isOn productModel:self.specification overThreshold:[self.overThreshold integerValue] timeThreshold:[self.timeThreshold integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readUnderVoltageProtectionData {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readUnderVoltageProtectionWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        self.overThreshold = returnData[@"result"][@"overThreshold"];
        self.timeThreshold = returnData[@"result"][@"timeThreshold"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUnderVoltageProtection {
    __block BOOL success = NO;
    [MKBPMInterface bpm_configUnderVoltage:self.isOn productModel:self.specification overThreshold:[self.overThreshold integerValue] timeThreshold:[self.timeThreshold integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOverCurrentProtectionData {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readOverCurrentProtectionWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        self.overThreshold = returnData[@"result"][@"overThreshold"];
        self.timeThreshold = returnData[@"result"][@"timeThreshold"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configOverCurrentProtection {
    __block BOOL success = NO;
    [MKBPMInterface bpm_configOverCurrent:self.isOn productModel:self.specification overThreshold:[self.overThreshold integerValue] timeThreshold:[self.timeThreshold integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOverLoadProtectionData {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readOverLoadProtectionWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        self.overThreshold = returnData[@"result"][@"overThreshold"];
        self.timeThreshold = returnData[@"result"][@"timeThreshold"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configOverLoadProtection {
    __block BOOL success = NO;
    [MKBPMInterface bpm_configOverLoad:self.isOn productModel:self.specification overThreshold:[self.overThreshold integerValue] timeThreshold:[self.timeThreshold integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"OverProtectionParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.overThreshold) || !ValidStr(self.timeThreshold) || [self.timeThreshold integerValue] < 1 || [self.timeThreshold integerValue] > 30) {
        return NO;
    }
    NSInteger maxValue = 0;
    NSInteger minValue = 0;
    if (self.type == bpm_protectionConfigType_overload) {
        //过载
        if (self.specification == 0) {
            //欧法
            minValue = 10;
            maxValue = 4416;
        }else if (self.specification == 1) {
            //美规
            minValue = 10;
            maxValue = 2160;
        }else if (self.specification == 2) {
            //英规
            minValue = 10;
            maxValue = 3588;
        }
    }else if (self.type == bpm_protectionConfigType_overvoltage) {
        //过压
        if (self.specification == 0) {
            //欧法
            minValue = 231;
            maxValue = 264;
        }else if (self.specification == 1) {
            //美规
            minValue = 121;
            maxValue = 138;
        }else if (self.specification == 2) {
            //英规
            minValue = 231;
            maxValue = 264;
        }
    }else if (self.type == bpm_protectionConfigType_undervoltage) {
        //欠压
        if (self.specification == 0) {
            //欧法
            minValue = 196;
            maxValue = 229;
        }else if (self.specification == 1) {
            //美规
            minValue = 102;
            maxValue = 119;
        }else if (self.specification == 2) {
            //英规
            minValue = 196;
            maxValue = 229;
        }
    }else if (self.type == bpm_protectionConfigType_overcurrent) {
        //过流
        if (self.specification == 0) {
            //欧法
            minValue = 1;
            maxValue = 192;
        }else if (self.specification == 1) {
            //美规
            minValue = 1;
            maxValue = 180;
        }else if (self.specification == 2) {
            //英规
            minValue = 1;
            maxValue = 156;
        }
    }
    if ([self.overThreshold integerValue] < minValue || [self.overThreshold integerValue] > maxValue) {
        return NO;
    }
    return YES;
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("OverProtectionQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
