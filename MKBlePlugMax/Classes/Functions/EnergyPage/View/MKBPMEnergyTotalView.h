//
//  MKBPMEnergyTotalView.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/4/1.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBPMEnergyTotalViewDelegate <NSObject>

- (void)bpm_resetEnergyData;

@end

@interface MKBPMEnergyTotalView : UIView

@property (nonatomic, weak)id <MKBPMEnergyTotalViewDelegate>delegate;

- (void)updateTotalEnergy:(NSString *)total;

@end

NS_ASSUME_NONNULL_END
