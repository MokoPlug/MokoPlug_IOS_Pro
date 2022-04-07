//
//  MKBPMIndicatorModel.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/31.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMIndicatorModel : NSObject

@property (nonatomic, assign)BOOL advertising;

@property (nonatomic, assign)BOOL signal;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
