//
//  MKBPMEnergyReportModel.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/30.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMEnergyReportModel.h"

#import "MKMacroDefines.h"

#import "MKBPMInterface.h"
#import "MKBPMInterface+MKBPMConfig.h"

@interface MKBPMEnergyReportModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBPMEnergyReportModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readInterval]) {
            [self operationFailedBlockWithMsg:@"Read Interval Error" block:failedBlock];
            return;
        }
        if (![self readThreshold]) {
            [self operationFailedBlockWithMsg:@"Read Threshold Error" block:failedBlock];
            return;
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
        if (![self configInterval]) {
            [self operationFailedBlockWithMsg:@"Config Interval Error" block:failedBlock];
            return;
        }
        if (![self configThreshold]) {
            [self operationFailedBlockWithMsg:@"Config Threshold Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interfae
- (BOOL)readInterval {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readEnergyStorageIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.interval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configInterval {
    __block BOOL success = NO;
    [MKBPMInterface bpm_configEnergyStorageInterval:[self.interval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readThreshold {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readEnergyStorageChangeThresholdWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.threshold = returnData[@"result"][@"threshold"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configThreshold {
    __block BOOL success = NO;
    [MKBPMInterface bpm_configEnergyStorageChangeThreshold:[self.threshold integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"energySettingParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.interval) || [self.interval integerValue] < 1 || [self.interval integerValue] > 60) {
        return NO;
    }
    if (!ValidStr(self.threshold) || [self.threshold integerValue] < 1 || [self.threshold integerValue] > 100) {
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
        _readQueue = dispatch_queue_create("energySettingQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
