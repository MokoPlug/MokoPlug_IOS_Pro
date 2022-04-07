//
//  MKBPMScanPageCell.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBPMScanPageCellDelegate <NSObject>

/// 连接按钮点击事件
/// @param index 当前cell的row
- (void)bpm_scanCellConnectButtonPressed:(NSInteger)index;

@end

@class MKBPMScanPageModel;
@interface MKBPMScanPageCell : MKBaseCell

@property (nonatomic, strong)MKBPMScanPageModel *dataModel;

@property (nonatomic, weak)id <MKBPMScanPageCellDelegate>delegate;

+ (MKBPMScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
