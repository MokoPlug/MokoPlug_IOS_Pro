//
//  MKBPMSwitchModel.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMSwitchModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, assign)BOOL overload;

@property (nonatomic, assign)BOOL overcurrent;

@property (nonatomic, assign)BOOL overvoltage;

@property (nonatomic, assign)BOOL undervoltage;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
