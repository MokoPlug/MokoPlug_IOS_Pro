//
//  MKBPMSingleSelectedCell.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/31.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMSingleSelectedCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@interface MKBPMSingleSelectedCell : MKBaseCell

@property (nonatomic, strong)MKBPMSingleSelectedCellModel *dataModel;

+ (MKBPMSingleSelectedCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
