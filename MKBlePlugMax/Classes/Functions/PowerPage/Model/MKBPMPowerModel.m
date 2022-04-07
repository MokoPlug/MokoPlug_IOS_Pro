//
//  MKBPMPowerModel.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMPowerModel.h"

#import "MKMacroDefines.h"

#import "MKBPMInterface.h"

@interface MKBPMPowerModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBPMPowerModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readDeviceName]) {
            [self operationFailedBlockWithMsg:@"Read Device Name Error" block:failedBlock];
            return;
        }
        if (![self readPowerData]) {
            [self operationFailedBlockWithMsg:@"Read Power Data Error" block:failedBlock];
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
- (BOOL)readDeviceName {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readDeviceNameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceName = returnData[@"result"][@"deviceName"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPowerData {
    __block BOOL success = NO;
    [MKBPMInterface bpm_readPowerDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.voltage = returnData[@"result"][@"voltage"];
        self.current = returnData[@"result"][@"current"];
        self.power = returnData[@"result"][@"power"];
        self.frequencyOfCurrent = returnData[@"result"][@"frequencyOfCurrent"];
        self.powerFactor = returnData[@"result"][@"powerFactor"];
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
        NSError *error = [[NSError alloc] initWithDomain:@"PowerPageParams"
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
        _readQueue = dispatch_queue_create("PowerPageQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
