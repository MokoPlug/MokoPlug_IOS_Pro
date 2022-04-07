//
//  MKBPMAdvertisementModel.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/29.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMAdvertisementModel : NSObject

@property (nonatomic, copy)NSString *advName;

@property (nonatomic, copy)NSString *advInterval;

/*
 0,   //RadioTxPower:-40dBm
 1,   //-20dBm
 2,    //-8dBm
 3,    //-4dBm
 4,       //0dBm
 5,       //4dBm
 6,       //8dBm
 */
@property (nonatomic, assign)NSInteger txPower;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
