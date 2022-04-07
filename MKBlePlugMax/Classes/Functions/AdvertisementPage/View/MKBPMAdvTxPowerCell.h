//
//  MKBPMAdvTxPowerCell.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/29.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_bpm_deviceTxPower) {
    mk_bpm_deviceTxPowerNeg40dBm,   //RadioTxPower:-40dBm
    mk_bpm_deviceTxPowerNeg20dBm,   //-20dBm
    mk_bpm_deviceTxPowerNeg8dBm,    //-8dBm
    mk_bpm_deviceTxPowerNeg4dBm,    //-4dBm
    mk_bpm_deviceTxPower0dBm,       //0dBm
    mk_bpm_deviceTxPower4dBm,       //4dBm
    mk_bpm_deviceTxPower8dBm,       //8dBm
};

@interface MKBPMAdvTxPowerCellModel : NSObject

@property (nonatomic, assign)mk_bpm_deviceTxPower txPower;

@end

@protocol MKBPMAdvTxPowerCellDelegate <NSObject>

- (void)mk_bpm_txPowerValueChanged:(mk_bpm_deviceTxPower)txPower;

@end

@interface MKBPMAdvTxPowerCell : MKBaseCell

@property (nonatomic, strong)MKBPMAdvTxPowerCellModel *dataModel;

@property (nonatomic, weak)id <MKBPMAdvTxPowerCellDelegate>delegate;

+ (MKBPMAdvTxPowerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
