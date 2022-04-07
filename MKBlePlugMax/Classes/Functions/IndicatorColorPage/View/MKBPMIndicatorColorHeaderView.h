//
//  MKBPMIndicatorColorHeaderView.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2021/10/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBPMIndicatorColorHeaderViewDelegate <NSObject>

/// 用户选择了color
/// @param colorType 对应的结果如下:
/*
 bpm_ledColorTransitionDirectly,
 bpm_ledColorTransitionSmoothly,
 bpm_ledColorWhite,
 bpm_ledColorRed,
 bpm_ledColorGreen,
 bpm_ledColorBlue,
 bpm_ledColorOrange,
 bpm_ledColorCyan,
 bpm_ledColorPurple,
 */
- (void)bpm_colorSettingPickViewTypeChanged:(NSInteger)colorType;

@end

@interface MKBPMIndicatorColorHeaderView : UIView

@property (nonatomic, weak)id <MKBPMIndicatorColorHeaderViewDelegate>delegate;

/// 更新当前选中的color
/// @param colorType 对应的结果如下:
/*
 bpm_ledColorTransitionDirectly,
 bpm_ledColorTransitionSmoothly,
 bpm_ledColorWhite,
 bpm_ledColorRed,
 bpm_ledColorGreen,
 bpm_ledColorBlue,
 bpm_ledColorOrange,
 bpm_ledColorCyan,
 bpm_ledColorPurple,
 */
- (void)updateColorType:(NSInteger)colorType;

@end

NS_ASSUME_NONNULL_END
