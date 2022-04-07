//
//  MKBPMSettingModel.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/29.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMSettingModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, assign)BOOL connectable;

@property (nonatomic, assign)BOOL verification;

@property (nonatomic, assign)BOOL eraseEnergy;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
