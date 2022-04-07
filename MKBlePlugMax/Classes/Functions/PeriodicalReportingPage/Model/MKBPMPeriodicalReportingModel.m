//
//  MKBPMPeriodicalReportingModel.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/30.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMPeriodicalReportingModel.h"

#import "MKMacroDefines.h"

#import "MKBPMInterface.h"
#import "MKBPMInterface+MKBPMConfig.h"

@interface MKBPMPeriodicalReportingModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBPMPeriodicalReportingModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readSwitchInterval]) {
            [self operationFailedBlockWithMsg:@"Read Switch Interval Error" block:failedBlock];
            return;
        }
        if (![self readPowerInterval]) {
            [self operationFailedBlockWithMsg:@"Read Power Interval Error" block:failedBlock];
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
        if (![self configSwitchInterval]) {
            [self operationFailedBlockWithMsg:@"Config Switch Interval Error" block:failedBlock];
            return;
        }
        if (![self configPowerInterval]) {
            [self operationFailedBlockWithMsg:@"Config Power Interval Error" block:failedBlock];
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
- (BOOL)readSwitchInterval {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readSwitchReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.switchInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSwitchInterval {
    __block BOOL success = NO;
    [MKBPMInterface bpm_configSwitchReportInterval:[self.switchInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPowerInterval {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readPowerReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.powerInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPowerInterval {
    __block BOOL success = NO;
    [MKBPMInterface bpm_configPowerReportInterval:[self.powerInterval integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"reportingPageParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.switchInterval) || [self.switchInterval integerValue] < 1 || [self.switchInterval integerValue] > 600) {
        return NO;
    }
    if (!ValidStr(self.powerInterval) || [self.powerInterval integerValue] < 1 || [self.powerInterval integerValue] > 600) {
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
        _readQueue = dispatch_queue_create("reportingPageQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
