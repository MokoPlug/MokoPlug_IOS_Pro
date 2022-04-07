//
//  MKBPMAboutCell.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2021/4/30.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class MKBPMAboutDataModel;
@interface MKBPMAboutCell : MKBaseCell

@property (nonatomic, strong)MKBPMAboutDataModel *dataModel;

+ (MKBPMAboutCell *)initCellWithTableView:(UITableView *)table;

@end

NS_ASSUME_NONNULL_END
