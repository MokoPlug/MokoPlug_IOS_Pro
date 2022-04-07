//
//  MKBPMIndicatorModel.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/31.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMIndicatorModel.h"

#import "MKMacroDefines.h"

#import "MKBPMInterface.h"

@interface MKBPMIndicatorModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBPMIndicatorModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readBleIndicator]) {
            [self operationFailedBlockWithMsg:@"Read BLE advertising Error" block:failedBlock];
            return;
        }
        if (![self readProtectionSignal]) {
            [self operationFailedBlockWithMsg:@"Read Protection signal Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface

- (BOOL)readBleIndicator {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readIndicatorBleAdvertisingStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advertising = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readProtectionSignal {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readPowerIndicatorProtectionSignalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.signal = [returnData[@"result"][@"isOn"] boolValue];
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
        NSError *error = [[NSError alloc] initWithDomain:@"IndicatorSettingParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
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
        _readQueue = dispatch_queue_create("IndicatorSettingQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
