//
//  MKBPMIndicatorColorCell.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2021/10/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMIndicatorColorCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *placeholder;

@property (nonatomic, copy)NSString *textValue;

@property (nonatomic, assign)NSInteger index;

@end

@protocol MKBPMIndicatorColorCellDelegate <NSObject>

- (void)bpm_ledColorChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKBPMIndicatorColorCell : MKBaseCell

@property (nonatomic, strong)MKBPMIndicatorColorCellModel *dataModel;

@property (nonatomic, weak)id <MKBPMIndicatorColorCellDelegate>delegate;

+ (MKBPMIndicatorColorCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
